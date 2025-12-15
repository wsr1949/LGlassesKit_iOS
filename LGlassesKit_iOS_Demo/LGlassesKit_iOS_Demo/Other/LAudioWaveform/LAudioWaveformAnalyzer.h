//
//  LAudioWaveformAnalyzer.h
//  LGlassesKit_iOS_Demo
//
//  Created by LINWEAR on 2025-12-03.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import <Accelerate/Accelerate.h>

NS_ASSUME_NONNULL_BEGIN

@interface LAudioWaveformAnalyzer : NSObject

- (instancetype)initWithFFTSize:(int)fftSize
                     sampleRate:(NSUInteger)sampleRate
                       channels:(NSUInteger)channels;
- (NSArray<NSArray<NSNumber *> *> *)analyse:(AVAudioPCMBuffer *)buffer withAmplitudeLevel:(int)amplitudeLevel;

@end

NS_ASSUME_NONNULL_END
