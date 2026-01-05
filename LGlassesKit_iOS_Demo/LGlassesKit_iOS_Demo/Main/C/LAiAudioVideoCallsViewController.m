//
//  LAiAudioVideoCallsViewController.m
//  LGlassesKit_iOS_Demo
//
//  Created by LINWEAR on 2025-12-26.
//

#import "LAiAudioVideoCallsViewController.h"
#import "LAssistantModel.h"
#import "LUserTextCell.h"
#import "LAssistantTextCell.h"
// 引入 ZegoExpressEngine.h 头文件
#import <ZegoExpressEngine/ZegoExpressEngine.h>

@interface LAiAudioVideoCallsViewController () <ZegoEventHandler, ZegoAudioDataHandler, UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSMutableArray <LAssistantModel *> *dataSource;

@property (nonatomic, assign) BOOL isScrollingToBottom; // 是否正在自动滚动到底部
@property (nonatomic, assign) BOOL shouldScrollToBottom; // 是否需要自动滚动到底部
@property (nonatomic, assign) CGFloat lastContentOffset; // 记录上次滚动位置

//拉取播放其他用户音视频流的 view
@property (strong, nonatomic) UIView *remoteUserView;
//通话结束按钮
@property (strong, nonatomic) UIButton *callEndButton;
//麦克风
@property (strong, nonatomic) UIButton *voiceButton;
//声音
@property (strong, nonatomic) UIButton *soundButton;
//是否发送音频
@property (nonatomic, assign) BOOL sendAudio;

@end

static NSString *const LUserTextCellID = @"LUserTextCell";
static NSString *const LAssistantTextCellID = @"LAssistantTextCell";

@implementation LAiAudioVideoCallsViewController

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self shareHostUrl];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    LAIGC.sharedManager.allowUseVoiceAssistant = NO;
    
    self.shouldScrollToBottom = YES; // 初始状态需要滚动到底部
    self.isScrollingToBottom = NO;
    
    /**
     大概流程：
     1. 创建服务，注册相关回调
     2. 登录房间，登录成功后启动本地预览
     3. 为避免不必要流量浪费，用户进入房间后才开始推流、拉流、开始翻译、发送音频数据
     */
    
    [self startVideoTalk]; // 开始
    
    // 列表
    UITableView *tableView = [ATools mainTableView:self style:UITableViewStylePlain cellIds:@[LUserTextCellID, LAssistantTextCellID] headerFooterIds:nil];
    tableView.backgroundColor = UIColor.clearColor;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:tableView];
    self.tableView = tableView;
    
    self.dataSource = [NSMutableArray array];
    
    
    UIView *remoteUserView = UIView.new;
    remoteUserView.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:remoteUserView];
    self.remoteUserView = remoteUserView;

    LWEAKSELF
    UIButton *callEndButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [callEndButton setImage:UIImageMake(@"ic_phone_call_hang_up") forState:UIControlStateNormal];
    [self.view addSubview:callEndButton];
    self.callEndButton = callEndButton;
    // 按钮事件
    [ATools addAction:callEndButton callback:^{
        
        [weakSelf stopVideoTalk]; // 结束
    }];
    
    UIButton *voiceButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [voiceButton setImage:UIImageMake(@"ic_phone_call_voice_off") forState:UIControlStateNormal];
    [voiceButton setImage:UIImageMake(@"ic_phone_call_voice_on") forState:UIControlStateSelected];
    voiceButton.selected = YES;
    [self.view addSubview:voiceButton];
    self.voiceButton = voiceButton;
    // 按钮事件
    [ATools addAction:voiceButton callback:^{
        weakSelf.voiceButton.selected = !weakSelf.voiceButton.selected;
        
        [[ZegoExpressEngine sharedEngine] muteMicrophone:!weakSelf.voiceButton.selected];
    }];
    
    
    UIButton *soundButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [soundButton setImage:UIImageMake(@"ic_phone_call_sound_off") forState:UIControlStateNormal];
    [soundButton setImage:UIImageMake(@"ic_phone_call_sound_on") forState:UIControlStateSelected];
    soundButton.selected = YES;
    [self.view addSubview:soundButton];
    self.soundButton = soundButton;
    // 按钮事件
    [ATools addAction:soundButton callback:^{
        weakSelf.soundButton.selected = !weakSelf.soundButton.selected;
        [[ZegoExpressEngine sharedEngine] muteSpeaker:!weakSelf.soundButton.selected];
    }];
    
    
    // 通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(translationNotify:) name:LAIGCCallTranslationNotify object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(aigcConnectionSuccessful) name:LAIGCConnectionSuccessfulNotify object:nil];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    UIEdgeInsets safeAreaInsets = self.safeAreaInsets;
    
    [self.tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(safeAreaInsets);
    }];
    
    [self.remoteUserView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(150, 200));
        make.right.mas_equalTo(0);
        make.centerY.mas_equalTo(self.view);
    }];
    
    [self.callEndButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(-safeAreaInsets.bottom);
        make.centerX.mas_equalTo(self.view);
    }];
    
    [self.voiceButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.callEndButton.mas_centerY);
        make.right.mas_equalTo(self.callEndButton.mas_left).offset(-50);
    }];
    
    [self.soundButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.callEndButton.mas_centerY);
        make.left.mas_equalTo(self.callEndButton.mas_right).offset(50);
    }];
}

