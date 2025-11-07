//
//  LWAIGCKit.h
//  FissionBluetooth
//
//  Created by LINWEAR on 2025-02-22.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LWAIGCKit : NSObject

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
 */
+ (void)requestConnectMeetingWebSocket:(NSString * _Nonnull)webSocket
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
 AI语音智能体(配置音频参数，实时监听服务状态，连接WebSocket)
 */
+ (void)requestConnectAiVoiceAgentWebSocket:(LWAIGCAudioInfoModel *)audioInfo sttCallback:(LWAIGCSttCallback)sttCallback ttsCallback:(LWAIGCTtsCallback)ttsCallback audioCallback:(LWAIGCAudioCallback)audioCallback mcpCmdCallback:(LWAIGCMcpCmdCallback)mcpCmdCallback stopCallback:(LWAIGCStopCallback)stopCallback;

/**
 AI语音智能体(实时监听服务状态，断开WebSocket)
 */
+ (void)disconnectAiVoiceAgentWebSocket;

/**
 AI语音智能体(实时监听服务状态，WebSocket连接状态)
 */
+ (LWAIGCWEBSOCKETSTATUS)aiVoiceAgentWebSocketState;

/**
 AI语音智能体(开始语音识别)
 */
+ (void)startSpeechRecognition:(LWAIGCSTTMODE)mode lang:(NSString *)lang;

/**
 AI语音智能体(发送识别的语音数据)
 */
+ (void)sendRecognizedVoiceData:(NSData *)data;

/**
 AI语音智能体(停止语音识别，手动模式必须调用)
 */
+ (void)stopSpeechRecognition;

/**
 AI语音智能体(停止响应)
 */
+ (void)stopResponding;

/**
 AI语音智能体（上传图片开始识图，问题描述）
 */
+ (void)requestUploadImageData:(NSData * _Nonnull)data
                      question:(NSString * _Nonnull)question
                      callback:(LWAIGCImageRecognitionCallback)callback;

/**
 AI语音智能体（发送识图的结果）
 */
+ (void)sendImageRecognitionResults:(NSString * _Nonnull)results task_id:(NSString * _Nonnull)task_id;

/**
 取消请求
 @param convId      请求唯一会话ID
 */
+ (void)cancelHttpRequestWithConvId:(NSString * _Nonnull)convId;

@end

NS_ASSUME_NONNULL_END
