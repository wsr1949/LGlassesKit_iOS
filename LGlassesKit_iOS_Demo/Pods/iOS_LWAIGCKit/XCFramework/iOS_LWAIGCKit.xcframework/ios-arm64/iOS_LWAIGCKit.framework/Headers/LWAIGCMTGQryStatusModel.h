//
//  LWAIGCMTGQryStatusModel.h
//  FissionBluetooth
//
//  Created by LINWEAR on 2025-04-14.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LWAIGCMTGQryStatusModel : NSObject

/// 任务ID
@property (nonatomic, copy, nonnull) NSString *taskId;

/// 请求唯一会话ID，有默认值
@property (nonatomic, copy, nonnull) NSString *convId;

/// 用户ID
@property (nonatomic, copy, nullable) NSString *uuid;

@end

NS_ASSUME_NONNULL_END
