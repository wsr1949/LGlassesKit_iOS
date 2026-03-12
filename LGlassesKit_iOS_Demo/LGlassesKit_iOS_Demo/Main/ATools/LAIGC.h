//
//  LAIGC.h
//  LGlassesKit_iOS_Demo
//
//  Created by LINWEAR on 2025-10-27.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/// AI智能体连接成功
#define LAIGCConnectionSuccessfulNotify         @"LAIGCConnectionSuccessfulNotify"
/// 对话通知
#define LAIGCChatNotify                         @"LAIGCChatNotify"
/// 日程通知
#define LAIGCCScheduleNotify                    @"LAIGCCScheduleNotify"
/// 翻译通知
#define LAIGCTranslateNotify                    @"LAIGCTranslateNotify"
/// 同声传译通知
#define LAIGCSimultaneousInterpretationNotify   @"LAIGCSimultaneousInterpretationNotify"
/// 通话翻译通知
#define LAIGCCallTranslationNotify              @"LAIGCCallTranslationNotify"


@interface LAIGC : NSObject

/// 单例
+ (LAIGC *)sharedManager;

/// 是否允许使用语音助手，默认YES
@property (nonatomic, assign) BOOL allowUseVoiceAssistant;
/// 当前语音助手是否使用中
@property (nonatomic, assign) BOOL usingVoiceAssistant;


/// 注册AIGC
+ (void)registerAIGC;

/// 连接智能体
+ (void)connectAgentWebSocket:(void (^)(NSError *error))callback;

/// 智能体连接状态
+ (LWAIGCWEBSOCKETSTATUS)agentState;

/// 断开智能体
+ (void)disconnectAgentWebSocket;


/// 开始录音
+ (void)startRecording;

/// 发送语音助手音频数据
+ (void)sendChatAudioData:(NSData *)data;

/// 上传图片开始识图
+ (void)requestUploadImageData:(NSData *)data;


/// 开始翻译
+ (void)startTranslationFromLanguage:(NSInteger)fromLanguage toLanguage:(NSInteger)toLanguage;

/// 发送翻译音频数据
+ (void)sendTranslationAudioData:(NSData *)data;

/// 结束翻译
+ (void)endTranslation;


/// 开始同声传译
+ (void)startSimultaneousInterpretationFromLanguage:(NSInteger)fromLanguage toLanguage:(NSInteger)toLanguage;

/// 发送同声传译音频数据
+ (void)sendSimultaneousInterpretationAudioData:(NSData *)data;

/// 结束同声传译
+ (void)endSimultaneousInterpretation;


/// 开始通话翻译
+ (void)startCallTranslationFromLanguage:(NSInteger)fromLanguage toLanguage:(NSInteger)toLanguage;

/// 发送通话翻译音频数据
+ (void)sendCallTranslationAudioData:(NSData *)data;

/// 结束通话翻译
+ (void)endCallTranslation;


/// 图片翻译
+ (void)startImageTranslationWithImageData:(NSData *)data fromLanguage:(NSInteger)fromLanguage toLanguage:(NSInteger)toLanguage callback:(void (^)(NSString *base64, NSError *error))callback;

@end

NS_ASSUME_NONNULL_END
