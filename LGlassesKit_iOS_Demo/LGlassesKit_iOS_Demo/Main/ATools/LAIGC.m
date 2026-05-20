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

@interface LAIGC () <LWAIGCKitDelegete>

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

- (void)logDidOutputtingWithText:(NSString *)text
{
    NSLog(@"日志 %@", text);
}

- (void)aiVoiceAgentWebSocketConnectionStatus:(LWAIGCWEBSOCKETSTATUS)status
{
    NSLog(@"ws连接状态 %lu", status);
}

- (instancetype)init {
    if (self = [super init]) {
        // 解码器
        self.opusDecoder = [[LOpusDecoder alloc] initWithSampleRate:16000 channels:1];
        // 播放器
        self.audioPlayer = [[LAudioPlayer alloc] initWithSampleRate:16000 channels:1 bitsPerSample:16];
        
        self.allowUseVoiceAssistant = YES;
        
        [LWAIGCKit registerDelegete:self];
        
#pragma mark - 注册智能体对话回调
        // 注册智能体对话回调
        [LWAIGCKit registerChatSttCallback:^(NSString * _Nullable stt, NSTimeInterval timeInterval) {
            
            // 语音转文本回调
            LAssistantModel *assistantModel = [LAssistantModel new];
            assistantModel.assistantType = LAssistantType_UserText;
            assistantModel.param = stt;
            // stt没有message_id参数，且为句式返回非流式，这里且用当前时间戳作为message_id
            assistantModel.messageId = [NSString stringWithFormat:@"UserText_%.6f", timeInterval];
            [[NSNotificationCenter defaultCenter] postNotificationName:LAIGCChatNotify object:assistantModel];
            
        } chatTtsCallback:^(LWAIGCTTSSTATUS ttsStatus, NSString * _Nullable message_id, NSString * _Nullable tts, NSTimeInterval timeInterval) {
            
            if (!IF_NULL(message_id)) {
                // 文本回复回调
                LAssistantModel *assistantModel = [LAssistantModel new];
                assistantModel.assistantType = LAssistantType_AssistantText;
                assistantModel.param = tts;
                /// tts有message_id，返回方式为流式非句式，请注意处理
                assistantModel.messageId = message_id;
                [[NSNotificationCenter defaultCenter] postNotificationName:LAIGCChatNotify object:assistantModel];
            }
            
            if (ttsStatus == LWAIGCTTSSTATUS_STOP) {
                [[LAIGC sharedManager].audioPlayer stopPlayback];
            }
            
        } chatAudioCallback:^(LWAIGCAudioStream * _Nonnull audioStream) {
            
            if (!audioStream.payload.length) return;
            
            // 音频回复回调
            // 解码 OPUS -> PCM
            NSError *decodeError = nil;
            NSData *pcmData = [[LAIGC sharedManager].opusDecoder decodeOpusData:audioStream.payload error:&decodeError];
            
            if (pcmData) {
                // 播放 PCM
                NSLog(@"解码成功: %@", pcmData);
                [[LAIGC sharedManager].audioPlayer appendPCMData:pcmData];
            } else {
                NSLog(@"解码失败: %@", decodeError);
            }
            
        } chatMcpCmdCallback:^(LWAIGCMcpModel * _Nonnull mcpModel, NSTimeInterval timeInterval) {
            
            // mcp命令回调
            [LAIGC sharedManager].mcpModel = mcpModel;
            
            if (mcpModel.cmd == LWAIGCMCPCMD_AI_IMAGE_RECOGNIYION) { // 需要拍照
                   
                [LGlassesKit startPhotoTakingWithCompletion:^(NSData * _Nullable photoData, NSError * _Nullable error) {
                    if (error) {
                        [LHUD showText:error.localizedDescription];
                    }
                    else if (photoData.length)
                    {
                        [LAIGC requestUploadImageData:photoData]; // 上传图片开始识图
                    }
                }];
            }
            else if (mcpModel.cmd == LWAIGCMCPCMD_SCHEDULE_ASSISTANT) { // 日程助手
                
                NSLog(@"日程助手 %@", mcpModel.schedule);
                [[NSNotificationCenter defaultCenter] postNotificationName:LAIGCCScheduleNotify object:mcpModel.schedule];
            }
            
        } chatStopCallback:^{
            
            LAIGC.sharedManager.usingVoiceAssistant = NO;
            // 停止回调
            // 中断语音传输
            [LGlassesKit abortVoiceTransmissionWithCallback:^(NSError * _Nullable error) {
                NSLog(@"中断语音: %@", error);
            }];
        }];
        
        
#pragma mark - 注册智能体翻译回调
        /// 注册智能体翻译回调
        [LWAIGCKit registerTranslationTextCallback:^(LWAIGCTranslateTextModel * _Nonnull translateTextModel) {
            
            [[NSNotificationCenter defaultCenter] postNotificationName:LAIGCTranslateNotify object:translateTextModel];
            
        } translationAudioCallback:^(LWAIGCAudioStream * _Nonnull audioStream) {
            
            if (!audioStream.payload.length) return;
            
            // 音频回复回调
            // 解码 OPUS -> PCM
            NSError *decodeError = nil;
            NSData *pcmData = [[LAIGC sharedManager].opusDecoder decodeOpusData:audioStream.payload error:&decodeError];
            
            if (pcmData) {
                // 播放 PCM
                NSLog(@"解码成功: %@", pcmData);
                [[LAIGC sharedManager].audioPlayer appendPCMData:pcmData];
            } else {
                NSLog(@"解码失败: %@", decodeError);
            }
            
        }];
        
#pragma mark - 注册智能体同声传译回调
        // 注册智能体同声传译回调
        [LWAIGCKit registerSimultaneousInterpretationTextCallback:^(LWAIGCTranslateTextModel * _Nonnull translateTextModel) {
            
            [[NSNotificationCenter defaultCenter] postNotificationName:LAIGCSimultaneousInterpretationNotify object:translateTextModel];
            
        } simultaneousInterpretationAudioCallback:^(LWAIGCAudioStream * _Nonnull audioStream) {
            
            if (!audioStream.payload.length) return;
            
            // 音频回复回调
            // 解码 OPUS -> PCM
            NSError *decodeError = nil;
            NSData *pcmData = [[LAIGC sharedManager].opusDecoder decodeOpusData:audioStream.payload error:&decodeError];
            
            if (pcmData) {
                // 播放 PCM
                NSLog(@"解码成功: %@", pcmData);
                [[LAIGC sharedManager].audioPlayer appendPCMData:pcmData];
            } else {
                NSLog(@"解码失败: %@", decodeError);
            }
            
        }];
        
#pragma mark - 注册智能体通话翻译回调
        // 注册智能体通话翻译回调
        [LWAIGCKit registerCallTranslationTextCallback:^(LWAIGCTranslateTextModel * _Nonnull translateTextModel) {
            
            [[NSNotificationCenter defaultCenter] postNotificationName:LAIGCCallTranslationNotify object:translateTextModel];
        }];
    }
    return self;
}

