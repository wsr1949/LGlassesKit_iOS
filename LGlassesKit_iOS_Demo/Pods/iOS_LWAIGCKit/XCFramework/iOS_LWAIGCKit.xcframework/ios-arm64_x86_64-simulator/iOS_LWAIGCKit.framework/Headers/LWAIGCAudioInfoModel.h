//
//  LWAIGCAudioInfoModel.h
//  iOS_LWAIGCKit
//
//  Created by LINWEAR on 2025-10-28.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LWAIGCAudioInfoModel : NSObject

/// 音频格式，如opus等
@property (nonatomic, copy, nonnull) NSString *format;

/// 采样率
@property (nonatomic, assign) NSInteger sample_rate;

/// 声道数量
@property (nonatomic, assign) int channels;

/// 帧时长
@property (nonatomic, assign) int frame_duration;

@end

NS_ASSUME_NONNULL_END
