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

/// 参数1
@property (nonatomic, copy) NSString *arguments_1;

@end

NS_ASSUME_NONNULL_END