- (void)shareHostUrl {
    NSURL *shareURL = [NSURL URLWithString:self.roomModel.hostUrl];

    // 准备分享项目数组
    NSArray *activityItems = @[shareURL];

    // 创建并显示分享控制器
    UIActivityViewController *activityVC = [[UIActivityViewController alloc]
                                            initWithActivityItems:activityItems
                                            applicationActivities:nil];

    // 显示分享界面
    [self presentViewController:activityVC animated:YES completion:nil];
}

- (void)startVideoTalk {
    // 创建服务
    [self createEngine];
    // 登录房间
    [self loginRoom];
}

- (void)stopVideoTalk {
    // 结束
    [LAIGC endCallTranslation];
    
    // 停止音频数据回调监测
    [[ZegoExpressEngine sharedEngine] stopAudioDataObserver];
    // 停止推流
    [[ZegoExpressEngine sharedEngine] stopPublishingStream];
    // 停止本地预览
    [[ZegoExpressEngine sharedEngine] stopPreview];
    // 退出房间
    [[ZegoExpressEngine sharedEngine] logoutRoom];
    // 销毁引擎
    [ZegoExpressEngine destroyEngine:nil];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)createEngine {
    // 初始化
    ZegoEngineProfile *profile = [[ZegoEngineProfile alloc] init];
    // 请通过官网注册获取，格式为：1234567890
    profile.appID = [self.roomModel.appId intValue];
    // 请通过官网注册获取，格式为：@"0123456789012345678901234567890123456789012345678901234567890123"（共64个字符）
//    profile.appSign = @""; //这里为避免密钥泄漏带来的问题，后面使用的token
    // 指定使用直播场景 (请根据实际情况填写适合你业务的场景)
    profile.scenario = ZegoScenarioStandardVideoCall; // 1对1视频 1对1音频使用ZegoScenarioStandardVoiceCall
    // 创建引擎，并注册 self 为 eventHandler 回调。不需要注册回调的话，eventHandler 参数可以传 nil，后续可调用 "-setEventHandler:" 方法设置回调
    [ZegoExpressEngine createEngineWithProfile:profile eventHandler:self];
    
    
    // 开启获取原始音频数据功能
    // 需要的音频数据类型 Bitmask，此处示例只开启一个回调（onCapturedAudioData...）
    ZegoAudioDataCallbackBitMask bitmask = ZegoAudioDataCallbackBitMaskCaptured;
    // 需要的音频数据参数，此处示例单声道、16 K
    ZegoAudioFrameParam *param = [[ZegoAudioFrameParam alloc] init];
    param.channel = ZegoAudioChannelMono; // 单声道
    param.sampleRate = ZegoAudioSampleRate16K; // 采样率16000
    // 开启获取原始音频数据功能
    [[ZegoExpressEngine sharedEngine] startAudioDataObserver:bitmask param:param];
    // 设置音频数据回调
    [[ZegoExpressEngine sharedEngine] setAudioDataHandler:self];
}

