//
//  LAudioPlayer.m
//  LGlassesKit_iOS_Demo
//
//  Created by LINWEAR on 2025-10-31.
//

#import "LAudioPlayer.h"
#import <AVFoundation/AVFoundation.h>

@implementation LAudioPlayer

#pragma mark - 初始化
- (instancetype)initWithSampleRate:(float)sampleRate
                          channels:(UInt32)channels
                    bitsPerSample:(UInt32)bitsPerSample {
    self = [super init];
    if (self) {
        _isPlaying = NO;
        _isStopped = YES; // 初始状态为已停止
        _bufferSize = 4096;
        
        // 保存音频参数
        _sampleRate = sampleRate;
        _channels = channels;
        _bitsPerSample = bitsPerSample;
        
        // 创建线程安全的数据队列
        _dataQueue = dispatch_queue_create("com.audio.pcmdata", DISPATCH_QUEUE_SERIAL);
        _pcmDataBuffer = [NSMutableData data];
        
        // 初始化音频格式
        [self setupAudioFormat];
        
        // 音频会话配置
        [self setupAudioSession];
        
        NSLog(@"PCMStreamPlayer 初始化完成，采样率: %.0f, 通道数: %u, 位深度: %u",
              sampleRate, (unsigned int)channels, (unsigned int)bitsPerSample);
    }
    return self;
}

- (void)setupAudioFormat {
    memset(&_audioFormat, 0, sizeof(_audioFormat));
    
    _audioFormat.mSampleRate = _sampleRate;
    _audioFormat.mFormatID = kAudioFormatLinearPCM;
    _audioFormat.mFormatFlags = kLinearPCMFormatFlagIsSignedInteger | kAudioFormatFlagIsPacked;
    _audioFormat.mChannelsPerFrame = _channels;
    _audioFormat.mBitsPerChannel = _bitsPerSample;
    _audioFormat.mBytesPerPacket = (_bitsPerSample / 8) * _channels;
    _audioFormat.mBytesPerFrame = (_bitsPerSample / 8) * _channels;
    _audioFormat.mFramesPerPacket = 1;
    _audioFormat.mReserved = 0;
}

#pragma mark - 播放器初始化
- (BOOL)initializeAudioQueue {
    if (_audioQueue != NULL) {
        NSLog(@"音频队列已存在，先清理");
        [self cleanupAudioQueue];
    }
    
    // 创建音频队列
    OSStatus status = AudioQueueNewOutput(&_audioFormat,
                                         audioQueueOutputCallback,
                                         (__bridge void *)(self),
                                         NULL,
                                         NULL,
                                         0,
                                         &_audioQueue);
    
    if (status != noErr) {
        NSLog(@"创建音频队列失败: %d", (int)status);
        _audioQueue = NULL;
        return NO;
    }
    
    // 分配音频缓冲区指针数组
    _audioBuffers = (AudioQueueBufferRef *)malloc(sizeof(AudioQueueBufferRef) * kNumberBuffers);
    if (_audioBuffers == NULL) {
        NSLog(@"音频缓冲区内存分配失败");
        AudioQueueDispose(_audioQueue, true);
        _audioQueue = NULL;
        return NO;
    }
    
    // 初始化指针
    for (int i = 0; i < kNumberBuffers; i++) {
        _audioBuffers[i] = NULL;
    }
    
    // 分配音频缓冲区
    for (int i = 0; i < kNumberBuffers; ++i) {
        status = AudioQueueAllocateBuffer(_audioQueue, _bufferSize, &_audioBuffers[i]);
        if (status != noErr) {
            NSLog(@"分配音频缓冲区 %d 失败: %d", i, (int)status);
            [self cleanupAudioQueue];
            return NO;
        }
        
        // 初始填充静音
        _audioBuffers[i]->mAudioDataByteSize = _bufferSize;
        memset(_audioBuffers[i]->mAudioData, 0, _bufferSize);
        
        // 将缓冲区入队
        status = AudioQueueEnqueueBuffer(_audioQueue, _audioBuffers[i], 0, NULL);
        if (status != noErr) {
            NSLog(@"初始缓冲区入队失败: %d", (int)status);
        }
    }
    
    // 设置音频队列属性
    AudioQueueSetParameter(_audioQueue, kAudioQueueParam_Volume, 1.0);
    
    _isStopped = NO;
    NSLog(@"音频队列初始化成功");
    return YES;
}

