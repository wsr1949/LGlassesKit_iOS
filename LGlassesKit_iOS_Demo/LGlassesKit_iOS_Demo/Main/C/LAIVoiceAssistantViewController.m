//
//  LAIVoiceAssistantViewController.m
//  LGlassesKit_iOS_Demo
//
//  Created by LINWEAR on 2025-10-29.
//

#import "LAIVoiceAssistantViewController.h"
#import "LUserTextCell.h"
#import "LUserImageCell.h"
#import "LAssistantTextCell.h"
#import "LAssistantModel.h"
#import "LPhotoPreviewController.h"

@interface LAIVoiceAssistantViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSMutableArray <LAssistantModel *> *dataSource;

@property (nonatomic, assign) BOOL isScrollingToBottom; // 是否正在自动滚动到底部
@property (nonatomic, assign) BOOL shouldScrollToBottom; // 是否需要自动滚动到底部
@property (nonatomic, assign) CGFloat lastContentOffset; // 记录上次滚动位置

@end

static NSString *const LUserTextCellID = @"LUserTextCell";
static NSString *const LUserImageCellID = @"LUserImageCell";
static NSString *const LAssistantTextCellID = @"LAssistantTextCell";

@implementation LAIVoiceAssistantViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"🤖AI语音助手";
    
    self.shouldScrollToBottom = YES; // 初始状态需要滚动到底部
    self.isScrollingToBottom = NO;
    
    // 列表
    UITableView *tableView = [ATools mainTableView:self style:UITableViewStylePlain cellIds:@[LUserTextCellID, LUserImageCellID, LAssistantTextCellID] headerFooterIds:nil];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:tableView];
    self.tableView = tableView;
    
    self.dataSource = [NSMutableArray array];
    
    // 通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(aiVoiceAssistantNotify:) name:LAIVoiceAssistantChatNotify object:nil];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    [self.tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.safeAreaInsets);
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
        else if (model.assistantType == LAssistantType_UserImage) {
            LUserImageCell *cell = [tableView dequeueReusableCellWithIdentifier:LUserImageCellID forIndexPath:indexPath];
            [cell loadImage:model.param];
            return cell;
        }
    }
    
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    LAssistantModel *model = self.dataSource[indexPath.row];
    if (model.assistantType == LAssistantType_UserImage) {
        LPhotoPreviewController *vc = [[LPhotoPreviewController alloc] initWithFilePath:model.param];
        [self.navigationController pushViewController:vc animated:YES];
    }
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

// 通知
- (void)aiVoiceAssistantNotify:(NSNotification *)notification
{
    LWEAKSELF
    GCD_MAIN_QUEUE(^{
        LAssistantModel *model = (LAssistantModel *)notification.object;
        
        if (!model) return;
                
        if (model.isAdd) {
            // 添加
            [weakSelf.dataSource addObject:model];
            
            // 使用插入行动画代替 reloadData
            NSIndexPath *newIndexPath = [NSIndexPath indexPathForRow:weakSelf.dataSource.count-1 inSection:0];
            [weakSelf.tableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
        }
        else if (weakSelf.dataSource.count) {
            // 更新
            LAssistantModel *lastModel = weakSelf.dataSource.lastObject;
            NSString *lastContent = lastModel.param;
            lastModel.param = ([NSString stringWithFormat:@"%@%@", lastContent, model.param]);
            
            // 动画刷新
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:weakSelf.dataSource.count-1 inSection:0];
            [weakSelf.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        }
        
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


- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
