//
//  LWAIGCQueryRoomModel.h
//  iOS_LWAIGCKit
//
//  Created by LINWEAR on 2025-12-29.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LWAIGCQueryRoomModel : NSObject

/// 请求唯一会话ID，有默认值
@property (nonatomic, copy, nonnull) NSString *convId;

/// 源语种
@property (nonatomic, assign) NSInteger from_language;

/// 目标语种列表
@property (nonatomic, assign) NSInteger to_language;

/// 房间类型【1: 视频房间】【2: 语言房间】
@property (nonatomic, assign) NSInteger roomType;

/// 应用ID
@property (nonatomic, copy) NSString *appId;

@end

NS_ASSUME_NONNULL_END
