//
//  LAudioRecorderManager.m
//  LGlassesKit_iOS_Demo
//
//  Created by LINWEAR on 2025-12-03.
//

#import "LAudioRecorderManager.h"
#import <AVFoundation/AVFoundation.h>
#import "LAudioWaveformAnalyzer.h"

static const NSUInteger kDefaultSampleRate = 16000;
static const NSUInteger kDefaultChannels = 1;
static const NSUInteger kDefaultFrameLength = 60; // ms
static const NSUInteger kDefaultMaxDuration = 0;

@interface LAudioRecorderManager ()

@property (nonatomic, strong) AVAudioEngine *audioEngine;
@property (nonatomic, strong) AVAudioInputNode *inputNode;
@property (nonatomic, strong) dispatch_queue_t processingQueue;
@property (nonatomic, strong) NSMutableData *audioData;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, assign) NSTimeInterval startTime;
@property (nonatomic, assign) NSTimeInterval remainingTime;
@property (nonatomic, assign) BOOL isPaused;
@property (nonatomic, strong) LAudioWaveformAnalyzer *analyzer;
@property (nonatomic, assign) int bufferSize;

@end

@implementation LAudioRecorderManager

#pragma mark - 初始化

+ (instancetype)sharedManager {
    static LAudioRecorderManager *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[LAudioRecorderManager alloc] init];
    });
    return instance;
}

- (instancetype)init {
    return [self initWithSampleRate:kDefaultSampleRate
                           channels:kDefaultChannels
                        frameLength:kDefaultFrameLength
                        maxDuration:kDefaultMaxDuration];
}

- (instancetype)initWithSampleRate:(NSUInteger)sampleRate
                          channels:(NSUInteger)channels
                       frameLength:(NSUInteger)frameLength
                       maxDuration:(NSTimeInterval)maxDuration {
    self = [super init];
    if (self) {
        _sampleRate = sampleRate;
        _channels = channels;
        _frameLength = frameLength;
        _maxDuration = maxDuration;
        _isRecording = NO;
        _isPaused = NO;
        
        _processingQueue = dispatch_queue_create("com.audiorecorder.processing", DISPATCH_QUEUE_SERIAL);
        _audioData = [NSMutableData data];
        
        // 计算缓冲区大小（基于帧时长）
        UInt32 bufferSize = (UInt32)(_sampleRate * _frameLength / 1000.0);
        self.bufferSize = bufferSize;
        self.analyzer = [[LAudioWaveformAnalyzer alloc] initWithFFTSize:bufferSize sampleRate:sampleRate channels:channels];
        
        [self setupAudioSession];
    }
    return self;
}

#pragma mark - 音频会话配置

- (void)setupAudioSession {
    NSError *error = nil;
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    
    // 设置音频会话类别
    [audioSession setCategory:AVAudioSessionCategoryPlayAndRecord
                  withOptions:AVAudioSessionCategoryOptionDefaultToSpeaker |
                              AVAudioSessionCategoryOptionAllowBluetoothHFP |
                              AVAudioSessionCategoryOptionAllowAirPlay
                        error:&error];
    
    if (error) {
        NSLog(@"设置音频会话类别失败: %@", error.localizedDescription);
    }
    
    // 设置采样率
    [audioSession setPreferredSampleRate:self.sampleRate error:&error];
    if (error) {
        NSLog(@"设置采样率失败: %@", error.localizedDescription);
    }
    
    // 设置IO缓冲区时长（影响延迟）
    NSTimeInterval bufferDuration = (double)self.frameLength / 1000.0;
    [audioSession setPreferredIOBufferDuration:bufferDuration error:&error];
    if (error) {
        NSLog(@"设置IO缓冲区时长失败: %@", error.localizedDescription);
    }
    
    [audioSession setActive:YES error:&error];
    if (error) {
        NSLog(@"激活音频会话失败: %@", error.localizedDescription);
    }
}

#pragma mark - 录音控制

