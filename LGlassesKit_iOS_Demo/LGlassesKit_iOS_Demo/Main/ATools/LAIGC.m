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
        
        // 注册智能体对话回调
        [LWAIGCKit registerChatSttCallback:^(NSString * _Nullable stt, NSTimeInterval timeInterval) {
            
            // 语音转文本回调
            LAssistantModel *assistantModel = [LAssistantModel new];
            assistantModel.assistantType = LAssistantType_UserText;
            assistantModel.isAdd = YES;
            assistantModel.param = stt;
            [[NSNotificationCenter defaultCenter] postNotificationName:LAIVoiceAssistantChatNotify object:assistantModel];
            
        } chatTtsCallback:^(LWAIGCTTSSTATUS ttsStatus, NSString * _Nullable tts, NSTimeInterval timeInterval) {
            
            // 文本回复回调
            LAssistantModel *assistantModel = [LAssistantModel new];
            assistantModel.assistantType = LAssistantType_AssistantText;
            assistantModel.param = tts;
            assistantModel.isAdd = ttsStatus == LWAIGCTTSSTATUS_START;
            [[NSNotificationCenter defaultCenter] postNotificationName:LAIVoiceAssistantChatNotify object:assistantModel];
            
            if (ttsStatus == LWAIGCTTSSTATUS_STOP) {
                [[LAIGC sharedManager].audioPlayer stopPlayback];
            }
            
        } chatAudioCallback:^(NSData * _Nonnull audioData) {
            
            // 音频回复回调
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
            
        } chatMcpCmdCallback:^(LWAIGCMcpModel * _Nonnull mcpModel, NSTimeInterval timeInterval) {
            
            // mcp命令回调
            [LAIGC sharedManager].mcpModel = mcpModel;
            
            if (mcpModel.cmd == LWAIGCMCPCMD_AI_IMAGE_RECOGNIYION) { // 需要拍照
                            
                // 成功拍照后图片会通过委托代理LDelegate返回 详@link notifyAIRecognizePhotoData:
                [LGlassesKit startTakingPhotos:LPhotoType_PhotoRecognition callback:^(NSError * _Nullable error) {
                    NSLog(@"拍照结果: %@", error);
                }];
            }
            
        } chatStopCallback:^{
            
            // 停止回调
            // 中断语音传输
            [LGlassesKit abortVoiceTransmissionWithCallback:^(NSError * _Nullable error) {
                NSLog(@"中断语音: %@", error);
            }];
        }];
        
        
        /// 注册智能体翻译回调
        [LWAIGCKit registerTranslationTextCallback:^(LWAIGCTranslateTextModel * _Nonnull translateTextModel) {
            
            [[NSNotificationCenter defaultCenter] postNotificationName:LAIVoiceAssistantTranslationNotify object:translateTextModel];
            
        } translationAudioCallback:^(NSData * _Nonnull audioData) {
            
            // 音频回复回调
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
            
        } translationTtsCallback:^(LWAIGCTTSSTATUS ttsStatus, NSString * _Nullable tts, NSTimeInterval timeInterval) {
            
            if (ttsStatus == LWAIGCTTSSTATUS_STOP) {
                [[LAIGC sharedManager].audioPlayer stopPlayback];
            }
        }];
    }
    return self;
}

/// 注册AIGC
+ (void)registerAIGC
{
    RLMDeviceModel *deviceModel = RLMDeviceModel.allObjects.lastObject;
#warning - 请联系服务商提供
    LWAIGCModel *aigcModel = [LWAIGCModel new];
    aigcModel.clientId = @"请联系服务商提供";
    aigcModel.clientSk = @"请联系服务商提供";
    aigcModel.deviceId = deviceModel.deviceMac;
    aigcModel.deviceName = deviceModel.deviceName;
    aigcModel.deviceModel = deviceModel.deviceMode;
    aigcModel.sdkType = SDKTYPE_LY; // 具体连接设备的方案商
    aigcModel.serverNode = DEV_DOMAIN; // demo使用了开发环境
    // 初始化AI
    [LWAIGCKit initAIGCWithModel:aigcModel];
    
    [LAIGC sharedManager];
}

/// 连接智能体
+ (void)connectAgentWebSocket
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
#warning - 实际请根据需要的语言设置
    // 支持的语言查阅本地 language.json 文件
    [LWAIGCKit startChatSpeechRecognition:STT_AUTO language:140]; // demo这里固定使用了 中文（普通话，简体）
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
        [[NSNotificationCenter defaultCenter] postNotificationName:LAIVoiceAssistantChatNotify object:assistantModel];
        
        // 识图
        [LWAIGCKit requestChatUploadImageData:data question:[LAIGC sharedManager].mcpModel.question callback:^(NSString * _Nullable result, NSError * _Nullable error) {
            if (error) {
                [LHUD showText:error.localizedDescription];
            }
            else {
                // 识别成功
                LAssistantModel *assistantModel_1 = [LAssistantModel new];
                assistantModel_1.assistantType = LAssistantType_UserText;
                assistantModel_1.param = [NSString stringWithFormat:@"图片识别内容: %@", result];
                assistantModel_1.isAdd = YES;
                [[NSNotificationCenter defaultCenter] postNotificationName:LAIVoiceAssistantChatNotify object:assistantModel_1];
                
                // 发送识图结果
                [LWAIGCKit sendChatImageRecognitionResults:result task_id:[LAIGC sharedManager].mcpModel.task_id];
            }
        }];
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

/// 结束翻译
+ (void)endTranslation
{
    [LWAIGCKit stopTranslateSpeechRecognition];
}

@end
