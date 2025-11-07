//
//  LAIGC.m
//  LGlassesKit_iOS_Demo
//
//  Created by LINWEAR on 2025-10-27.
//

#import "LAIGC.h"
#import "LAssistantModel.h"
#import "LOpusDecoder.h"
#import "LAudioPlayer.h"

@interface LAIGC ()

@property (nonatomic, strong) LWAIGCMcpModel *mcpModel;

@property (nonatomic, strong) LOpusDecoder *opusDecoder;

@property (nonatomic, strong) LAudioPlayer *audioPlayer;

@end

@implementation LAIGC

+ (LAIGC *)sharedManager {
    static LAIGC *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken,^{
        instance = [LAIGC new];
    });
    return instance;
}

- (instancetype)init {
    if (self = [super init]) {
        // 解码器
        self.opusDecoder = [[LOpusDecoder alloc] initWithSampleRate:16000 channels:1];
        // 播放器
        self.audioPlayer = [[LAudioPlayer alloc] initWithSampleRate:16000 channels:1 bitsPerSample:16];
    }
    return self;
}

/// 注册AIGC
+ (void)registerAIGC
{
    RLMDeviceModel *deviceModel = RLMDeviceModel.allObjects.lastObject;
    
    LWAIGCModel *aigcModel = [LWAIGCModel new];
    aigcModel.clientId = @"FqN8ObrRfdhROlvkNJnoV9fZQ0G5Cxs3";
    aigcModel.clientSk = @"P6koemmROicVyGcR";
    aigcModel.deviceId = deviceModel.deviceMac;
    aigcModel.deviceName = deviceModel.deviceName;
    aigcModel.deviceModel = deviceModel.deviceMode;
    aigcModel.serverNode = DEV_DOMAIN;
    // 初始化AI
    [LWAIGCKit initAIGCWithModel:aigcModel];
}

/// 连接智能体
+ (void)connectAgentWebSocket
{
    LWAIGCAudioInfoModel *audioInfo = [LWAIGCAudioInfoModel new];
    audioInfo.format = @"opus";
    audioInfo.sample_rate = 16000;
    audioInfo.channels = 1;
    audioInfo.frame_duration = 40;
    // 设置音频参数，连接AI语音智能体
    [LWAIGCKit requestConnectAiVoiceAgentWebSocket:audioInfo sttCallback:^(NSString * _Nullable stt, NSTimeInterval timeInterval) {
        // 语音转文本回调
        LAssistantModel *assistantModel = [LAssistantModel new];
        assistantModel.assistantType = LAssistantType_UserText;
        assistantModel.isAdd = YES;
        assistantModel.param = stt;
        [[NSNotificationCenter defaultCenter] postNotificationName:LAIVoiceAssistantNotify object:assistantModel];
        
    } ttsCallback:^(LWAIGCTTSSTATUS ttsStatus, NSString * _Nullable tts, NSTimeInterval timeInterval) {
        // 回复文本回调
        LAssistantModel *assistantModel = [LAssistantModel new];
        assistantModel.assistantType = LAssistantType_AssistantText;
        assistantModel.param = tts;
        assistantModel.isAdd = ttsStatus == LWAIGCTTSSTATUS_START;
        [[NSNotificationCenter defaultCenter] postNotificationName:LAIVoiceAssistantNotify object:assistantModel];
        
        if (ttsStatus == LWAIGCTTSSTATUS_STOP) {
            [[LAIGC sharedManager].audioPlayer stopPlayback];
        }
        
    } audioCallback:^(NSData * _Nonnull audioData) {
        // 回复文本语音回调
        // 解码 OPUS -> PCM
        NSError *decodeError = nil;
        NSData *pcmData = [[LAIGC sharedManager].opusDecoder decodeOpusData:audioData error:&decodeError];
        
        if (pcmData) {
            // 播放 PCM
            NSLog(@"解码成功: %@", pcmData);
            [[LAIGC sharedManager].audioPlayer appendPCMData:pcmData];
        } else {
            NSLog(@"解码失败: %@", decodeError);
        }
        
    } mcpCmdCallback:^(LWAIGCMcpModel * _Nonnull mcpModel, NSTimeInterval timeInterval) {
        // mcp命令回调
        [LAIGC sharedManager].mcpModel = mcpModel;
        
        if (mcpModel.cmd == LWAIGCMCPCMD_AI_IMAGE_RECOGNIYION) { // 需要拍照
                        
            // 成功拍照后图片会通过委托代理LDelegate返回 详@link notifyAIRecognizePhotoData:
            [LGlassesKit startTakingPhotos:LPhotoType_PhotoRecognition callback:^(NSError * _Nullable error) {
                NSLog(@"拍照结果: %@", error);
            }];
        }
        
    } stopCallback:^{
        // 停止回调
        // 停止录音
        [LGlassesKit stopAudioRecordingWithCallback:^(NSError * _Nullable error) {
            NSLog(@"停止录音: %@", error);
        }];
        
    }];
}

/// 断开智能体
+ (void)disconnectAgentWebSocket
{
    [LWAIGCKit disconnectAiVoiceAgentWebSocket];
}

/// 开始录音
+ (void)startRecording
{
    [LWAIGCKit startSpeechRecognition:STT_AUTO lang:@"zh"]; // 中文
}

/// 发送音频数据
+ (void)sendAudioData:(NSData *)data
{
    [LWAIGCKit sendRecognizedVoiceData:data];
}

/// 上传图片开始识图
+ (void)requestUploadImageData:(NSData *)data
{
    NSURL *url = [LCacheDirectoryURL URLByAppendingPathComponent:[NSString stringWithFormat:@"ai_photo_%ld.JPG", (NSInteger)NSDate.date.timeIntervalSince1970]];

    NSError *error = nil;
    [data writeToURL:url options:NSDataWritingAtomic error:&error]; // 缓存到本地
    
    if (error) {
        [LHUD showText:error.localizedDescription];
    }
    else {
        
        LAssistantModel *assistantModel = [LAssistantModel new];
        assistantModel.assistantType = LAssistantType_UserImage;
        assistantModel.param = url.path;
        assistantModel.isAdd = YES;
        [[NSNotificationCenter defaultCenter] postNotificationName:LAIVoiceAssistantNotify object:assistantModel];
        
        // 识图
        [LWAIGCKit requestUploadImageData:data question:[LAIGC sharedManager].mcpModel.arguments_1 callback:^(NSString * _Nullable result, NSError * _Nullable error) {
            if (error) {
                [LHUD showText:error.localizedDescription];
            }
            else {
                
                LAssistantModel *assistantModel_1 = [LAssistantModel new];
                assistantModel_1.assistantType = LAssistantType_UserText;
                assistantModel_1.param = [NSString stringWithFormat:@"图片识别内容: %@", result];
                assistantModel_1.isAdd = YES;
                [[NSNotificationCenter defaultCenter] postNotificationName:LAIVoiceAssistantNotify object:assistantModel_1];
                
                // 发送识图结果
                [LWAIGCKit sendImageRecognitionResults:result task_id:[LAIGC sharedManager].mcpModel.task_id];
            }
        }];
    }
}

@end
