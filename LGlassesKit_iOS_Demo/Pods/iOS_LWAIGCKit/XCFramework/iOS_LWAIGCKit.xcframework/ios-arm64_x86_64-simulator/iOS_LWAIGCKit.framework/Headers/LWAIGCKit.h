//
//  LWAIGCKit.h
//  FissionBluetooth
//
//  Created by LINWEAR on 2025-02-22.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol LWAIGCKitDelegete <NSObject>

@optional
/// 日志文本输出
- (void)logDidOutputtingWithText:(NSString *)text;

/// AI语音智能体(WebSocket连接状态)
- (void)aiVoiceAgentWebSocketConnectionStatus:(LWAIGCWEBSOCKETSTATUS)status;

@end

@interface LWAIGCKit : NSObject

/**
 注册委托代理
 */
+ (void)registerDelegete:(id<LWAIGCKitDelegete>)delegete;

/**
 初始化（每次切换设备都需要重新调用）
 */
+ (void)initAIGCWithModel:(LWAIGCModel * _Nonnull)model;

/**
 语音转文字
 */
+ (void)requestAudioToTextWithModel:(LWAIGCAudioModel * _Nonnull)audioModel
                       withCallback:(LWAIGCTextCallback _Nonnull)callback;

/**
 文本聊天
 */
+ (void)requestChatToTextWithModel:(LWAIGCChatModel * _Nonnull)chatModel
                      withCallback:(LWAIGCTextCallback _Nonnull)callback;

/**
 会议纪要(创建任务)
 */
+ (void)requestCreateMeetingWithModel:(LWAIGCMTGAudioModel * _Nonnull)audioModel
                         withCallback:(LWAIGCMTGCrCallback _Nonnull)callback;

/**
 会议纪要(查询状态)
 */
+ (void)requestMeetingStatusWithModel:(LWAIGCMTGQryStatusModel * _Nonnull)queryStatusModel
                         withCallback:(LWAIGCMTGQryItemCallback _Nonnull)callback;

/**
 会议纪要(查询列表)
 */
+ (void)requestQueryMeetingListWithModel:(LWAIGCQueryListModel * _Nonnull)queryListModel
                            withCallback:(LWAIGCMTGQryCallback _Nonnull)callback;

/**
 会议纪要(相关文件解压转为模型)
 @param zipPath     压缩包文件路径
 @param targetPath  解压到指定路径
 */
+ (void)requestDecompressWithMeetingZipPath:(NSString * _Nonnull)zipPath
                               toTargetPath:(NSString * _Nonnull)targetPath
                               withCallback:(void(^)(LWAIGCMTGDetailsModel * _Nullable detailsModel, NSError * _Nullable error))callback;

/**
 会议纪要(实时监听任务状态，连接WebSocket)
 @param resultCallback  连接结果回调
 @param callback        任务状态回调
 */
+ (void)requestConnectMeetingWebSocket:(NSString * _Nonnull)webSocket
                        resultCallback:(void (^)(NSError * _Nullable error))resultCallback
                          withCallback:(LWAIGCMTGQryItemCallback _Nonnull)callback;

/**
 会议纪要(实时监听任务状态，断开WebSocket)
 */
+ (void)disconnectMeetingWebSocket;

/**
 会议纪要(实时监听任务状态，WebSocket连接状态)
 */
+ (LWAIGCWEBSOCKETSTATUS)meetingWebSocketState;

/**
 取消请求
 @param convId      请求唯一会话ID
 */
+ (void)cancelHttpRequestWithConvId:(NSString * _Nonnull)convId;



/**
 AI语音智能体(配置音频参数，连接WebSocket)
 @param audioInfo           此音频参数参数为智能体对话输入的音频格式信息
 @param resultCallback      连接结果回调，error参部分错误码 LWAIGCERRORCODE
 */
+ (void)requestConnectAiVoiceAgentWebSocket:(LWAIGCAudioInfoModel * _Nonnull)audioInfo resultCallback:(void (^)(NSError * _Nullable error))resultCallback;

/**
 AI语音智能体(断开WebSocket)
 */
+ (void)disconnectAiVoiceAgentWebSocket;

/**
 AI语音智能体(WebSocket连接状态)
 */
+ (LWAIGCWEBSOCKETSTATUS)aiVoiceAgentWebSocketState;


/**
 注册智能体对话回调
 @param chatSttCallback     语音转文本回调
 @param chatTtsCallback     文本回复回调
 @param chatAudioCallback   音频回复回调
 @param chatMcpCmdCallback  mcp命令回调
 @param chatStopCallback    停止回调
 */
