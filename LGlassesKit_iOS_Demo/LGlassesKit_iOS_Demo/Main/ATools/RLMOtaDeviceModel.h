//
//  RLMOtaDeviceModel.h
//  LGlassesKit_iOS_Demo
//
//  Created by LINWEAR on 2025-12-22.
//

#import <Realm/Realm.h>

NS_ASSUME_NONNULL_BEGIN

@interface RLMOtaDeviceModel : RLMObject

/// 设备mac地址
@property NSString *deviceMac;

/// ota回连方式
@property LOtaUpgradeReconnectMethod reconnectMethod;

/// ota回连设备
@property NSString *reconnectDevice;

@end

NS_ASSUME_NONNULL_END
