//
//  LAudioRecorderManager.h
//  LGlassesKit_iOS_Demo
//
//  Created by LINWEAR on 2025-12-03.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@class LAudioRecorderManager;

@protocol LAudioRecorderManagerDelegate <NSObject>

@optional
/// 实时音频数据输出
- (void)audioRecorderManager:(LAudioRecorderManager *)manager didOutputAudioData:(NSData *)audioData audioPower:(NSArray<NSArray<NSNumber *> *> *)audioPower;

/// 录音开始
- (void)audioRecorderManagerDidStartRecording:(LAudioRecorderManager *)manager;

/// 录音结束
- (void)audioRecorderManagerDidFinishRecording:(LAudioRecorderManager *)manager audioData:(NSData *)fullAudioData;

/// 录音失败
- (void)audioRecorderManager:(LAudioRecorderManager *)manager didFailWithError:(NSError *)error;

/// 剩余时间更新（秒）
- (void)audioRecorderManager:(LAudioRecorderManager *)manager remainingTimeDidUpdate:(NSTimeInterval)remainingTime;

@end

@interface LAudioRecorderManager : NSObject

@property (nonatomic, weak) id<LAudioRecorderManagerDelegate> delegate;
@property (nonatomic, assign, readonly) BOOL isRecording;
@property (nonatomic, assign, readonly) NSTimeInterval currentTime;

/// 音频配置
@property (nonatomic, assign) NSUInteger sampleRate;      // 采样率，默认16000
@property (nonatomic, assign) NSUInteger channels;        // 声道数，默认1（单声道）
@property (nonatomic, assign) NSUInteger frameLength;     // 帧长，默认60ms
@property (nonatomic, assign) NSTimeInterval maxDuration; // 最大录制时间，0表示无限制

+ (instancetype)sharedManager;
- (instancetype)initWithSampleRate:(NSUInteger)sampleRate channels:(NSUInteger)channels frameLength:(NSUInteger)frameLength maxDuration:(NSTimeInterval)maxDuration;

/// 开始录音
- (void)startRecording;

/// 停止录音
- (void)stopRecording;

/// 暂停录音
- (void)pauseRecording;

/// 继续录音
- (void)resumeRecording;

@end

NS_ASSUME_NONNULL_END