// 登录房间
- (void)loginRoom {
    // roomID 由您本地生成,需保证 “roomID” 全局唯一。不同用户要登录同一个房间才能进行通话
    NSString *roomID = self.roomModel.roomId;

    // 创建用户对象，ZegoUser 的构造方法 userWithUserID 会将 “userName” 设为与传的参数 “userID” 一样。“userID” 不能为 “nil”，否则会导致登录房间失败。
    // userID 由您本地生成,需保证 “userID” 全局唯一。
    ZegoUser *user = [ZegoUser userWithUserID:self.roomModel.userId];

    // 只有传入 “isUserStatusNotify” 参数取值为 “true” 的 ZegoRoomConfig，才能收到 onRoomUserUpdate 回调。
    ZegoRoomConfig *roomConfig = [[ZegoRoomConfig alloc] init];
    //如果您使用 appsign 的方式鉴权，token 参数不需填写；如果需要使用更加安全的 鉴权方式： token 鉴权，请参考[如何从 AppSign 鉴权升级为 Token 鉴权](https://doc-zh.zego.im/faq/token_upgrade?product=ExpressVideo&platform=all)

    roomConfig.token = self.roomModel.appToken; // 使用token

    roomConfig.isUserStatusNotify = YES;
    // 登录房间
    [LHUD showLoading:@"正在登录房间"];
    LWEAKSELF
    [[ZegoExpressEngine sharedEngine] loginRoom:roomID user:user config:roomConfig callback:^(int errorCode, NSDictionary * _Nullable extendedData) {
        // (可选回调) 登录房间结果，如果仅关注登录结果，关注此回调即可
        if (errorCode == 0) {
            NSLog(@"房间登录成功");
            [LHUD showText:@"房间登录成功"];
            
            // 设置本地预览视图并启动预览，视图模式采用 SDK 默认的模式，等比缩放填充整个 View
            [[ZegoExpressEngine sharedEngine] startPreview:[ZegoCanvas canvasWithView:weakSelf.view]];
            
        } else {
            // 登录失败，请参考 errorCode 说明 /real-time-video-ios-oc/client-sdk/error-code
            NSLog(@"房间登录失败 %d", errorCode);
            [LHUD showText:@"房间登录失败"];
        }
    }];
}

// 房间内其他用户推流/停止推流时，我们会在这里收到相应流增减的通知
- (void)onRoomStreamUpdate:(ZegoUpdateType)updateType streamList:(NSArray<ZegoStream *> *)streamList extendedData:(NSDictionary *)extendedData roomID:(NSString *)roomID {
    //当 updateType 为 ZegoUpdateTypeAdd 时，代表有音视频流新增，此时我们可以调用 startPlayingStream 接口拉取播放该音视频流
    if (updateType == ZegoUpdateTypeAdd) {
        
        // 用户调用 loginRoom 之后再调用此接口进行推流
        // 在同一个 AppID 下，开发者需要保证 “streamID” 全局唯一，如果不同用户各推了一条 “streamID” 相同的流，后推流的用户会推流失败。
        [[ZegoExpressEngine sharedEngine] startPublishingStream:self.roomModel.streamId];
        
        // 开始拉流，设置远端拉流渲染视图，视图模式采用 SDK 默认的模式，等比缩放填充整个View
        // 如下 remoteUserView 为 UI 界面上 View.这里为了使示例代码更加简洁，我们只拉取新增的音视频流列表中第的第一条流，在实际的业务中，建议开发者循环遍历 streamList ，拉取每一条音视频流
        NSString *streamID = streamList[0].streamID;
        [[ZegoExpressEngine sharedEngine] startPlayingStream:streamID canvas:[ZegoCanvas canvasWithView:self.remoteUserView]];
        
        
        // 发送自定义消息，将我的语种发给对方
        NSDictionary *json = @{
            @"messageType": @"language-change",
            @"language": @(self.roomModel.language).stringValue,
            @"type": @(self.roomModel.type).stringValue,
            @"streamId" : IF_NULL_TO_STRING(self.roomModel.streamId),
            @"userId": IF_NULL_TO_STRING(self.roomModel.userId),
        };
        NSString *command = json.mj_JSONString;
        [[ZegoExpressEngine sharedEngine] sendCustomCommand:command toUserList:@[[ZegoUser userWithUserID:self.roomModel.webUserId]] roomID:self.roomModel.roomId callback:^(int errorCode) {
            NSLog(@"发送自定义消息，将我的语种发给对方 %d", errorCode);
        }];
    }
    else if (updateType == ZegoUpdateTypeDelete) {
        NSString *streamID = streamList[0].streamID;
        // 停止拉流
        [[ZegoExpressEngine sharedEngine] stopPlayingStream:streamID];
        
        // 结束
        [self stopVideoTalk];
    }
}

// 监听远端用户摄像头开关状态
- (void)onRemoteCameraStateUpdate:(ZegoRemoteDeviceState)state streamID:(NSString *)streamID {
    if (state == ZegoRemoteDeviceStateOpen) {
        // 摄像头开启
    } else if (state == ZegoRemoteDeviceStateDisable) {
        // 摄像头关闭
    }
}

// 本地采集音频数据，推流后可收到回调
- (void)onCapturedAudioData:(const unsigned char *)data dataLength:(unsigned int)dataLength param:(ZegoAudioFrameParam *)param {
    
    NSData *audioData = [NSData dataWithBytes:data length:dataLength];
    
    if (audioData.length && self.sendAudio)
    {
        [LAIGC sendAudioData:audioData];
    }
}

