//
//  LHUD.m
//  LGlassesKit_iOS_Demo
//
//  Created by LINWEAR on 2025-10-14.
//

#import "LHUD.h"

@implementation LHUD

/// 配置HUD
+ (void)configurationHUD
{
    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleCustom];
    [SVProgressHUD setFont:UIFontMake(16)];
    [SVProgressHUD setForegroundColor:UIColorMakeWithRGBA(255, 255, 255, 1)];
    [SVProgressHUD setForegroundImageColor:UIColorMakeWithRGBA(255, 255, 255, 1)];
    [SVProgressHUD setBackgroundColor:UIColorMakeWithRGBA(55, 55, 55, 1)];
    [SVProgressHUD setMinimumDismissTimeInterval:3];
    [SVProgressHUD setMaximumDismissTimeInterval:3];
}

/// 显示加载
+ (void)showLoading:(NSString *)text
{
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
    [SVProgressHUD showWithStatus:text];
}

/// 显示加载进度
+ (void)showProgress:(CGFloat)progress text:(NSString *)text
{
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
    [SVProgressHUD showProgress:progress status:text];
}

/// 隐藏加载
+ (void)dismiss
{
    [SVProgressHUD dismiss];
}

/// 显示文字
+ (void)showText:(NSString *)text
{
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeNone];
    [SVProgressHUD showImage:UIImageMake(@"这里不设置显示图片") status:text];
}

@end