- (void)startRecording {
    if (self.isRecording && !self.isPaused) {
        NSLog(@"录音已在进行中");
        return;
    }
    
    if (self.isPaused) {
        [self resumeRecording];
        return;
    }
    
    // 重置数据
    [self.audioData setLength:0];
    self.startTime = [NSDate timeIntervalSinceReferenceDate];
    self.remainingTime = self.maxDuration;
    
    // 开始录音
    if ([self startRecordingWithAVAudioEngine]) {
        _isRecording = YES;
        self.isPaused = NO;
        
        // 通知代理
        if ([self.delegate respondsToSelector:@selector(audioRecorderManagerDidStartRecording:)]) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.delegate audioRecorderManagerDidStartRecording:self];
            });
        }
        
        // 启动定时器（用于最大录制时间）
        if (self.maxDuration > 0) {
            [self startTimer];
        }
    }
}

- (void)stopRecording {
    if (!self.isRecording) {
        return;
    }
    
    // 停止录音
    [self stopRecordingWithAVAudioEngine];
    
    // 停止定时器
    [self stopTimer];
    
    _isRecording = NO;
    self.isPaused = NO;
    
    // 获取完整录音数据
    NSData *fullAudioData = [self.audioData copy];
    
    // 通知代理
    if ([self.delegate respondsToSelector:@selector(audioRecorderManagerDidFinishRecording:audioData:)]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.delegate audioRecorderManagerDidFinishRecording:self audioData:fullAudioData];
        });
    }
    
    // 清理
    [self.audioData setLength:0];
}

- (void)pauseRecording {
    if (!self.isRecording || self.isPaused) {
        return;
    }
    
    // 暂停音频引擎
    [self.audioEngine pause];
    self.isPaused = YES;
    
    // 暂停定时器
    [self.timer invalidate];
    self.timer = nil;
}

- (void)resumeRecording {
    if (!self.isRecording || !self.isPaused) {
        return;
    }
    
    // 恢复音频引擎
    [self.audioEngine startAndReturnError:nil];
    self.isPaused = NO;
    
    // 恢复定时器
    if (self.maxDuration > 0) {
        [self startTimer];
    }
}

#pragma mark - AVAudioEngine 录音实现（实时输出）

- (BOOL)startRecordingWithAVAudioEngine {
    NSError *error = nil;
    
    // 检查权限
    AVAuthorizationStatus status = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeAudio];
    if (status != AVAuthorizationStatusAuthorized) {
        NSLog(@"没有麦克风权限");
        if ([self.delegate respondsToSelector:@selector(audioRecorderManager:didFailWithError:)]) {
            dispatch_async(dispatch_get_main_queue(), ^{
                NSError *error = [NSError errorWithDomain:@"没有麦克风权限" code:-1 userInfo:@{NSLocalizedDescriptionKey : @"没有麦克风权限"}];
                [self.delegate audioRecorderManager:self didFailWithError:error];
            });
        }
        return NO; // 没有权限
    }
    
    // 创建音频引擎
    self.audioEngine = [[AVAudioEngine alloc] init];
    self.inputNode = [self.audioEngine inputNode];
    
    // 获取输入节点的音频格式
    AVAudioFormat *inputFormat = [self.inputNode outputFormatForBus:0];
    
    // 创建目标格式：16kHz, 单声道, PCM
    AVAudioFormat *targetFormat = [[AVAudioFormat alloc]
                                  initWithCommonFormat:AVAudioPCMFormatInt16
                                  sampleRate:self.sampleRate
                                  channels:(AVAudioChannelCount)self.channels
                                  interleaved:YES];
    
    // 安装Tap回调
    __weak typeof(self) weakSelf = self;
    [self.inputNode installTapOnBus:0
                         bufferSize:self.bufferSize
                             format:inputFormat
                              block:^(AVAudioPCMBuffer *buffer, AVAudioTime *when) {
        [weakSelf processAudioBuffer:buffer targetFormat:targetFormat];
    }];
    
    // 启动音频引擎
    [self.audioEngine startAndReturnError:&error];
    
    if (error) {
        NSLog(@"启动音频引擎失败: %@", error.localizedDescription);
        if ([self.delegate respondsToSelector:@selector(audioRecorderManager:didFailWithError:)]) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.delegate audioRecorderManager:self didFailWithError:error];
            });
        }
        return NO;
    }
    
    return YES;
}

- (void)stopRecordingWithAVAudioEngine {
    if (self.audioEngine.isRunning) {
        [self.audioEngine stop];
    }
    
    if (self.inputNode) {
        [self.inputNode removeTapOnBus:0];
    }
    
    self.audioEngine = nil;
    self.inputNode = nil;
}

