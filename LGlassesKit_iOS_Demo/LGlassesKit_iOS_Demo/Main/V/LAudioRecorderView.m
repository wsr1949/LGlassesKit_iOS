//
//  LAudioRecorderView.m
//  LGlassesKit_iOS_Demo
//
//  Created by LINWEAR on 2025-12-03.
//

#import "LAudioRecorderView.h"

@interface LAudioRecorderView ()
@property (nonatomic, copy) LAudioRecorderComplete complete;
@property (nonatomic, strong) UILabel *mainTitle;
@property (nonatomic, strong) LAudioWaveformView *waveformView;
@end

@implementation LAudioRecorderView

+ (instancetype)sharedManager {
    static LAudioRecorderView *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[LAudioRecorderView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    });
    return instance;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = UIColor.clearColor;
        
        // 创建毛玻璃效果视图
        UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
        UIVisualEffectView *blurEffectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
        [self addSubview:blurEffectView];
        [blurEffectView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, 0, 0));
        }];
        
        UIView *bgView = UIView.new;
        bgView.backgroundColor = UIColor.systemBackgroundColor;
        [self addSubview:bgView];
        [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.mas_equalTo(0);
//            make.height.mas_equalTo(240);
        }];
        
        UILabel *mainTitle = [ATools labelWithFont:UIFontMake(16) textColor:LTextColor];
        [bgView addSubview:mainTitle];
        [mainTitle mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(10);
            make.height.mas_equalTo(40);
            make.centerX.mas_equalTo(bgView);
        }];
        self.mainTitle = mainTitle;
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.backgroundColor = UIColor.systemGreenColor;
        [button setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
        button.titleLabel.font = UIFontBoldMake(16);
        [button setTitle:@"点击结束录音" forState:UIControlStateNormal];
        [button setImage:UIImageMake(@"ic_ai_voice_ing") forState:UIControlStateNormal];
        [bgView addSubview:button];
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(200, 50));
            make.bottom.mas_equalTo(-30);
            make.centerX.mas_equalTo(bgView);
        }];
        [ATools addAction:button callback:^{
            if (LAudioRecorderView.sharedManager.complete) {
                LAudioRecorderView.sharedManager.complete();
            }
            [LAudioRecorderView.sharedManager dismiss];
        }];
        
        LAudioWaveformView *waveformView = [LAudioWaveformView new];
        [bgView addSubview:waveformView];
        [waveformView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(0);
            make.bottom.mas_equalTo(button.mas_top).offset(-20);
            make.top.mas_equalTo(mainTitle.mas_bottom).offset(20);
            make.height.mas_equalTo(80);
        }];
        self.waveformView = waveformView;
        
        [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(updateSpectra:) name:LAudioRecorderUpdateSpectraKey object:nil];
    }
    return self;
}

- (void)updateSpectra:(NSNotification *)notification
{
    id object = notification.object;
    if ([object isKindOfClass:NSArray.class]) {
        [self.waveformView updateSpectra:object];
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)showTitle:(NSString *)title complete:(LAudioRecorderComplete)complete
{
    self.mainTitle.text = title;
    self.complete = complete;
    UIWindow *window = ATools.keyWindow;
    [window addSubview:self];
}

- (void)dismiss
{
    [self removeFromSuperview];
}

@end
