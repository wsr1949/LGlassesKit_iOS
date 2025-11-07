//
//  SceneDelegate.m
//  LGlassesKit_iOS_Demo
//
//  Created by LINWEAR on 2025-09-19.
//

#import "SceneDelegate.h"

@interface SceneDelegate ()

@end

@implementation SceneDelegate


- (void)scene:(UIScene *)scene willConnectToSession:(UISceneSession *)session options:(UISceneConnectionOptions *)connectionOptions {
    // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
    // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
    // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
    
    // 从 iOS 15 开始 TableView 增加sectionHeaderTopPadding属性
    // 默认情况 sectionHeaderTopPadding 会有22个像素的高度
    // 默认情况 TableView section header 增加22像素的高度
    if (@available(iOS 15.0, *)) {
        UITableView.appearance.sectionHeaderTopPadding = 0;
    }
    
    // 数据库配置
    RLMRealmConfiguration *configuration = [RLMRealmConfiguration defaultConfiguration];
    uint64_t schemaVersion = 1;
    configuration.schemaVersion = schemaVersion;
    NSLog(@"☀️ 当前数据库版本是 %llu", schemaVersion);
    [RLMRealmConfiguration setDefaultConfiguration:configuration];
    [RLMRealm defaultRealm];
    
    [LHUD configurationHUD];
    
    // 窗口
    self.window.rootViewController = [[LCommonNavigationController alloc] initWithRootViewController:[LMainViewController new]];
}


- (void)sceneDidDisconnect:(UIScene *)scene {
    // Called as the scene is being released by the system.
    // This occurs shortly after the scene enters the background, or when its session is discarded.
    // Release any resources associated with this scene that can be re-created the next time the scene connects.
    // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
}


- (void)sceneDidBecomeActive:(UIScene *)scene {
    // Called when the scene has moved from an inactive state to an active state.
    // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
}


- (void)sceneWillResignActive:(UIScene *)scene {
    // Called when the scene will move from an active state to an inactive state.
    // This may occur due to temporary interruptions (ex. an incoming phone call).
}


- (void)sceneWillEnterForeground:(UIScene *)scene {
    // Called as the scene transitions from the background to the foreground.
    // Use this method to undo the changes made on entering the background.
}


- (void)sceneDidEnterBackground:(UIScene *)scene {
    // Called as the scene transitions from the foreground to the background.
    // Use this method to save data, release shared resources, and store enough scene-specific state information
    // to restore the scene back to its current state.
}


@end
