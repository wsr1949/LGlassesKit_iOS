//
//  LAITranslationViewController.m
//  LGlassesKit_iOS_Demo
//
//  Created by LINWEAR on 2025-12-02.
//

#import "LAITranslationViewController.h"
#import "LUserTextCell.h"
#import "LUserImageCell.h"
#import "LAssistantTextCell.h"
#import "LAssistantModel.h"
#import "LAudioRecorderManager.h"
#import "LAudioRecorderView.h"

@interface LAITranslationViewController () <UITableViewDelegate, UITableViewDataSource, LAudioRecorderManagerDelegate>

@property (nonatomic, strong) UIButton *englishButton;

@property (nonatomic, strong) UIButton *chineseButton;

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSMutableArray <LAssistantModel *> *dataSource;

@property (nonatomic, assign) BOOL isScrollingToBottom; // 是否正在自动滚动到底部
@property (nonatomic, assign) BOOL shouldScrollToBottom; // 是否需要自动滚动到底部
@property (nonatomic, assign) CGFloat lastContentOffset; // 记录上次滚动位置


@property (nonatomic, assign) BOOL isChinese;

@end

static NSString *const LUserTextCellID = @"LUserTextCell";
static NSString *const LAssistantTextCellID = @"LAssistantTextCell";

@implementation LAITranslationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"🔁AI翻译";
    
    LWEAKSELF
    UIButton *englishButton = [UIButton buttonWithType:UIButtonTypeCustom];
    englishButton.backgroundColor = UIColor.systemGray2Color;
    [englishButton setTitleColor:LTextColor forState:UIControlStateNormal];
    englishButton.titleLabel.font = UIFontBoldMake(16);
    [englishButton setTitle:@"英文" forState:UIControlStateNormal];
    [englishButton setImage:UIImageMake(@"ic_ai_voice") forState:UIControlStateNormal];
    [self.view addSubview:englishButton];
    [ATools addAction:englishButton callback:^{
        
        [LAudioRecorderManager.sharedManager startRecording];
        
        weakSelf.isChinese = NO;
    }];
    self.englishButton = englishButton;
    
    UIButton *chineseButton = [UIButton buttonWithType:UIButtonTypeCustom];
    chineseButton.backgroundColor = UIColor.systemGreenColor;
    [chineseButton setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
    chineseButton.titleLabel.font = UIFontBoldMake(16);
    [chineseButton setTitle:@"中文" forState:UIControlStateNormal];
    [chineseButton setImage:UIImageMake(@"ic_ai_voice") forState:UIControlStateNormal];
    [self.view addSubview:chineseButton];
    [ATools addAction:chineseButton callback:^{
        
        [LAudioRecorderManager.sharedManager startRecording];
        
        weakSelf.isChinese = YES;
    }];
    self.chineseButton = chineseButton;
    
    self.shouldScrollToBottom = YES; // 初始状态需要滚动到底部
    self.isScrollingToBottom = NO;
    
    // 列表
    UITableView *tableView = [ATools mainTableView:self style:UITableViewStylePlain cellIds:@[LUserTextCellID, LAssistantTextCellID] headerFooterIds:nil];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:tableView];
    self.tableView = tableView;
    
    self.dataSource = [NSMutableArray array];
    
    LAudioRecorderManager.sharedManager.delegate = self;
    
    // 通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(translationNotify:) name:LAIVoiceAssistantTranslationNotify object:nil];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    UIEdgeInsets safeAreaInsets = self.safeAreaInsets;
    CGFloat offset = 20;
    
    [self.englishButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(safeAreaInsets.left+offset);
        make.right.mas_equalTo(self.view.mas_centerXWithinMargins).offset(-offset/2);
        make.bottom.mas_equalTo(-safeAreaInsets.bottom);
        make.height.mas_equalTo(50);
    }];
    
    [self.chineseButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.englishButton.mas_right).offset(offset);
        make.right.mas_equalTo(-safeAreaInsets.right-offset);
        make.bottom.mas_equalTo(self.englishButton.mas_bottom);
        make.height.mas_equalTo(self.englishButton.mas_height);
    }];
    
    [self.tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(safeAreaInsets.top);
        make.left.mas_equalTo(safeAreaInsets.left);
        make.right.mas_equalTo(-safeAreaInsets.right);
        make.bottom.mas_equalTo(self.englishButton.mas_top).offset(-20);
    }];
}

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

/// 实时音频数据输出
- (void)audioRecorderManager:(LAudioRecorderManager *)manager didOutputAudioData:(NSData *)audioData audioPower:(NSArray<NSArray<NSNumber *> *> *)audioPower
{
    NSLog(@"实时音频数据输出 %@", audioData);
    [LAIGC sendAudioData:audioData];
    
    [NSNotificationCenter.defaultCenter postNotificationName:LAudioRecorderUpdateSpectraKey object:audioPower];
}

/// 录音开始
- (void)audioRecorderManagerDidStartRecording:(LAudioRecorderManager *)manager
{
    NSLog(@"录音开始");
    
    [LAudioRecorderView.sharedManager showTitle:self.isChinese ? @"中文" : @"英文" complete:^{        
        [LAudioRecorderManager.sharedManager stopRecording];
    }];
    
    // 支持的语言查阅本地 language.json 文件，demo演示这里固定使用 中/英
    NSInteger fromLanguage = self.isChinese ? 140 : 47;
    NSInteger toLanguage = self.isChinese ? 47 : 140;
    
    [LAIGC startTranslationFromLanguage:fromLanguage toLanguage:toLanguage];
}

/// 录音结束
- (void)audioRecorderManagerDidFinishRecording:(LAudioRecorderManager *)manager audioData:(NSData *)fullAudioData
{
    NSLog(@"录音结束");
    [LAIGC endTranslation];
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
        
        LAssistantModel *model = [LAssistantModel new];
        model.assistantType = weakSelf.isChinese ? LAssistantType_UserText : LAssistantType_AssistantText;
        model.param = ([NSString stringWithFormat:@"%@\n🔁\n%@", translateTextModel.text, translateTextModel.trans.firstObject.translation_text]);
        model.isAdd = YES;
        
        // 添加
        [weakSelf.dataSource addObject:model];
        
        // 使用插入行动画代替 reloadData
        NSIndexPath *newIndexPath = [NSIndexPath indexPathForRow:weakSelf.dataSource.count-1 inSection:0];
        [weakSelf.tableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
        
        // 如果之前就在底部，就滚动到底部
        if (weakSelf.shouldScrollToBottom && !weakSelf.isScrollingToBottom) {
            [weakSelf scrollToBottomWithDelay];
        }
    });
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

@end
