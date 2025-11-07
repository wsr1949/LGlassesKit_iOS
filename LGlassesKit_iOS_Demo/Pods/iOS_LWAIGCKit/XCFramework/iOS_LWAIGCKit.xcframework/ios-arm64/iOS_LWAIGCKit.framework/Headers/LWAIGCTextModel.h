//
//  LWAIGCTextModel.h
//  FissionBluetooth
//
//  Created by LINWEAR on 2025-03-15.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LWAIGCTextModel : NSObject

/// 文本内容
@property (nonatomic, copy, nullable) NSString *content;

/// 思维链内容
@property (nonatomic, copy, nullable) NSString *reasonContent;

/// 是否结束
@property (nonatomic, assign) BOOL ended;

/// 是否清除历史记录
@property (nonatomic, assign) BOOL clearHistory;

/// 请求唯一会话ID
@property (nonatomic, copy) NSString *convId;

/// 累计消耗的时间（单位：毫秒）
@property (nonatomic, assign) NSInteger constTime;

/// 错误
@property (nonatomic, strong, nullable) NSError *error;

@end

NS_ASSUME_NONNULL_END
