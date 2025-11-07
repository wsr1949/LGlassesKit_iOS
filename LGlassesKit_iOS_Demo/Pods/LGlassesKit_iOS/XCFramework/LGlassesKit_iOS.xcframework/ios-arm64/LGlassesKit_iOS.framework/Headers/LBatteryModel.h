//
//  LBatteryModel.h
//  LGlassesKit_iOS
//
//  Created by LINWEAR on 2025-10-16.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LBatteryModel : NSObject

/// 电量（%）
@property (nonatomic, assign) int battery;

/// 是否充电中
@property (nonatomic, assign) BOOL charging;

@end

NS_ASSUME_NONNULL_END
