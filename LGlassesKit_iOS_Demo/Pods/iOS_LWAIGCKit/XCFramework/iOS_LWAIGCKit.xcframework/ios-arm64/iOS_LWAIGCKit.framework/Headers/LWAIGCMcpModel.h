//
//  LWAIGCMcpModel.h
//  iOS_LWAIGCKit
//
//  Created by LINWEAR on 2025-10-29.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LWAIGCMcpModel : NSObject

/// 命令
@property (nonatomic, assign) LWAIGCMCPCMD cmd;

/// 任务ID
@property (nonatomic, copy) NSString *task_id;

/// Ai识图问题
@property (nonatomic, copy, nullable) NSString *question;

/// 日程
@property (nonatomic, strong, nullable) LWAIGCScheduleModel *schedule;

@end

NS_ASSUME_NONNULL_END
