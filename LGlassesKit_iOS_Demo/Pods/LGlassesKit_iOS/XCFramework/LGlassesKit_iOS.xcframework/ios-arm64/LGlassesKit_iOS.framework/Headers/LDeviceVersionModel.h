//
//  LDeviceVersionModel.h
//  LGlassesKit_iOS
//
//  Created by LINWEAR on 2025-11-08.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LDeviceVersionModel : NSObject

/// 蓝牙版本号
@property (nonatomic, copy) NSString *bleVersion;

/// ISP版本号
@property (nonatomic, copy) NSString *ispVersion;

/// 硬件版本号
@property (nonatomic, copy) NSString *hwVersion;

@end

NS_ASSUME_NONNULL_END
