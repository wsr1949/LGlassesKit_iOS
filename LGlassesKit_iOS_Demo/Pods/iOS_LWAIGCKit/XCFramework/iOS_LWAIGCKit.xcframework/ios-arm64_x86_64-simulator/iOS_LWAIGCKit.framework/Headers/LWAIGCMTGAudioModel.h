//
//  LWAIGCMTGAudioModel.h
//  FissionBluetooth
//
//  Created by LINWEAR on 2025-03-18.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LWAIGCMTGAudioModel : NSObject

/// 音频数据: 大小限制小于1Gb，时间限制3分钟以上，6小时以内的音频
@property (nonatomic, strong, nonnull) NSData *audioData;

/// 语言简写(例如中文简体zh，英文en)，默认当前系统语言
@property (nonatomic, copy, nonnull) NSString *lang;

/// 格式，如mp3、m4a、wav等
@property (nonatomic, copy, nonnull) NSString *fileFormat;

/// 录制时间，单位秒
@property (nonatomic, assign) NSUInteger recordTime;

/// 录制时长，单位毫秒
@property (nonatomic, assign) NSUInteger recordDuration;

/// 请求唯一会话ID，有默认值
@property (nonatomic, copy, nonnull) NSString *convId;

/// 用户ID
@property (nonatomic, copy, nullable) NSString *uuid;

@end

NS_ASSUME_NONNULL_END