- (void)processAudioBuffer:(AVAudioPCMBuffer *)buffer targetFormat:(AVAudioFormat *)targetFormat {
    dispatch_async(self.processingQueue, ^{
        @autoreleasepool {
            // 转换为目标格式
            AVAudioConverter *converter = [[AVAudioConverter alloc]
                                          initFromFormat:buffer.format
                                          toFormat:targetFormat];
            
            // 计算目标缓冲区大小
            UInt32 targetFrameCapacity = (UInt32)(buffer.frameLength *
                                                 targetFormat.sampleRate /
                                                 buffer.format.sampleRate);
            
            AVAudioPCMBuffer *targetBuffer = [[AVAudioPCMBuffer alloc]
                                             initWithPCMFormat:targetFormat
                                             frameCapacity:targetFrameCapacity];
            
            NSError *error = nil;
            AVAudioConverterOutputStatus status = [converter convertToBuffer:targetBuffer
                                                                       error:&error
                                                          withInputFromBlock:^AVAudioBuffer * _Nullable(
                                                                  AVAudioPacketCount inNumberOfPackets,
                                                                  AVAudioConverterInputStatus *outStatus) {
                *outStatus = AVAudioConverterInputStatus_HaveData;
                return buffer;
            }];
            
            if (status == AVAudioConverterOutputStatus_HaveData && targetBuffer) {
                // 获取PCM数据
                NSData *pcmData = [self pcmDataFromBuffer:targetBuffer];
                
                if (pcmData.length > 0) {
                    // 保存到完整录音数据
                    [self.audioData appendData:pcmData];
                    
                    NSArray *spectrums = [self.analyzer analyse:buffer withAmplitudeLevel:25];
                    if (spectrums.count == 1) {
                        NSArray *spectrum = spectrums.firstObject;
                        spectrums = @[spectrum, spectrum];
                    }
                    
                    // 实时输出
                    if ([self.delegate respondsToSelector:@selector(audioRecorderManager:didOutputAudioData:audioPower:)]) {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [self.delegate audioRecorderManager:self didOutputAudioData:pcmData audioPower:spectrums];
                        });
                    }
                }
            }
        }
    });
}

- (NSData *)pcmDataFromBuffer:(AVAudioPCMBuffer *)buffer {
    if (!buffer || buffer.frameLength == 0) {
        return [NSData data];
    }
    
    // 获取音频数据指针
    int16_t *int16Data = (int16_t *)buffer.int16ChannelData[0];
    if (!int16Data) {
        return [NSData data];
    }
    
    // 计算数据大小
    NSUInteger dataSize = buffer.frameLength * buffer.format.streamDescription->mBytesPerFrame;
    
    // 创建NSData
    NSData *pcmData = [NSData dataWithBytes:int16Data length:dataSize];
    
    return pcmData;
}

#pragma mark - 定时器相关

- (void)startTimer {
    [self stopTimer];
    
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0
                                                  target:self
                                                selector:@selector(timerFired)
                                                userInfo:nil
                                                 repeats:YES];
}

- (void)stopTimer {
    if (self.timer) {
        [self.timer invalidate];
        self.timer = nil;
    }
}

- (void)timerFired {
    if (!self.isRecording || self.isPaused) {
        return;
    }
    
    // 计算已录制时间
    NSTimeInterval elapsed = [NSDate timeIntervalSinceReferenceDate] - self.startTime;
    
    if (self.maxDuration > 0) {
        self.remainingTime = MAX(0, self.maxDuration - elapsed);
        
        // 通知剩余时间更新
        if ([self.delegate respondsToSelector:@selector(audioRecorderManager:remainingTimeDidUpdate:)]) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.delegate audioRecorderManager:self remainingTimeDidUpdate:self.remainingTime];
            });
        }
        
        // 检查是否超时
        if (elapsed >= self.maxDuration) {
            [self stopRecording];
        }
    }
}

#pragma mark - 属性访问

- (NSTimeInterval)currentTime {
    if (!self.isRecording) {
        return 0;
    }
    return [NSDate timeIntervalSinceReferenceDate] - self.startTime;
}

#pragma mark - 清理

- (void)dealloc {
    [self stopRecording];
    [self stopTimer];
}

@end
