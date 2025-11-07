//
//  LOpusDecoder.h
//  LGlassesKit_iOS_Demo
//
//  Created by LINWEAR on 2025-10-31.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LOpusDecoder : NSObject

- (instancetype)initWithSampleRate:(int)sampleRate channels:(int)channels;

// 输入 OPUS 数据，返回解码后的 PCM 数据
- (NSData *)decodeOpusData:(NSData *)opusData error:(NSError **)error;

- (void)reset;
- (void)close;

@end

NS_ASSUME_NONNULL_END
