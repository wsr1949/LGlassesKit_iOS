//
//  LWAIGCAudioModel.h
//  FissionBluetooth
//
//  Created by LINWEAR on 2025-02-25.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LWAIGCAudioModel : NSObject

/// 音频数据: 大小限制小于2Mb，时间限制60秒内的音频
@property (nonatomic, strong, nonnull) NSData *audioData;

/// 语言简写(例如中文简体zh，英文en)，默认当前系统语言
@property (nonatomic, copy, nonnull) NSString *lang;

/// 格式，如pcm、mp3、m4a、wav等
@property (nonatomic, copy, nonnull) NSString *fileFormat;

/// 请求唯一会话ID，有默认值
@property (nonatomic, copy, nonnull) NSString *convId;

/// 用户ID
@property (nonatomic, copy, nullable) NSString *uuid;

@end

NS_ASSUME_NONNULL_END