/// 注册AIGC
+ (void)registerAIGC
{
    RLMDeviceModel *deviceModel = RLMDeviceModel.allObjects.lastObject;
#warning - 请联系服务商提供正式
    LWAIGCModel *aigcModel = [LWAIGCModel new];
    aigcModel.clientId = @"ukuSPzMnpLvLS2TTLL9S8PvUJzfTCHnu"; // 此为test，请联系服务商提供正式
    aigcModel.clientSk = @"tz5dgRLm6tXS8gRr"; // 此为test，请联系服务商提供正式
    aigcModel.deviceId = deviceModel.deviceMac;
    aigcModel.deviceName = deviceModel.deviceName;
    aigcModel.deviceModel = deviceModel.deviceMode;
    aigcModel.sdkType = SDKTYPE_LY; // 具体连接设备的方案商
    aigcModel.serverNode = DEV_DOMAIN; // demo使用了开发环境
    // 初始化AI
    [LWAIGCKit initAIGCWithModel:aigcModel];
    
    [LAIGC sharedManager];
}

/// 智能体连接状态
+ (LWAIGCWEBSOCKETSTATUS)agentState
{
    return LWAIGCKit.aiVoiceAgentWebSocketState;
}

/// 连接智能体
+ (void)connectAgentWebSocket:(void (^)(NSError * _Nonnull))callback
{
#warning - 根据设备录音信息设置音频参数
    // 根据设备录音信息设置音频参数
    LWAIGCAudioInfoModel *audioInfo = [LWAIGCAudioInfoModel new];
    audioInfo.format = @"opus";
    audioInfo.sample_rate = 16000;
    audioInfo.channels = 1;
    audioInfo.frame_duration = 40;
    
    // 设置音频参数，连接AI语音智能体
    [LWAIGCKit requestConnectAiVoiceAgentWebSocket:audioInfo resultCallback:^(NSError * _Nullable error) {
        NSLog(@"AI语音智能体连接结果 %@", error);
        
        if (!error) {
            // 智能体连接成功
            [[NSNotificationCenter defaultCenter] postNotificationName:LAIGCConnectionSuccessfulNotify object:nil];
        }
        
        if (callback) {
            callback(error);
        }
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
#warning - 实际请根据需要的语言设置、模型
    // 支持的语言查阅本地 language.json 文件
    [LWAIGCKit startChatSpeechRecognition:STT_AUTO llmType:LWLLMMODELTYPE_DEFAULT language:140]; // demo这里固定使用了 中文（普通话，简体），模型默认
}

/// 发送语音助手音频数据
+ (void)sendChatAudioData:(NSData *)data
{
    [LWAIGCKit sendChatVoiceData:data];
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
        // 这里且用当前时间戳作为message_id
        assistantModel.messageId = [NSString stringWithFormat:@"UserImage_%.6f", NSDate.date.timeIntervalSince1970];
        [[NSNotificationCenter defaultCenter] postNotificationName:LAIGCChatNotify object:assistantModel];
        
        // 识图
        [LWAIGCKit sendRecognitionImageData:data question:[LAIGC sharedManager].mcpModel.question task_id:[LAIGC sharedManager].mcpModel.task_id];
        
//        // 识图
//        [LWAIGCKit requestChatUploadImageData:data question:[LAIGC sharedManager].mcpModel.question callback:^(NSString * _Nullable result, NSError * _Nullable error) {
//            if (error) {
//                [LHUD showText:error.localizedDescription];
//            }
//            else {
//                // 识别成功
//                LAssistantModel *assistantModel_1 = [LAssistantModel new];
//                assistantModel_1.assistantType = LAssistantType_UserText;
//                assistantModel_1.param = [NSString stringWithFormat:@"图片识别内容: %@", result];
//                assistantModel_1.isAdd = YES;
//                [[NSNotificationCenter defaultCenter] postNotificationName:LAIGCChatNotify object:assistantModel_1];
//                
//                // 发送识图结果
//                [LWAIGCKit sendChatImageRecognitionResults:result task_id:[LAIGC sharedManager].mcpModel.task_id];
//            }
//        }];
    }
}

/// 开始翻译
+ (void)startTranslationFromLanguage:(NSInteger)fromLanguage toLanguage:(NSInteger)toLanguage
{
    LWAIGCAudioInfoModel *audioInfo = [LWAIGCAudioInfoModel new];
    audioInfo.format = @"pcm";
    audioInfo.sample_rate = 16000;
    audioInfo.channels = 1;
    audioInfo.frame_duration = 60;
    
    LWAIGCTranslateModel *translateModel = [LWAIGCTranslateModel new];
    translateModel.from_language = fromLanguage;
    translateModel.to_language_list = @[@(toLanguage)];
    translateModel.audioInfo = audioInfo;
    
    [LWAIGCKit setTranslationInfo:translateModel];
    
    [LWAIGCKit startTranslateSpeechRecognition:@(NSDate.date.timeIntervalSince1970).stringValue];
}

/// 发送翻译音频数据
+ (void)sendTranslationAudioData:(NSData *)data
{
    [LWAIGCKit sendTranslateVoiceData:data];
}

/// 结束翻译
+ (void)endTranslation
{
    [LWAIGCKit stopTranslateSpeechRecognition];
}

/// 开始同声传译
+ (void)startSimultaneousInterpretationFromLanguage:(NSInteger)fromLanguage toLanguage:(NSInteger)toLanguage
{
    LWAIGCAudioInfoModel *audioInfo = [LWAIGCAudioInfoModel new];
    audioInfo.format = @"pcm";
    audioInfo.sample_rate = 16000;
    audioInfo.channels = 1;
    audioInfo.frame_duration = 60;
    
    LWAIGCTranslateModel *translateModel = [LWAIGCTranslateModel new];
    translateModel.from_language = fromLanguage;
    translateModel.to_language_list = @[@(toLanguage)];
    translateModel.audioInfo = audioInfo;
    
    [LWAIGCKit setTranslationInfo:translateModel];
    
    [LWAIGCKit startSimultaneousInterpretationSpeechRecognition:@(NSDate.date.timeIntervalSince1970).stringValue];
}

/// 发送同声传译音频数据
+ (void)sendSimultaneousInterpretationAudioData:(NSData *)data
{
    [LWAIGCKit sendSimultaneousInterpretationVoiceData:data];
}

/// 结束同声传译
+ (void)endSimultaneousInterpretation
{
    [LWAIGCKit stopSimultaneousInterpretationSpeechRecognition];
}

/// 开始通话翻译
+ (void)startCallTranslationFromLanguage:(NSInteger)fromLanguage toLanguage:(NSInteger)toLanguage
{
    LWAIGCAudioInfoModel *audioInfo = [LWAIGCAudioInfoModel new];
    audioInfo.format = @"pcm";
    audioInfo.sample_rate = 16000;
    audioInfo.channels = 1;
    audioInfo.frame_duration = 60;
    
    LWAIGCTranslateModel *translateModel = [LWAIGCTranslateModel new];
    translateModel.from_language = fromLanguage;
    translateModel.to_language_list = @[@(toLanguage)];
    translateModel.audioInfo = audioInfo;
    
    [LWAIGCKit setTranslationInfo:translateModel];
    
    [LWAIGCKit startCallTranslationSpeechRecognition:@(NSDate.date.timeIntervalSince1970).stringValue];
}

/// 发送通话翻译音频数据
+ (void)sendCallTranslationAudioData:(NSData *)data
{
    [LWAIGCKit sendCallTranslationVoiceData:data];
}

/// 结束通话翻译
+ (void)endCallTranslation
{
    [LWAIGCKit stopCallTranslationSpeechRecognition];
}

/// 图片翻译
+ (void)startImageTranslationWithImageData:(NSData *)data fromLanguage:(NSInteger)fromLanguage toLanguage:(NSInteger)toLanguage callback:(void (^)(NSString * _Nonnull, NSError * _Nonnull))callback
{
    [LWAIGCKit startTranslationWithImageData:data fromLanguage:fromLanguage toLanguage:toLanguage callback:callback];
}

@end
