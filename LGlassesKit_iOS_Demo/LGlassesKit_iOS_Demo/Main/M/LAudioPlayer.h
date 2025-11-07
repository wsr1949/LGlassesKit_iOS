//
//  LAudioPlayer.h
//  LGlassesKit_iOS_Demo
//
//  Created by LINWEAR on 2025-10-31.
//

#import <Foundation/Foundation.h>
#import <AudioToolbox/AudioToolbox.h>

#define kNumberBuffers 3

NS_ASSUME_NONNULL_BEGIN

@interface LAudioPlayer : NSObject

@property (nonatomic) AudioQueueRef audioQueue;
@property (nonatomic) AudioStreamBasicDescription audioFormat;
@property (nonatomic) BOOL isPlaying;
@property (nonatomic) BOOL isStopped;
@property (nonatomic, strong) dispatch_queue_t dataQueue;
@property (nonatomic) AudioQueueBufferRef _Nullable * _Nullable audioBuffers;
@property (nonatomic, strong) NSMutableData *pcmDataBuffer;
@property (nonatomic) UInt32 bufferSize;

// 音频参数
@property (nonatomic) float sampleRate;
@property (nonatomic) UInt32 channels;
@property (nonatomic) UInt32 bitsPerSample;

- (instancetype)initWithSampleRate:(float)sampleRate
                          channels:(UInt32)channels
                    bitsPerSample:(UInt32)bitsPerSample;

- (void)startPlayback;
- (void)stopPlayback;
- (void)appendPCMData:(NSData *)pcmData;

@end

NS_ASSUME_NONNULL_END
