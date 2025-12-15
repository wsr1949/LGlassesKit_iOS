//
//  ATools.h
//  LGlassesKit_iOS_Demo
//
//  Created by LINWEAR on 2025-09-22.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, LCorner) {
    LCornerTop                 = 1,    // 顶部
    LCornerBottom              = 2,    // 底部
    LCornerLeft                = 3,    // 左边
    LCornerRight               = 4,    // 右边
    LCornerIgnoreLeftBottom    = 5,    // 除了左下角
    LCornerIgnoreRightBottom   = 6,    // 除了右下角
    LCornerAll                 = 0xFF, // 全部
};

@interface ATools : NSObject

/// 快速创建列表TableView
+ (UITableView *)mainTableView:(id)target
                         style:(UITableViewStyle)style
                       cellIds:(NSArray <NSString *> * _Nullable)cellIds
               headerFooterIds:(NSArray <NSString *> * _Nullable)headerFooterIds;

/// 添加按钮点击响应事件
+ (void)addAction:(UIButton *)button callback:(void (^)(void))callback;

/// 显示弹窗
+ (void)showAlertController:(LCommonViewController *)viewController title:(NSString *)title message:(NSString *)message callback:(void (^)(void))callback;

/// 设置圆角和边框
+ (void)view:(UIView *)view corners:(LCorner)corners radius:(CGFloat)radius borderWidth:(CGFloat)width borderColor:(nullable UIColor *)color;

/// 快速创建UILabel
+ (UILabel *)labelWithFont:(UIFont *)font textColor:(UIColor *)textColor;

/// 主窗口
+ (UIWindow *)keyWindow;

@end

NS_ASSUME_NONNULL_END
