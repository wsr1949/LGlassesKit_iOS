//
//  LLivePreviewViewController.m
//  LGlassesKit_iOS_Demo
//
//  Created by LINWEAR on 2026-09-09.
//

#import "LLivePreviewViewController.h"

@interface LLivePreviewViewController ()

@property (nonatomic, strong) IJKFFMoviePlayerController *player;

@property (nonatomic, strong) UIView *videoView;

@property (nonatomic, strong) UIButton *button;

@end

@implementation LLivePreviewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"📸直播预览（部分设备支持）";
    
    UIView *videoView = [UIView new];
    videoView.backgroundColor = [UIColor.systemIndigoColor colorWithAlphaComponent:0.5];
    videoView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self.view addSubview:videoView];
    self.videoView = videoView;
    
    UIButton *button = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [button setBackgroundImage:[ATools imageWithColor:UIColor.systemGreenColor size:CGSizeMake(1, 1) cornerRadius:0] forState:(UIControlStateNormal)];
    [button setBackgroundImage:[ATools imageWithColor:UIColor.systemRedColor size:CGSizeMake(1, 1) cornerRadius:0] forState:(UIControlStateSelected)];
    [button setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
    [button setTitle:@"开始预览" forState:(UIControlStateNormal)];
    [button setTitle:@"结束预览" forState:(UIControlStateSelected)];
    [self.view addSubview:button];
    self.button = button;
    LWEAKSELF
    [ATools addAction:button callback:^{
        BOOL selected = weakSelf.button.selected;
        
        if (selected) {
            // 结束
            [weakSelf endLivePreview:YES];
        } else {
            // 开始
            [weakSelf startLivePreview];
        }
    }];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    UIEdgeInsets safeAreaInsets = self.safeAreaInsets;
    CGFloat left = safeAreaInsets.left + 30;
    CGFloat right = safeAreaInsets.right + 30;
    CGFloat bottom = safeAreaInsets.bottom;
    
    [self.videoView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(safeAreaInsets);
    }];
    
    [self.button mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(-bottom);
        make.left.mas_equalTo(left);
        make.right.mas_equalTo(-right);
        make.height.mas_equalTo(50);
    }];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    // 结束
    [self endLivePreview:NO];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

/// 开始预览
- (void)startLivePreview
{
    [LHUD showLoading:nil];
    LWEAKSELF
    [LGlassesKit enterLiveStreamModeWithCallback:^(NSString * _Nullable rtsp, NSError * _Nullable error) {
        if (error) {
            [LHUD showText:error.localizedDescription];
            if (weakSelf.player) { // 中断了
                GCD_MAIN_QUEUE(^{
                    [ATools showAlertController:weakSelf title:@"预览结束" message:@"请检查热点是否连接异常" callback:^{
                        // done...
                    }];
                });
            }
        } else {
            [LHUD dismiss];
            GCD_MAIN_QUEUE(^{
                // 开始播放
                [weakSelf playWithRtsp:rtsp];
            });
        }
    }];
}

/// 开始播放
- (void)playWithRtsp:(NSString *)rtsp
{
    IJKFFOptions *options = [IJKFFOptions optionsByDefault];
    // 部分参数设置
    [options setPlayerOptionIntValue:1 forKey:@"an"];
    [options setPlayerOptionIntValue:1 forKey:@"videotoolbox"];
    [options setPlayerOptionIntValue:0 forKey:@"packet-buffering"];
    [options setPlayerOptionIntValue:1 forKey:@"framedrop"];
    [options setPlayerOptionIntValue:1 forKey:@"video-pictq-size"];
    [options setFormatOptionValue:@"nobuffer" forKey:@"fflags"];
    
    self.player = [[IJKFFMoviePlayerController alloc]
                   initWithContentURLString:rtsp
                   withOptions:options];
    self.player.scalingMode = IJKMPMovieScalingModeAspectFit;
    self.player.shouldAutoplay = YES;
    
    UIView *preview = self.player.view;
    preview.transform = CGAffineTransformMakeRotation(-M_PI_2); // 逆时针 90°
    preview.frame = self.videoView.bounds;
    preview.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self.videoView addSubview:preview];
    
    [self.player prepareToPlay];
    
    self.button.selected = YES;
}

/// 结束预览
- (void)endLivePreview:(BOOL)end
{
    if (self.player) {
        [self.player stop];
        [self.player shutdown];
        [self.player.view removeFromSuperview];
        self.player = nil;
    }
    
    self.button.selected = NO;
    
    if (end) {
        [LHUD showLoading:nil];
    }
    LWEAKSELF
    [LGlassesKit exitLiveStreamModeWithCallback:^(NSError * _Nullable error) {
        if (error) {
            [LHUD showText:error.localizedDescription];
        } else {
            [LHUD dismiss];
        }
        if (end) {
            [weakSelf.navigationController popViewControllerAnimated:YES];
        }
    }];
}

@end
