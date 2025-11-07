//
//  LVideoPreviewController.m
//  LGlassesKit_iOS_Demo
//
//  Created by LINWEAR on 2025-10-31.
//

#import "LVideoPreviewController.h"
#import <AVKit/AVKit.h>

@interface LVideoPreviewController ()

@property (nonatomic, copy) NSURL *fileUrl;

@property (strong, nonatomic) AVPlayerViewController *playerViewController;

@end

@implementation LVideoPreviewController

- (instancetype)initWithFileUrl:(NSURL *)fileUrl {
    if (self = [super init]) {
        self.fileUrl = fileUrl;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"视频预览";
        
    AVPlayer *player = [AVPlayer playerWithURL:self.fileUrl];
    
    self.playerViewController = [[AVPlayerViewController alloc] init];
    self.playerViewController.player = player;
    self.playerViewController.showsPlaybackControls = YES;
    
    [self.view addSubview:self.playerViewController.view];
    [self addChildViewController:self.playerViewController];
    [self.playerViewController didMoveToParentViewController:self];
    
    // 开始播放
    [player play];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    [self.playerViewController.view mas_remakeConstraints:^(MASConstraintMaker *make) {
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

@end
