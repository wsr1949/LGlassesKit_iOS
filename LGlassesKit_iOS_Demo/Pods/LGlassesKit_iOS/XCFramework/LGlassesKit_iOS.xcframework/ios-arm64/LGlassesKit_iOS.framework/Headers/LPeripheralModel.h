//
//  LPeripheralModel.h
//  LGlassesKit_iOS
//
//  Created by LINWEAR on 2025-09-20.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LPeripheralModel : NSObject

/// 设备名称
@property (nonatomic, copy) NSString *deviceName;

/// 设备MAC地址
@property (nonatomic, copy) NSString *deviceMac;

/// 设备适配号
@property (nonatomic, copy) NSString *deviceMode;

/// 设备对象
@property (nonatomic, retain) CBPeripheral *peripheral;

/// 设备UUID
@property (nonatomic, copy) NSString *deviceUUID;

/// 设备信号值
@property (nonatomic, assign) NSInteger RSSI;

/// 广播数据
@property (nonatomic, strong) NSDictionary<NSString *,id> *advertisementData;

@end

NS_ASSUME_NONNULL_END
