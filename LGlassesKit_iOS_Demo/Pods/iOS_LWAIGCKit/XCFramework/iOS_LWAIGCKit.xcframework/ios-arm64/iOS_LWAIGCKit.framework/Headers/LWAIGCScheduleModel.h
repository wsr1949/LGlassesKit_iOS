//
//  LWAIGCScheduleModel.h
//  iOS_LWAIGCKit
//
//  Created by LINWEAR on 2026-03-09.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LWAIGCScheduleModel : NSObject

/// 时间
@property (nonatomic, assign) NSInteger time;

/// 地点
@property (nonatomic, copy) NSString *location;

/// 人员
@property (nonatomic, copy) NSString *person;

/// 事件
@property (nonatomic, copy) NSString *event;

@end

NS_ASSUME_NONNULL_END
