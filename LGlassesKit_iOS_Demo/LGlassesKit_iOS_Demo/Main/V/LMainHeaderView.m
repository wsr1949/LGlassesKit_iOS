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
        
        UIButton *button = [UIButton  buttonWithType:UIButtonTypeCustom];
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