// Token将要过期
- (void)onRoomTokenWillExpire:(int)remainTimeInSecond roomID:(NSString *)roomID {
//     更新Token
//    [[ZegoExpressEngine sharedEngine] renewToken:@"" roomID:roomID];
}

// 收到自定义消息
- (void)onIMRecvCustomCommand:(NSString *)command fromUser:(ZegoUser *)fromUser roomID:(NSString *)roomID {
    
    NSDictionary *json = command.mj_JSONObject;
    NSString *messageType = json[@"messageType"];
    NSLog(@"收到自定义消息 %@", json);

    if ([messageType isEqualToString:@"language-change"]) { // 收到对方的语种信息
//        @{
//            @"messageType": @"language-change",
//            @"language":
//            @"type":
//            @"streamId" :
//            @"userId":
//        };
        self.roomModel.targetLanguage = [json[@"language"] integerValue];
        
        [self aigcConnectionSuccessful];
        
        self.sendAudio = YES;
    }
    else if ([messageType isEqualToString:@"translate"]) { // 收到对方说话的翻译信息
//        {
//            @"messageType": @"translate"
//            @"session_id": "089adaf5-3151-4cad-b2fc-9d011b6fef77",
//            @"data": {
//              @"text": "今天",
//              @"messageId":1,
//              @"action": "recognizing",
//              @"request_id": "<8位字符串>",
//              @"trans": [{
//                  @"translation_text": "today",
//                  @"language": "en-US"
//              }]
//          }
//        }
        NSDictionary *data = json[@"data"];
        if (data.count) {
            LWAIGCTranslateTextModel *translateTextModel = [LWAIGCTranslateTextModel mj_objectWithKeyValues:data];
            if (!translateTextModel) return;
            
            if (!IF_NULL(translateTextModel.trans.firstObject.translation_text)) {
                LWEAKSELF
                GCD_MAIN_QUEUE(^{
                    [weakSelf reloadList:translateTextModel assistantType:LAssistantType_AssistantText];
                });
            }
        }
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - UITableViewDelegate, UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
   
    if (indexPath.row < self.dataSource.count) {
        LAssistantModel *model = self.dataSource[indexPath.row];
        
        if (model.assistantType == LAssistantType_AssistantText) {
            LAssistantTextCell *cell = [tableView dequeueReusableCellWithIdentifier:LAssistantTextCellID forIndexPath:indexPath];
            cell.mainTitle.text = model.param;
            return cell;
        }
        else if (model.assistantType == LAssistantType_UserText) {
            LUserTextCell *cell = [tableView dequeueReusableCellWithIdentifier:LUserTextCellID forIndexPath:indexPath];
            cell.mainTitle.text = model.param;
            return cell;
        }
    }
    
    return nil;
}


#pragma mark - UIScrollViewDelegate

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    // 用户开始拖动时，取消自动滚动
    self.isScrollingToBottom = NO;
    
    // 判断用户是否在底部附近
    CGFloat contentHeight = scrollView.contentSize.height;
    CGFloat tableHeight = scrollView.bounds.size.height;
    CGFloat offsetY = scrollView.contentOffset.y;
    CGFloat bottomInset = scrollView.contentInset.bottom;
    
    // 如果在底部50像素范围内，则认为用户在看最新消息
    self.shouldScrollToBottom = (offsetY + tableHeight - bottomInset) >= (contentHeight - 50);
    
    self.lastContentOffset = offsetY;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    // 实时更新是否需要自动滚动的状态
    CGFloat contentHeight = scrollView.contentSize.height;
    CGFloat tableHeight = scrollView.bounds.size.height;
    CGFloat offsetY = scrollView.contentOffset.y;
    CGFloat bottomInset = scrollView.contentInset.bottom;
    
    // 用户手动向上滚动时，取消自动滚动
    if (offsetY < self.lastContentOffset) {
        self.shouldScrollToBottom = NO;
    }
    
    // 用户滚动到底部附近时，重新启用自动滚动
    if ((offsetY + tableHeight - bottomInset) >= (contentHeight - 10)) {
        self.shouldScrollToBottom = YES;
    }
    
    self.lastContentOffset = offsetY;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    // 滚动停止后判断位置
    CGFloat contentHeight = scrollView.contentSize.height;
    CGFloat tableHeight = scrollView.bounds.size.height;
    CGFloat offsetY = scrollView.contentOffset.y;
    CGFloat bottomInset = scrollView.contentInset.bottom;
    
    self.shouldScrollToBottom = (offsetY + tableHeight - bottomInset) >= (contentHeight - 10);
}

