//
//  iOS_LWAIGCKit.h
//  iOS_LWAIGCKit
//
//  Created by LINWEAR on 2025-03-03.
//

#import <Foundation/Foundation.h>

//! Project version number for iOS_LWAIGCKit.
FOUNDATION_EXPORT double iOS_LWAIGCKitVersionNumber;

//! Project version string for iOS_LWAIGCKit.
FOUNDATION_EXPORT const unsigned char iOS_LWAIGCKitVersionString[];

/**
 框架名称: iOS_LWAIGCKit.xcframework
 框架功能: AI智能框架，负责AI智能请求交互等功能的封装。
 
 GitHub @link https://github.com/wsr1949/iOS_LWAIGCKit.git
 
 版本记录：

 project    2026-05-27  Version:1.0.6   Build:2026052701
            1.对话回调STT回调新增message_id和识别状态LWAIGCSTTSTATUS，服务升级为流式句式回调，客户端需要处理流式文本 参@link registerChatSttCallback:chatTtsCallback:chatAudioCallback:chatMcpCmdCallback:chatStopCallback:
 
 project    2026-05-20  Version:1.0.5   Build:2026052001
            1.新增AI识图合并方法 参@link sendRecognitionImageData:question:task_id:
            2.对话回调TTS回调新增message_id，服务升级为流式回调，客户端需要处理流式文本 参@link registerChatSttCallback:chatTtsCallback:chatAudioCallback:chatMcpCmdCallback:chatStopCallback:
 
 project    2026-03-11  Version:1.0.4   Build:2026031101
            1.语音助手（Chat）增加LLM模型控制 参@link startChatSpeechRecognition:llmType:language:
            2.语音助手（Chat）支持日程MCP命令 参@link LWAIGCMcpCmdCallback回调 LWAIGCScheduleModel模型
 
 project    2026-01-26  Version:1.0.3   Build:2026012601
            1.新增 图片翻译
 
 project    2026-01-07  Version:1.0.2   Build:2026010701
            1.移除音频发送公共API sendRecognizedVoiceData:，新增不同业务的音频发送API，如下:
                语音助手（Chat） sendChatVoiceData:
                对话翻译        sendTranslateVoiceData:
                同声传译        sendSimultaneousInterpretationVoiceData:
                音视频翻译       sendCallTranslationVoiceData:
 
            2.移除翻译相关tts状态回调，修改音频回调 新增回调参数 参@link LWAIGCAudioStream 类
            3.新增业务错误码 500004、500005 参@link 枚举LWAIGCERRORCODE
 
 project    2026-01-05  Version:1.0.1   Build:2026010501
            1.增加 语音助手（Chat）
            2.增加 对话翻译
            3.增加 同声传译
            4.增加 音视频翻译（使用ZEGO即构 https://console.zego.im ）
 
 project    2025-03-03  Version:1.0.0   Build:2025030301
            1.首版
 */


// In this header, you should import all the public headers of your framework using statements like #import <iOS_LWAIGCKit/PublicHeader.h>
#import <iOS_LWAIGCKit/LWAIGCMacro.h>
#import <iOS_LWAIGCKit/LWAIGCTextModel.h>
#import <iOS_LWAIGCKit/LWAIGCImageModel.h>
#import <iOS_LWAIGCKit/LWAIGCMTGCrModel.h>
#import <iOS_LWAIGCKit/LWAIGCMTGQryModel.h>
#import <iOS_LWAIGCKit/LWAIGCMTGSttModel.h>
#import <iOS_LWAIGCKit/LWAIGCMTGSaModel.h>
#import <iOS_LWAIGCKit/LWAIGCMTGKpModel.h>
#import <iOS_LWAIGCKit/LWAIGCMTGTocModel.h>
#import <iOS_LWAIGCKit/LWAIGCMTGDetailsModel.h>
#import <iOS_LWAIGCKit/LWAIGCMTGQryStatusModel.h>
#import <iOS_LWAIGCKit/LWAIGCAudioInfoModel.h>
#import <iOS_LWAIGCKit/LWAIGCScheduleModel.h>
#import <iOS_LWAIGCKit/LWAIGCMcpModel.h>
#import <iOS_LWAIGCKit/LWAIGCTranslateModel.h>
#import <iOS_LWAIGCKit/LWAIGCTranslateTextModel.h>
#import <iOS_LWAIGCKit/LWAIGCQueryRoomModel.h>
#import <iOS_LWAIGCKit/LWAIGCRoomQryModel.h>
#import <iOS_LWAIGCKit/LWAIGCAudioStream.h>
#import <iOS_LWAIGCKit/LWAIGCLangListModel.h>

#import <iOS_LWAIGCKit/LWAIGCQueryListModel.h>
#import <iOS_LWAIGCKit/LWAIGCCallback.h>
#import <iOS_LWAIGCKit/LWAIGCModel.h>
#import <iOS_LWAIGCKit/LWAIGCAudioModel.h>
#import <iOS_LWAIGCKit/LWAIGCMTGAudioModel.h>
#import <iOS_LWAIGCKit/LWAIGCChatModel.h>
#import <iOS_LWAIGCKit/LWAIGCKit.h>
