//
//  LScanDeviceCell.m
//  LGlassesKit_iOS_Demo
//
//  Created by LINWEAR on 2025-10-14.
//

#import "LScanDeviceCell.h"

@implementation LScanDeviceCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        UILabel *titLabel = UILabel.new;
        titLabel.font = UIFontBoldMake(16);
        titLabel.textColor = UIColor.systemBlueColor;
        [self.contentView addSubview:titLabel];
        [titLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.leading.mas_equalTo(20);
            make.trailing.mas_equalTo(-20);
        }];
        self.titLabel = titLabel;

        UILabel *detLabel = UILabel.new;
        detLabel.font = UIFontMake(14);
        detLabel.textColor = UIColor.systemGrayColor;
        [self.contentView addSubview:detLabel];
        [detLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.trailing.mas_equalTo(titLabel.mas_trailing);
            make.leading.mas_equalTo(titLabel.mas_leading);
            make.top.mas_equalTo(titLabel.mas_bottom).offset(5);
            make.bottom.mas_equalTo(-20);
        }];
        self.detLabel = detLabel;
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
