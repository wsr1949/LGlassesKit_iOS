//
//  LWAIGCRoomQryModel.h
//  iOS_LWAIGCKit
//
//  Created by LINWEAR on 2025-12-29.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LWAIGCRoomQryModel : NSObject

/// 请求唯一会话ID
@property (nonatomic, copy) NSString *convId;

/// 房间ID
@property (nonatomic, copy) NSString *roomId;

/// 用户ID
@property (nonatomic, copy) NSString *userId;

/// 用户流ID
@property (nonatomic, copy) NSString *streamId;

/// 网页用户ID
@property (nonatomic, copy) NSString *webUserId;

/// 网页流ID
@property (nonatomic, copy) NSString *webStreamId;

/// 平台应用ID
@property (nonatomic, copy) NSString *appId;

/// 源语言
@property (nonatomic, assign) NSInteger language;

/// 目标语言
@property (nonatomic, assign) NSInteger targetLanguage;

/// AI语音房间分享的URL
@property (nonatomic, copy) NSString *hostUrl;

/// 房间类型【1: 视频房间】【2: 语言房间】
@property (nonatomic, assign) NSInteger type;

/// App Token
@property (nonatomic, copy) NSString *appToken;

/// 错误
@property (nonatomic, strong, nullable) NSError *error;

@end

NS_ASSUME_NONNULL_END