+ (void)registerChatSttCallback:(LWAIGCSttCallback)chatSttCallback
                chatTtsCallback:(LWAIGCTtsCallback)chatTtsCallback
              chatAudioCallback:(LWAIGCAudioCallback)chatAudioCallback
             chatMcpCmdCallback:(LWAIGCMcpCmdCallback)chatMcpCmdCallback
               chatStopCallback:(LWAIGCStopCallback)chatStopCallback;

/**
 AI语音智能体(开始对话语音识别)
 @param mode     stt类型
 @param llmType  LLM模型类型
 @param language 语言类型
 */
+ (void)startChatSpeechRecognition:(LWAIGCSTTMODE)mode llmType:(LWLLMMODELTYPE)llmType language:(NSInteger)language;

/**
 AI语音智能体(发送对话语音数据)
 */
+ (void)sendChatVoiceData:(NSData *)data;

/**
 AI语音智能体(停止对话语音识别，手动模式必须调用)
 */
+ (void)stopChatSpeechRecognition;

/**
 AI语音智能体(中止对话响应)
 */
+ (void)abortResponse;

/**
 AI语音智能体（发送识别图片）
 @param data        图片数据
 @param question    问题描述
 @param task_id     mcp命令中的任务ID
 */
+ (void)sendRecognitionImageData:(NSData * _Nonnull)data question:(NSString * _Nonnull)question task_id:(NSString * _Nonnull)task_id;


/**
 注册智能体翻译回调
 @param translationTextCallback     语音转文本翻译回调
 @param translationAudioCallback    音频翻译回调
 */
+ (void)registerTranslationTextCallback:(LWAIGCTranslateTextCallback)translationTextCallback
               translationAudioCallback:(LWAIGCAudioCallback)translationAudioCallback;
/**
 AI语音智能体（设置翻译语种及音频信息）
 @param translateModel  翻译语种及音频信息
 */
+ (void)setTranslationInfo:(LWAIGCTranslateModel * _Nonnull)translateModel;

/**
 AI语音智能体（开始翻译语音识别）
 @param requestId   请求唯一ID
 */
+ (void)startTranslateSpeechRecognition:(NSString * _Nonnull)requestId;

/**
 AI语音智能体（发送翻译语音数据）
 */
+ (void)sendTranslateVoiceData:(NSData *)data;

/**
 AI语音智能体（停止翻译语音识别）
 */
+ (void)stopTranslateSpeechRecognition;


/**
 注册智能体同声传译回调
 @param simultaneousInterpretationTextCallback     语音转文本同声传译回调
 @param simultaneousInterpretationAudioCallback    音频同声传译回调
 */
+ (void)registerSimultaneousInterpretationTextCallback:(LWAIGCTranslateTextCallback)simultaneousInterpretationTextCallback
               simultaneousInterpretationAudioCallback:(LWAIGCAudioCallback)simultaneousInterpretationAudioCallback;

/**
 AI语音智能体（开始同声传译语音识别）
 @param requestId   请求唯一ID
 */
+ (void)startSimultaneousInterpretationSpeechRecognition:(NSString *)requestId;

/**
 AI语音智能体（发送同声传译语音数据）
 */
+ (void)sendSimultaneousInterpretationVoiceData:(NSData *)data;

/**
 AI语音智能体（停止同声传译语音识别）
 @param end   YES结束，剩余tts、音频不再返回；NO暂停，剩余tts、音频继续返回
 */
+ (void)stopSimultaneousInterpretationSpeechRecognition:(BOOL)end;



/**
 AI语音智能体（创建房间）
 @param queryRoomModel  房间创建参数
 @param callback        房间信息回调
 */
+ (void)requestCreateRoomWithModel:(LWAIGCQueryRoomModel * _Nonnull)queryRoomModel
                      withCallback:(LWAIGCRoomQryCallback)callback;

/**
 注册智能体通话翻译回调
 @param callTranslationTextCallback     语音转文本通话翻译回调
 */
+ (void)registerCallTranslationTextCallback:(LWAIGCTranslateTextCallback)callTranslationTextCallback;

/**
 开始通话翻译语音识别
 */
+ (void)startCallTranslationSpeechRecognition:(NSString *)requestId;

/**
 AI语音智能体（发送通话翻译语音数据）
 */
+ (void)sendCallTranslationVoiceData:(NSData *)data;

 /**
  停止通话翻译语音识别
  */
+ (void)stopCallTranslationSpeechRecognition;


/**
 获取图片翻译支持的语言列表
 */
+ (void)getImageTranslationLangListWithCallback:(LWAIGCLangListCallback)callback;

/**
 图片翻译
 @param data            图片数据
 @param fromLanguage    源语种
 @param toLanguage      目标语种
 */
+ (void)startTranslationWithImageData:(NSData *)data
                         fromLanguage:(NSInteger)fromLanguage
                           toLanguage:(NSInteger)toLanguage
                             callback:(LWAIGCImageRecognitionCallback)callback;

@end

NS_ASSUME_NONNULL_END
