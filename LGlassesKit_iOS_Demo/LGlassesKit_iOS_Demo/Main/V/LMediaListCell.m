//
//  LMediaListCell.m
//  LGlassesKit_iOS_Demo
//
//  Created by LINWEAR on 2025-11-07.
//

#import "LMediaListCell.h"
#import <AVKit/AVKit.h>

@interface LMediaListCell ()
@property (nonatomic, strong) UIImageView *imgView;
@property (nonatomic, strong) UIImageView *playImg;
@end

@implementation LMediaListCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.contentView.backgroundColor = UIColor.clearColor;
        
        UIImageView *imgView = [UIImageView new];
        imgView.contentMode = UIViewContentModeScaleAspectFill;
        [ATools view:imgView corners:LCornerAll radius:5 borderWidth:0 borderColor:nil];
        [self.contentView addSubview:imgView];
        [imgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, 0, 0));
        }];
        self.imgView = imgView;
        
        UIImageView *playImg = [[UIImageView alloc] initWithImage:UIImageMake(@"ic_play")];
        [self.contentView addSubview:playImg];
        [playImg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(50, 50));
            make.center.mas_equalTo(self.contentView);
        }];
        self.playImg = playImg;
    }
    return self;
}

- (void)reloadModel:(LDownloadFile *)fileModel
{
    self.playImg.hidden = YES;
        
    if ([fileModel.fileModel.name hasSuffix:@"MP4"]) {
        self.playImg.hidden = NO;
        self.imgView.image = [LMediaListCell videoCoverImage:fileModel.fileUrl];
    }
    else if ([fileModel.fileModel.name hasSuffix:@"JPG"]) {
        self.imgView.image = [UIImage imageWithContentsOfFile:fileModel.fileUrl.path];
    }
    else {
        self.imgView.image = UIImageMake(@"ic_other_file");
    }
}

+ (UIImage *)videoCoverImage:(NSURL *)fileUrl
{
    AVURLAsset *asset = [[AVURLAsset alloc] initWithURL:fileUrl options:@{AVURLAssetPreferPreciseDurationAndTimingKey : @NO}];
    
    AVAssetImageGenerator *assetImageGenerator = [[AVAssetImageGenerator alloc] initWithAsset:asset];
    assetImageGenerator.appliesPreferredTrackTransform = YES; // 应用正确的方向
    assetImageGenerator.apertureMode = AVAssetImageGeneratorApertureModeEncodedPixels;
    
    CGImageRef imageRef = NULL;
    NSError *error = nil;
    
    CMTime thumbnailImageTime = CMTimeMake(0, 60);
    imageRef = [assetImageGenerator copyCGImageAtTime:thumbnailImageTime
                                                    actualTime:NULL
                                                         error:&error];
    
    if (imageRef) {
        UIImage *image = [[UIImage alloc] initWithCGImage:imageRef];
        CGImageRelease(imageRef);
        return image;
    }
    else {
        // 失败
        return nil;
    }
}

@end
