//
//  LWAIGCAudioStream.h
//  iOS_LWAIGCKit
//
//  Created by LINWEAR on 2026-01-07.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LWAIGCAudioStream : NSObject

/// 会话ID
@property (nonatomic, copy) NSString *session_id;

/// 唯一ID
@property (nonatomic, copy) NSString *request_id;

/// 消息ID
@property (nonatomic, assign) NSInteger message_id;

/// 动作：start开始，send中间，end结束
@property (nonatomic, copy) NSString *action;

/// 音频数据
@property (nonatomic, strong) NSData *payload;

/// 采集时间戳 (毫秒)
@property (nonatomic, assign) NSInteger timestamp;

/// 包序号
@property (nonatomic, assign) NSInteger sequence;

@end

NS_ASSUME_NONNULL_END
