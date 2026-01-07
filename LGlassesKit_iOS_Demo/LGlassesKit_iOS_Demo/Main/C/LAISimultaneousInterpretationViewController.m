//
//  LAISimultaneousInterpretationViewController.m
//  LGlassesKit_iOS_Demo
//
//  Created by LINWEAR on 2025-12-23.
//

#import "LAISimultaneousInterpretationViewController.h"
#import "LAudioRecorderManager.h"
#import "LAssistantModel.h"
#import "LUserTextCell.h"

@interface LAISimultaneousInterpretationViewController () <UITableViewDelegate, UITableViewDataSource, LAudioRecorderManagerDelegate>

@property (nonatomic, strong) UIButton *mainButton;

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSMutableArray <LAssistantModel *> *dataSource;

@property (nonatomic, assign) BOOL isScrollingToBottom; // 是否正在自动滚动到底部
@property (nonatomic, assign) BOOL shouldScrollToBottom; // 是否需要自动滚动到底部
@property (nonatomic, assign) CGFloat lastContentOffset; // 记录上次滚动位置

@end

static NSString *const LUserTextCellID = @"LUserTextCell";

@implementation LAISimultaneousInterpretationViewController

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    LAudioRecorderManager.sharedManager.delegate = self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"同声传译";
    
    LAIGC.sharedManager.allowUseVoiceAssistant = NO;
    
    LWEAKSELF
    UIButton *mainButton = [UIButton buttonWithType:UIButtonTypeCustom];
    mainButton.backgroundColor = UIColor.systemGreenColor;
    [mainButton setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
    mainButton.titleLabel.font = UIFontBoldMake(16);
    [mainButton setTitle:@"中文 -> English" forState:UIControlStateNormal];
    [mainButton setImage:UIImageMake(@"ic_ai_voice") forState:UIControlStateNormal];
    [mainButton setImage:UIImageMake(@"ic_ai_voice_ing") forState:UIControlStateSelected];
    [self.view addSubview:mainButton];
    [ATools addAction:mainButton callback:^{
        
        if (weakSelf.mainButton.selected) {
            [LAudioRecorderManager.sharedManager stopRecording];
        } else {
            [LAudioRecorderManager.sharedManager startRecording];
        }
    }];
    self.mainButton = mainButton;
    
    self.shouldScrollToBottom = YES; // 初始状态需要滚动到底部
    self.isScrollingToBottom = NO;
    
    // 列表
    UITableView *tableView = [ATools mainTableView:self style:UITableViewStylePlain cellIds:@[LUserTextCellID] headerFooterIds:nil];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:tableView];
    self.tableView = tableView;
    
    self.dataSource = [NSMutableArray array];
        
    // 通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(translationNotify:) name:LAIGCSimultaneousInterpretationNotify object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(aigcConnectionSuccessful) name:LAIGCConnectionSuccessfulNotify object:nil];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    UIEdgeInsets safeAreaInsets = self.safeAreaInsets;
    CGFloat offset = 20;
    
    [self.mainButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(safeAreaInsets.left+offset);
        make.right.mas_equalTo(-safeAreaInsets.left-offset);
        make.bottom.mas_equalTo(-safeAreaInsets.bottom);
        make.height.mas_equalTo(50);
    }];
    
    [self.tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(safeAreaInsets.top);
        make.left.mas_equalTo(safeAreaInsets.left);
        make.right.mas_equalTo(-safeAreaInsets.right);
        make.bottom.mas_equalTo(self.mainButton.mas_top).offset(-20);
    }];
}

#pragma mark - UITableViewDelegate, UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    LUserTextCell *cell = [tableView dequeueReusableCellWithIdentifier:LUserTextCellID forIndexPath:indexPath];
    if (indexPath.row < self.dataSource.count) {
        LAssistantModel *model = self.dataSource[indexPath.row];
        cell.mainTitle.text = model.param;
    }
    
    return cell;
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

/// 实时音频数据输出
- (void)audioRecorderManager:(LAudioRecorderManager *)manager didOutputAudioData:(NSData *)audioData audioPower:(NSArray<NSArray<NSNumber *> *> *)audioPower
{
    NSLog(@"实时音频数据输出 %@", audioData);
    [LAIGC sendSimultaneousInterpretationAudioData:audioData];
}

/// 录音开始
- (void)audioRecorderManagerDidStartRecording:(LAudioRecorderManager *)manager
{
    NSLog(@"录音开始");
    self.mainButton.selected = YES;
    
    [self aigcConnectionSuccessful];
}

/// 录音结束
- (void)audioRecorderManagerDidFinishRecording:(LAudioRecorderManager *)manager audioData:(NSData *)fullAudioData
{
    NSLog(@"录音结束");
    self.mainButton.selected = NO;
    
    [LAIGC endSimultaneousInterpretation];
}

/// 录音失败
- (void)audioRecorderManager:(LAudioRecorderManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"录音失败 %@", error);
    [LHUD showText:error.localizedDescription];
}

/// 剩余时间更新（秒）
- (void)audioRecorderManager:(LAudioRecorderManager *)manager remainingTimeDidUpdate:(NSTimeInterval)remainingTime
{
    NSLog(@"剩余时间更新（秒） %.f", remainingTime);
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

// 通知
- (void)translationNotify:(NSNotification *)notification
{
    LWEAKSELF
    GCD_MAIN_QUEUE(^{
        LWAIGCTranslateTextModel *translateTextModel = (LWAIGCTranslateTextModel *)notification.object;
        
        if (!translateTextModel) return;
        
        NSPredicate *predicate = ([NSPredicate predicateWithFormat:@"messageId == %@", @(translateTextModel.message_id).stringValue]);
        
        LAssistantModel *assistantModel = [weakSelf.dataSource filteredArrayUsingPredicate:predicate].lastObject;
        
        if (assistantModel) {
            assistantModel.param = ([NSString stringWithFormat:@"%@\n🔁\n%@", translateTextModel.text, translateTextModel.trans.firstObject.translation_text]);
            
            NSInteger row = [weakSelf.dataSource indexOfObject:assistantModel];
            
            // 动画刷新
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:row inSection:0];
            [weakSelf.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            
        } else {
            LAssistantModel *model = [LAssistantModel new];
            model.messageId = @(translateTextModel.message_id).stringValue;
            model.param = ([NSString stringWithFormat:@"%@\n🔁\n%@", translateTextModel.text, translateTextModel.trans.firstObject.translation_text]);
            
            // 添加
            [weakSelf.dataSource addObject:model];
            
            // 使用插入行动画代替 reloadData
            NSIndexPath *newIndexPath = [NSIndexPath indexPathForRow:weakSelf.dataSource.count-1 inSection:0];
            [weakSelf.tableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
        }
        
        // 如果之前就在底部，就滚动到底部
        if (weakSelf.shouldScrollToBottom && !weakSelf.isScrollingToBottom) {
            [weakSelf scrollToBottomWithDelay];
        }
    });
}

- (void)aigcConnectionSuccessful
{
#warning - 实际请根据需要的语言设置
    // 支持的语言查阅本地 language.json 文件，demo演示这里固定使用 中/英
    NSInteger fromLanguage = 140;
    NSInteger toLanguage = 47;
    
    [LAIGC startSimultaneousInterpretationFromLanguage:fromLanguage toLanguage:toLanguage];
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
