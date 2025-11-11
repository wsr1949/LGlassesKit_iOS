//
//  LMainHeaderView.m
//  LGlassesKit_iOS_Demo
//
//  Created by LINWEAR on 2025-10-21.
//

#import "LMainHeaderView.h"

@interface LMainHeaderView ()

@property (nonatomic, strong) UIButton *button;

@property (nonatomic, copy) LMainHeaderViewCallback callback;

@end

@implementation LMainHeaderView

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithReuseIdentifier:reuseIdentifier]) {
        UIBackgroundConfiguration *backgroundConfiguration = UIBackgroundConfiguration.clearConfiguration;
        backgroundConfiguration.backgroundColor = UIColor.systemGreenColor;
        self.backgroundConfiguration = backgroundConfiguration;
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.titleLabel.font = UIFontBoldMake(16);
        [button setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
        button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeading;
        [self.contentView addSubview:button];
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(UIEdgeInsetsMake(0, 15, 0, 15));
            make.height.mas_equalTo(50).priority(MASLayoutPriorityDefaultHigh);
        }];
        LWEAKSELF
        [ATools addAction:button callback:^{
            if (weakSelf.callback) weakSelf.callback();
        }];
        self.button = button;
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)reloadCount:(NSInteger)count callback:(LMainHeaderViewCallback)callback
{
    self.callback = callback;
    [self.button setTitle:[NSString stringWithFormat:@"%ld个媒体文件可导入👉", count] forState:UIControlStateNormal];
}

@end



@interface LMainFooterView ()

@property (nonatomic, strong) UIButton *batteryButton;

@property (nonatomic, copy) LMainHeaderViewCallback callback;

@end

@implementation LMainFooterView

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithReuseIdentifier:reuseIdentifier]) {
        UIBackgroundConfiguration *backgroundConfiguration = UIBackgroundConfiguration.clearConfiguration;
        backgroundConfiguration.backgroundColor = UIColor.systemGray6Color;
        self.backgroundConfiguration = backgroundConfiguration;
        
        // 电池电量状态
        UIButton *batteryButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [batteryButton setTitleColor:UIColor.systemBlueColor forState:UIControlStateNormal];
        [batteryButton setTitleColor:UIColor.systemGreenColor forState:UIControlStateSelected];
        [batteryButton setImage:UIImageMake(@"ic_battery_normal") forState:UIControlStateNormal];
        [batteryButton setImage:UIImageMake(@"ic_battery_charging") forState:UIControlStateSelected];
        [self.contentView addSubview:batteryButton];
        [batteryButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(UIEdgeInsetsMake(0, 15, 0, 15));
            make.height.mas_equalTo(50).priority(MASLayoutPriorityDefaultHigh);
        }];
        self.batteryButton = batteryButton;
    }
    return self;
}

- (void)reloadBattery:(int)battery charging:(BOOL)charging version:(NSString *)version
{
    self.batteryButton.selected = charging;
    [self.batteryButton setTitle:[NSString stringWithFormat:@"%d%%，版本号V%@", battery, version] forState:UIControlStateNormal];
}

@end
