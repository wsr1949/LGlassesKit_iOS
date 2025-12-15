//
//  ATools.m
//  LGlassesKit_iOS_Demo
//
//  Created by LINWEAR on 2025-09-22.
//

#import "ATools.h"

@implementation ATools

/// 快速创建列表TableView
+ (UITableView *)mainTableView:(id)target
                         style:(UITableViewStyle)style
                       cellIds:(NSArray<NSString *> *)cellIds
               headerFooterIds:(NSArray<NSString *> *)headerFooterIds
{
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectZero style:style];
    tableView.delegate = target;
    tableView.dataSource = target;
    tableView.rowHeight = UITableViewAutomaticDimension;
    tableView.sectionHeaderHeight = UITableViewAutomaticDimension;
    tableView.sectionFooterHeight = UITableViewAutomaticDimension;
    for (NSString *ids in cellIds) {
        [tableView registerClass:NSClassFromString(ids) forCellReuseIdentifier:ids];
    }
    for (NSString *ids in headerFooterIds) {
        [tableView registerClass:NSClassFromString(ids) forHeaderFooterViewReuseIdentifier:ids];
    }
    return tableView;
}

/// 添加按钮点击响应事件
+ (void)addAction:(UIButton *)button callback:(void (^)(void))callback
{
    [button addAction:[UIAction actionWithHandler:^(__kindof UIAction * _Nonnull action) {
        GCD_MAIN_QUEUE(^{
            if (callback) callback();
        });
    }] forControlEvents:UIControlEventTouchUpInside];
}

/// 显示弹窗
+ (void)showAlertController:(LCommonViewController *)viewController title:(NSString *)title message:(NSString *)message callback:(void (^)(void))callback
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    
    //添加取消按钮
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [alertController addAction:cancel];
        
    //添加确定按钮
    UIAlertAction *confirm = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        GCD_MAIN_QUEUE(^{
            if (callback) callback();
        });
    }];
    [alertController addAction:confirm];
    
    //显示
    [viewController presentViewController:alertController animated:YES completion:nil];
}

/// 设置圆角和边框
+ (void)view:(UIView *)view corners:(LCorner)corners radius:(CGFloat)radius borderWidth:(CGFloat)width borderColor:(nullable UIColor *)color
{
    CACornerMask maskedCorners;
    if (corners == LCornerTop) {
        maskedCorners = kCALayerMinXMinYCorner | kCALayerMaxXMinYCorner;
    }
    else if (corners == LCornerBottom) {
        maskedCorners = kCALayerMinXMaxYCorner | kCALayerMaxXMaxYCorner;
    }
    else if (corners == LCornerLeft) {
        maskedCorners = kCALayerMinXMinYCorner | kCALayerMinXMaxYCorner;
    }
    else if (corners == LCornerRight) {
        maskedCorners = kCALayerMaxXMinYCorner | kCALayerMaxXMaxYCorner;
    }
    else if (corners == LCornerIgnoreLeftBottom) {
        maskedCorners = kCALayerMinXMinYCorner | kCALayerMaxXMinYCorner | kCALayerMaxXMaxYCorner;
    }
    else if (corners == LCornerIgnoreRightBottom) {
        maskedCorners = kCALayerMinXMinYCorner | kCALayerMaxXMinYCorner | kCALayerMinXMaxYCorner;
    }
    else { // all
        maskedCorners = kCALayerMinXMinYCorner | kCALayerMaxXMinYCorner | kCALayerMinXMaxYCorner | kCALayerMaxXMaxYCorner;
    }
    // iOS11+有效
    view.layer.cornerRadius = radius;
    view.layer.maskedCorners = maskedCorners;
    view.clipsToBounds = YES;
    
    if (width > 0 && color) {
        view.layer.borderWidth = width;
        view.layer.borderColor = color.CGColor;
    }
}

/// 快速创建UILabel
+ (UILabel *)labelWithFont:(UIFont *)font textColor:(UIColor *)textColor
{
    UILabel *label = [UILabel new];
    label.backgroundColor = UIColor.clearColor;
    label.font = font;
    label.textColor = textColor;
    label.numberOfLines = 0;
    label.lineBreakMode = NSLineBreakByWordWrapping;
    return label;
}

/// 主窗口
+ (UIWindow *)keyWindow
{
    UIWindowScene *windowScene = nil;
    NSSet<UIScene *> *connectedScenes = [UIApplication sharedApplication].connectedScenes;
    
    for (UIScene *scene in connectedScenes) {
        if (scene.activationState == UISceneActivationStateForegroundActive) {
            windowScene = (UIWindowScene *)scene;
            break;
        }
    }
    
    // 如果没找到活动场景，查找前台非活跃场景
    if (!windowScene) {
        for (UIScene *scene in connectedScenes) {
            if (scene.activationState == UISceneActivationStateForegroundInactive) {
                windowScene = (UIWindowScene *)scene;
                break;
            }
        }
    }
    
    if (windowScene) {
        for (UIWindow *window in windowScene.windows) {
            if (window.isKeyWindow) {
                return window;
            }
        }
    }
    return windowScene.windows.firstObject;
}

@end