#pragma mark - 检查并重新初始化
- (BOOL)reinitializeIfNeeded {
    if (_isStopped || _audioQueue == NULL) {
        NSLog(@"需要重新初始化音频队列");
        return [self initializeAudioQueue];
    }
    return YES;
}

#pragma mark - 音频会话配置
- (void)setupAudioSession {
    NSError *error = nil;
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    
    // 设置音频会话类别为播放，支持后台播放
    [audioSession setCategory:AVAudioSessionCategoryPlayback
                         mode:AVAudioSessionModeDefault
                      options:AVAudioSessionCategoryOptionMixWithOthers |
                              AVAudioSessionCategoryOptionAllowBluetoothA2DP
                        error:&error];
    
    NSLog(@"播放器设置音频会话类别 %@", error);
    
    // 激活音频会话
    [audioSession setActive:YES error:&error];
    NSLog(@"播放器激活音频会话 %@", error);
}

#pragma mark - 播放控制
- (void)startPlayback {
    if (_isPlaying) {
        NSLog(@"已经在播放中");
        return;
    }
    
    // 确保音频队列已初始化
    if (![self reinitializeIfNeeded]) {
        NSLog(@"音频队列初始化失败，无法播放");
        return;
    }
    
    // 检查是否有足够的数据开始播放
    dispatch_sync(_dataQueue, ^{
        if (self.pcmDataBuffer.length < self.bufferSize) {
            NSLog(@"数据不足，等待更多数据。当前: %lu, 需要: %u",
                  (unsigned long)self.pcmDataBuffer.length, self.bufferSize);
            return;
        }
    });
    
    // 启动音频队列
    OSStatus status = AudioQueueStart(_audioQueue, NULL);
    if (status == noErr) {
        _isPlaying = YES;
        NSLog(@"开始播放 PCM 数据流");
    } else {
        NSLog(@"启动音频队列失败: %d", (int)status);
    }
}

- (void)stopPlayback {
    if (!_isPlaying && _isStopped) {
        NSLog(@"已经停止");
        return;
    }
    
    NSLog(@"停止播放并清理资源");
    
    _isPlaying = NO;
    
    if (_audioQueue) {
        // 停止音频队列
        AudioQueueStop(_audioQueue, true);
        AudioQueueReset(_audioQueue);
    }
    
    // 清空数据缓冲区
    dispatch_sync(_dataQueue, ^{
        [self.pcmDataBuffer setLength:0];
    });
    
    // 清理音频队列资源
    [self cleanupAudioQueue];
    
    _isStopped = YES;
    NSLog(@"播放已完全停止，资源已清理");
}

#pragma mark - 数据输入
- (void)appendPCMData:(NSData *)pcmData {
    if (!pcmData || pcmData.length == 0) {
        NSLog(@"接收到空数据");
        return;
    }
    
    dispatch_async(_dataQueue, ^{
        // 将新数据添加到缓冲区
        NSUInteger previousLength = self.pcmDataBuffer.length;
        [self.pcmDataBuffer appendData:pcmData];
        
        NSLog(@"接收到 %lu 字节 PCM 数据，缓冲区大小: %lu -> %lu",
              (unsigned long)pcmData.length,
              (unsigned long)previousLength,
              (unsigned long)self.pcmDataBuffer.length);
        
        // 如果停止状态且有足够数据，重新初始化并开始播放
        if (self.isStopped && self.pcmDataBuffer.length >= self.bufferSize) {
            NSLog(@"有新的音频流数据，准备重新播放");
            dispatch_async(dispatch_get_main_queue(), ^{
                if ([self reinitializeIfNeeded]) {
                    [self startPlayback];
                }
            });
        }
        // 如果已经在播放但暂停了，且有足够数据，恢复播放
        else if (!self.isPlaying && self.audioQueue != NULL && self.pcmDataBuffer.length >= self.bufferSize) {
            NSLog(@"有新的数据，恢复播放");
            dispatch_async(dispatch_get_main_queue(), ^{
                OSStatus status = AudioQueueStart(self.audioQueue, NULL);
                if (status == noErr) {
                    self.isPlaying = YES;
                    NSLog(@"恢复播放成功");
                }
            });
        }
    });
}

