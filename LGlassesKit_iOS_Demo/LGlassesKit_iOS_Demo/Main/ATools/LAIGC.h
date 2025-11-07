//
//  LAIGC.h
//  LGlassesKit_iOS_Demo
//
//  Created by LINWEAR on 2025-10-27.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/// 通知
#define LAIVoiceAssistantNotify     @"LAIVoiceAssistantNotify"

@interface LAIGC : NSObject

/// 注册AIGC
+ (void)registerAIGC;

/// 连接智能体
+ (void)connectAgentWebSocket;

/// 断开智能体
+ (void)disconnectAgentWebSocket;

/// 开始录音
+ (void)startRecording;

/// 发送音频数据
+ (void)sendAudioData:(NSData *)data;

/// 上传图片开始识图
+ (void)requestUploadImageData:(NSData *)data;

@end

NS_ASSUME_NONNULL_END