// 通知
- (void)translationNotify:(NSNotification *)notification
{
    LWAIGCTranslateTextModel *translateTextModel = (LWAIGCTranslateTextModel *)notification.object;
    
    if (!translateTextModel) return;
    
//    {
//        @"messageType": @"translate"
//        @"session_id": "089adaf5-3151-4cad-b2fc-9d011b6fef77",
//        @"data": {
//          @"text": "今天",
//          @"messageId":1,
//          @"action": "recognizing",
//          @"request_id": "<8位字符串>",
//          @"trans": [{
//              @"translation_text": "today",
//              @"language": "en-US"
//          }]
//      }
//    }
    if (!IF_NULL(translateTextModel.trans.firstObject.translation_text)) {
        NSMutableDictionary *json = NSMutableDictionary.dictionary;
        [json setValue:@"translate" forKey:@"messageType"];
        [json setValue:translateTextModel.session_id forKey:@"session_id"];
        [json setValue:translateTextModel.mj_keyValues forKey:@"data"];
        NSString *command = json.mj_JSONString;
        // 发送自定义消息，将翻译结果发给对方
        [[ZegoExpressEngine sharedEngine] sendCustomCommand:command toUserList:@[[ZegoUser userWithUserID:self.roomModel.webUserId]] roomID:self.roomModel.roomId callback:^(int errorCode) {
            NSLog(@"发送自定义消息，将翻译结果发给对方 %d", errorCode);
        }];
    }
    
    if (!IF_NULL(translateTextModel.text)) {
        LWEAKSELF
        GCD_MAIN_QUEUE(^{
            [weakSelf reloadList:translateTextModel assistantType:LAssistantType_UserText];
        });
    }
}

- (void)aigcConnectionSuccessful
{
    // 开始
    [LAIGC startCallTranslationFromLanguage:self.roomModel.language toLanguage:self.roomModel.targetLanguage];
}

- (void)reloadList:(LWAIGCTranslateTextModel *)translateTextModel assistantType:(LAssistantType)assistantType
{
    NSString *messageID = [NSString stringWithFormat:@"%@_%ld", assistantType==LAssistantType_UserText ? @"user" : @"web", translateTextModel.messageId];
    
    NSPredicate *predicate = ([NSPredicate predicateWithFormat:@"messageId == %@", messageID]);
    
    LAssistantModel *assistantModel = [self.dataSource filteredArrayUsingPredicate:predicate].lastObject;
    
    if (assistantModel) {
        assistantModel.param = assistantType==LAssistantType_UserText ? translateTextModel.text : translateTextModel.trans.firstObject.translation_text;
        
        NSInteger row = [self.dataSource indexOfObject:assistantModel];
        
        // 动画刷新
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:row inSection:0];
        [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        
    } else {
        LAssistantModel *model = [LAssistantModel new];
        model.assistantType = assistantType;
        model.messageId = messageID;
        model.param = assistantType==LAssistantType_UserText ? translateTextModel.text : translateTextModel.trans.firstObject.translation_text;
        
        // 添加
        [self.dataSource addObject:model];
        
        // 使用插入行动画代替 reloadData
        NSIndexPath *newIndexPath = [NSIndexPath indexPathForRow:self.dataSource.count-1 inSection:0];
        [self.tableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
    
    // 如果之前就在底部，就滚动到底部
    if (self.shouldScrollToBottom && !self.isScrollingToBottom) {
        [self scrollToBottomWithDelay];
    }
}

- (void)scrollToBottomWithDelay {
    self.isScrollingToBottom = YES;
    
    // 使用延迟确保 UITableView 完成布局
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self scrollToBottomAnimated:YES];
        
        // 滚动完成后重置状态
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            self.isScrollingToBottom = NO;
        });
    });
}

- (void)scrollToBottomAnimated:(BOOL)animated {
    if (self.dataSource.count == 0) return;
    
    NSInteger lastRow = [self.tableView numberOfRowsInSection:0] - 1;
    if (lastRow < 0) return;
    
    NSIndexPath *lastIndexPath = [NSIndexPath indexPathForRow:lastRow inSection:0];
    [self.tableView scrollToRowAtIndexPath:lastIndexPath
                          atScrollPosition:UITableViewScrollPositionBottom
                                  animated:animated];
}


- (void)dealloc {
    LAIGC.sharedManager.allowUseVoiceAssistant = YES;
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
