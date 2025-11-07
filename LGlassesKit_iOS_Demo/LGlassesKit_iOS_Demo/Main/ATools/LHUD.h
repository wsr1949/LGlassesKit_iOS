//
//  LHUD.h
//  LGlassesKit_iOS_Demo
//
//  Created by LINWEAR on 2025-10-14.
//

#import <Realm/Realm.h>

NS_ASSUME_NONNULL_BEGIN

@interface LHUD : RLMObject

/// 配置HUD
+ (void)configurationHUD;

/// 显示加载
+ (void)showLoading:(nullable NSString *)text;

/// 显示加载进度
+ (void)showProgress:(CGFloat)progress text:(nullable NSString *)text;

/// 隐藏加载
+ (void)dismiss;

/// 显示文字
+ (void)showText:(NSString *)text;

@end

NS_ASSUME_NONNULL_END
