//
//  LMediaListViewController.m
//  LGlassesKit_iOS_Demo
//
//  Created by LINWEAR on 2025-11-07.
//

#import "LMediaListViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "LMediaListCell.h"
#import "LPhotoPreviewController.h"
#import "LVideoPreviewController.h"

@interface LMediaListViewController () <UICollectionViewDataSource, UICollectionViewDelegate>

@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, strong) AVAudioPlayer *audioPlayer;

@end

static NSString *const LMediaListCellID = @"LMediaListCell";

@implementation LMediaListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"媒体列表";
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    
    CGFloat spacing = 10.0f; // 间距
    layout.minimumInteritemSpacing = spacing; // 项之间的最小间距
    layout.minimumLineSpacing = spacing; // 行之间的最小间距
    layout.sectionInset = UIEdgeInsetsMake(spacing, spacing, spacing, spacing); // 边距
    CGFloat availableWidth = SCREEN_WIDTH - spacing*4;
    CGFloat itemWidth = availableWidth / 3;
    layout.itemSize = CGSizeMake(itemWidth, itemWidth); // 正方形项
    
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    collectionView.backgroundColor = UIColor.clearColor;
    collectionView.dataSource = self;
    collectionView.delegate = self;
    
    [collectionView registerClass:NSClassFromString(LMediaListCellID) forCellWithReuseIdentifier:LMediaListCellID];
    
    [self.view addSubview:collectionView];
    self.collectionView = collectionView;
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
    return self.urls.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    LMediaListCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:LMediaListCellID forIndexPath:indexPath];
    if (indexPath.row < self.urls.count) {
        [cell reloadWithUrl:self.urls[indexPath.row]];
    }
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSURL *url = self.urls[indexPath.row];
    
    if ([url.pathExtension rangeOfString:@"MP4" options:NSCaseInsensitiveSearch].location != NSNotFound) { // 视频
        LVideoPreviewController *vc = [[LVideoPreviewController alloc] initWithFileUrl:url];
        [self.navigationController pushViewController:vc animated:YES];
    }
    else if ([url.pathExtension rangeOfString:@"JPG" options:NSCaseInsensitiveSearch].location != NSNotFound) { // 图片
        LPhotoPreviewController *vc = [[LPhotoPreviewController alloc] initWithFilePath:url.path];
        [self.navigationController pushViewController:vc animated:YES];
    }
    else if ([url.pathExtension rangeOfString:@"WAV" options:NSCaseInsensitiveSearch].location != NSNotFound ||
             [url.pathExtension rangeOfString:@"AAC" options:NSCaseInsensitiveSearch].location != NSNotFound) { // 音频
        
        if (self.audioPlayer.isPlaying) {
            [self.audioPlayer stop];
            
            if ([self.audioPlayer.url.lastPathComponent isEqualToString:url.path.lastPathComponent]) {
                return;
            }
        }
        
        [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
        [[AVAudioSession sharedInstance] setActive:YES error:nil];
        
        AVAudioPlayer *audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:nil];
        audioPlayer.volume = 1.0;
        [audioPlayer prepareToPlay];
        [audioPlayer play];
        self.audioPlayer = audioPlayer;
    }
    else {
        [LHUD showText:@"其他类型文件处理"];
    }
}

@end
