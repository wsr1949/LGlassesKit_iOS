//
//  LWAIGCCallback.h
//  FissionBluetooth
//
//  Created by LINWEAR on 2025-03-19.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LWAIGCCallback : NSObject

/// 文本结果
typedef void(^LWAIGCTextCallback)(LWAIGCTextModel * _Nullable textModel);

/// 图片结果
typedef void(^LWAIGCImageCallback)(LWAIGCImageModel * _Nullable imageModel);

/// 会议纪要(任务创建)结果
typedef void(^LWAIGCMTGCrCallback)(LWAIGCMTGCrModel * _Nullable mtgCrModel);

/// 会议纪要(查询列表)结果
typedef void(^LWAIGCMTGQryCallback)(LWAIGCMTGQryModel * _Nullable mtgQryModel);

/// 会议纪要(任务状态)结果
typedef void(^LWAIGCMTGQryItemCallback)(LWAIGCMTGQryItem * _Nullable mtgQryModel);

/// AI智能语音（语音转文本回调）
typedef void(^LWAIGCSttCallback)(NSString * _Nullable stt, NSTimeInterval timeInterval);

/// AI智能语音（文本转语音回调）
typedef void(^LWAIGCTtsCallback)(LWAIGCTTSSTATUS ttsStatus, NSString * _Nullable tts, NSTimeInterval timeInterval);

/// AI智能语音（mcp命令回调）
typedef void(^LWAIGCMcpCmdCallback)(LWAIGCMcpModel *mcpModel, NSTimeInterval timeInterval);

/// AI智能语音（文本音频回调）
typedef void(^LWAIGCAudioCallback)(NSData *audioData);

/// AI智能语音（停止回调）
typedef void(^LWAIGCStopCallback)(void);

/// AI智能语音（识图结果回调）
typedef void(^LWAIGCImageRecognitionCallback)(NSString * _Nullable result, NSError * _Nullable error);

@end

NS_ASSUME_NONNULL_END