#pragma mark - 音频队列回调
static void audioQueueOutputCallback(void *inUserData,
                                   AudioQueueRef inAQ,
                                   AudioQueueBufferRef inBuffer) {
    LAudioPlayer *player = (__bridge LAudioPlayer *)inUserData;
    [player fillBuffer:inBuffer];
}

- (void)fillBuffer:(AudioQueueBufferRef)buffer {
    dispatch_sync(_dataQueue, ^{
        // 计算需要复制的数据量
        UInt32 bufferCapacity = buffer->mAudioDataBytesCapacity;
        NSUInteger bytesToCopy = MIN(self.pcmDataBuffer.length, (NSUInteger)bufferCapacity);
        
        if (bytesToCopy > 0) {
            // 复制数据到音频缓冲区
            memcpy(buffer->mAudioData, self.pcmDataBuffer.bytes, bytesToCopy);
            buffer->mAudioDataByteSize = (UInt32)bytesToCopy;
            
            // 从缓冲区移除已使用的数据
            NSRange range = NSMakeRange(0, bytesToCopy);
            [self.pcmDataBuffer replaceBytesInRange:range withBytes:NULL length:0];
            
            // 将缓冲区入队
            OSStatus status = AudioQueueEnqueueBuffer(_audioQueue, buffer, 0, NULL);
            if (status != noErr) {
                NSLog(@"音频缓冲区入队失败: %d", (int)status);
            }
            
            // 打印缓冲区状态
            if (self.pcmDataBuffer.length < self.bufferSize) {
                NSLog(@"缓冲区数据不足，剩余: %lu", (unsigned long)self.pcmDataBuffer.length);
            }
        } else {
            // 没有数据，填充静音
            buffer->mAudioDataByteSize = bufferCapacity;
            memset(buffer->mAudioData, 0, bufferCapacity);
            
            OSStatus status = AudioQueueEnqueueBuffer(_audioQueue, buffer, 0, NULL);
            if (status != noErr) {
                NSLog(@"静音缓冲区入队失败: %d", (int)status);
            }
            
            // 如果长时间没有数据，停止播放
            if (self.pcmDataBuffer.length == 0) {
                NSLog(@"没有数据可播放，准备停止");
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self stopPlayback];
                });
            }
        }
    });
}

#pragma mark - 资源清理
- (void)cleanupAudioQueue {
    if (_audioQueue) {
        // 先停止
        AudioQueueStop(_audioQueue, true);
        
        // 释放音频缓冲区
        if (_audioBuffers) {
            for (int i = 0; i < kNumberBuffers; i++) {
                if (_audioBuffers[i]) {
                    AudioQueueFreeBuffer(_audioQueue, _audioBuffers[i]);
                    _audioBuffers[i] = NULL;
                }
            }
            free(_audioBuffers);
            _audioBuffers = NULL;
        }
        
        // 释放音频队列
        AudioQueueDispose(_audioQueue, true);
        _audioQueue = NULL;
        
        NSLog(@"音频队列资源已清理");
    }
}

- (void)cleanup {
    [self stopPlayback];
    
    // 额外清理数据缓冲区
    dispatch_sync(_dataQueue, ^{
        [self.pcmDataBuffer setLength:0];
    });
    
    NSLog(@"PCMStreamPlayer 完全清理完成");
}

- (void)dealloc {
    [self cleanup];
    NSLog(@"PCMStreamPlayer 已释放");
}

@end
