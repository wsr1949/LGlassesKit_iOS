//
//  LAIAgentViewController.m
//  LGlassesKit_iOS_Demo
//
//  Created by LINWEAR on 2025-12-23.
//

#import "LAIAgentViewController.h"
#import "LAIVoiceAssistantViewController.h"
#import "LAITranslationViewController.h"
#import "LAISimultaneousInterpretationViewController.h"
#import "LAiAudioVideoCallsViewController.h"

@interface LAIAgentViewController () <UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, strong) NSArray <NSString *> *dataSource;

@end

static NSString *const LAIAgentCellID = @"LAIAgentCell";

@implementation LAIAgentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"🤖AI智能体";
    
    CGFloat sep = 20;
    UICollectionViewFlowLayout *flowLayout = UICollectionViewFlowLayout.new;
    flowLayout.sectionInset = UIEdgeInsetsMake(sep, sep, sep, sep);
    flowLayout.minimumLineSpacing = sep;
    flowLayout.minimumInteritemSpacing = sep;
    double itemW = floor((SCREEN_WIDTH-flowLayout.sectionInset.left-flowLayout.sectionInset.right-flowLayout.minimumInteritemSpacing)/2.0);
    flowLayout.itemSize = CGSizeMake(itemW, itemW);
    
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
    collectionView.backgroundColor = UIColor.clearColor;
    collectionView.dataSource = self;
    collectionView.delegate = self;
    [collectionView registerClass:NSClassFromString(LAIAgentCellID) forCellWithReuseIdentifier:LAIAgentCellID];
    [self.view addSubview:collectionView];
    self.collectionView = collectionView;
    
    
    self.dataSource = @[
        @"语音助手",
        @"对话翻译",
        @"同声传译",
        @"音视频通话",
    ];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
        
    [self.collectionView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.safeAreaInsets);
    }];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.dataSource.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    LAIAgentCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:LAIAgentCellID forIndexPath:indexPath];
    cell.mainTitle.text = self.dataSource[indexPath.item];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *title = self.dataSource[indexPath.item];
    
    if ([title isEqualToString:@"语音助手"]) {
        LAIVoiceAssistantViewController *vc = LAIVoiceAssistantViewController.new;
        [self.navigationController pushViewController:vc animated:YES];
    }
    else if ([title isEqualToString:@"对话翻译"]) {
        if (LAIGC.sharedManager.usingVoiceAssistant) {
            [LHUD showText:@"正在使用助手，请先结束"];
            return;
        }
        
        LAITranslationViewController *vc = LAITranslationViewController.new;
        [self.navigationController pushViewController:vc animated:YES];
    }
    else if ([title isEqualToString:@"同声传译"]) {
        if (LAIGC.sharedManager.usingVoiceAssistant) {
            [LHUD showText:@"正在使用助手，请先结束"];
            return;
        }
        
        LAISimultaneousInterpretationViewController *vc = LAISimultaneousInterpretationViewController.new;
        [self.navigationController pushViewController:vc animated:YES];
    }
    else if ([title isEqualToString:@"音视频通话"]) {
        if (LAIGC.sharedManager.usingVoiceAssistant) {
            [LHUD showText:@"正在使用助手，请先结束"];
            return;
        }
        
        LWAIGCQueryRoomModel *model = [LWAIGCQueryRoomModel new];
#warning - 实际请根据需要的语言设置
        // 支持的语言查阅本地 language.json 文件，demo演示这里固定使用 中/英
        model.from_language = 140; //中文
        model.to_language = 47; // 英文
        model.roomType = 1; // 这里demo演示视频
#warning - 请联系服务商提供，中国大陆内临时测试可以使用 1528564533 ，每天有限额用完即止，上线前务必使用申请的正式appId
        model.appId = @"1528564533"; // 申请的appId
        
        LWEAKSELF
        [LWAIGCKit requestCreateRoomWithModel:model withCallback:^(LWAIGCRoomQryModel * _Nullable roomQryModel) {
            if (roomQryModel.error) {
                [LHUD showText:roomQryModel.error.localizedDescription];
            } else {
                GCD_MAIN_QUEUE(^{
                    LAiAudioVideoCallsViewController *vc = LAiAudioVideoCallsViewController.new;
                    vc.roomModel = roomQryModel;
                    vc.modalPresentationStyle = UIModalPresentationFullScreen;
                    [weakSelf presentViewController:vc animated:YES completion:nil];
                });
            }
        }];
    }
}

@end



@implementation LAIAgentCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = UIColor.systemGreenColor;
        
        UILabel *mainTitle = [ATools labelWithFont:UIFontBoldMake(24) textColor:LTextColor];
        mainTitle.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:mainTitle];
        [mainTitle mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(UIEdgeInsetsMake(20, 20, 20, 20));
        }];
        self.mainTitle = mainTitle;
        
        [ATools view:self corners:LCornerAll radius:20 borderWidth:0 borderColor:nil];
    }
    return self;
}

@end
