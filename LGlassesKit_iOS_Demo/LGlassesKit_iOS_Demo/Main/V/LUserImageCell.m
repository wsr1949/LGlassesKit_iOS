//
//  LUserImageCell.m
//  LGlassesKit_iOS_Demo
//
//  Created by LINWEAR on 2025-10-29.
//

#import "LUserImageCell.h"

@interface LUserImageCell ()
@property (nonatomic, strong) UIImageView *mainImage;
@end

#define LUserImageWidth     SCREEN_WIDTH/2.0

@implementation LUserImageCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.backgroundColor = UIColor.clearColor;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        UIView *bgView = [UIView new];
        bgView.backgroundColor = UIColor.systemGreenColor;
        [ATools view:bgView corners:LCornerIgnoreRightBottom radius:10 borderWidth:0 borderColor:nil];
        [self.contentView addSubview:bgView];

        
        UIImageView *mainImage = [UIImageView new];
        [self.contentView addSubview:mainImage];
        [mainImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.trailing.mas_equalTo(-36);
            make.top.mas_equalTo(20);
            make.bottom.mas_equalTo(-20);
            make.width.mas_equalTo(LUserImageWidth);
            make.height.mas_equalTo(20).priority(MASLayoutPriorityDefaultHigh); // 后续更新
        }];
        self.mainImage = mainImage;
        
        
        [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(mainImage.mas_top).offset(-10);
            make.bottom.mas_equalTo(mainImage.mas_bottom).offset(10);
            make.leading.mas_equalTo(mainImage.mas_leading).offset(-16);
            make.trailing.mas_equalTo(mainImage.mas_trailing).offset(16);
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

- (void)loadImage:(NSString *)path
{
    UIImage *img = [UIImage imageWithContentsOfFile:path];
    CGFloat scale = img.size.height / img.size.width;
    CGFloat height = scale * LUserImageWidth;
    self.mainImage.image = img;
    [self.mainImage mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(isnan(height)).priority(MASLayoutPriorityDefaultHigh); // 更新
    }];
}

@end
