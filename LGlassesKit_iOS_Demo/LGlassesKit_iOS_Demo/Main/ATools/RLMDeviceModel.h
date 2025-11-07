//
//  RLMDeviceModel.h
//  LGlassesKit_iOS_Demo
//
//  Created by LINWEAR on 2025-10-14.
//

#import <Realm/Realm.h>

NS_ASSUME_NONNULL_BEGIN

@interface RLMDeviceModel : RLMObject

/// 设备名称
@property NSString *deviceName;

/// 设备mac地址
@property NSString *deviceMac;

/// 设备适配号
@property NSString *deviceMode;

/// 设备uuid
@property NSString *deviceUUID;

@end

NS_ASSUME_NONNULL_END
