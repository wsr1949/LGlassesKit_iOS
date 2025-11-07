//
//  LWAIGCModel.h
//  FissionBluetooth
//
//  Created by LINWEAR on 2025-03-03.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LWAIGCModel : NSObject

/// 厂商标识符（商务经理分配）
@property (nonatomic, copy, nonnull) NSString *clientId;

/// 厂商密钥（商务经理分配）
@property (nonatomic, copy, nonnull) NSString *clientSk;

/// 设备ID
@property (nonatomic, copy, nonnull) NSString *deviceId;

/// 设备名称
@property (nonatomic, copy, nonnull) NSString *deviceName;

/// 设备型号
@property (nonatomic, copy, nonnull) NSString *deviceModel;

/// 服务器
@property (nonatomic, assign) LWAIGCSERVERNODETYPE serverNode;

@end

NS_ASSUME_NONNULL_END
