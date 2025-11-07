//
//  LAssistantTextCell.m
//  LGlassesKit_iOS_Demo
//
//  Created by LINWEAR on 2025-10-29.
//

#import "LAssistantTextCell.h"

@implementation LAssistantTextCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.backgroundColor = UIColor.clearColor;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        UIView *bgView = UIView.new;
        bgView.backgroundColor = UIColor.systemGray2Color;
        [ATools view:bgView corners:LCornerIgnoreLeftBottom radius:10 borderWidth:0 borderColor:nil];
        [self.contentView addSubview:bgView];

        
        UILabel *mainTitle = [ATools labelWithFont:UIFontMake(16) textColor:UIColor.blackColor];
        [self.contentView addSubview:mainTitle];
        [mainTitle mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.mas_equalTo(36);
            make.top.mas_equalTo(20);
            make.bottom.mas_equalTo(-20);
            make.width.mas_lessThanOrEqualTo(SCREEN_WIDTH-72).priority(MASLayoutPriorityDefaultHigh);
            make.width.mas_greaterThanOrEqualTo(20).priority(MASLayoutPriorityDefaultLow);
        }];
        self.mainTitle = mainTitle;
        
        
        [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(mainTitle.mas_top).offset(-10);
            make.bottom.mas_equalTo(mainTitle.mas_bottom).offset(10);
            make.leading.mas_equalTo(mainTitle.mas_leading).offset(-16);
            make.trailing.mas_equalTo(mainTitle.mas_trailing).offset(16);
        }];
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
