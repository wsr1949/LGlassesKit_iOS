//
//  LWAIGCChatModel.h
//  FissionBluetooth
//
//  Created by LINWEAR on 2025-02-25.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LWAIGCChatModel : NSObject

/// 模型类型
@property (nonatomic, assign) LWAIGCMODETYPE modeType;

/// 提示词
@property (nonatomic, copy, nonnull) NSString *prompt;

/// 语言简写(例如中文简体zh，英文en)，默认当前系统语言
@property (nonatomic, copy, nonnull) NSString *lang;

/// 是否开启联网搜索
@property (nonatomic, assign) BOOL enableNetwork;

/// 请求唯一会话ID，有默认值
@property (nonatomic, copy, nonnull) NSString *convId;

/// 用户ID
@property (nonatomic, copy, nullable) NSString *uuid;

@end

NS_ASSUME_NONNULL_END
