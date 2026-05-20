<p align="left">

<a href="https://github.com/wsr1949/iOS_LWAIGCKit.git">
    <img src="https://img.shields.io/badge/Release-1.0.5 -Green.svg">
</a>
<a href="https://github.com/wsr1949/iOS_LWAIGCKit.git">
    <img src="https://img.shields.io/badge/Support-iOS14.0+ -blue.svg">
</a>
<a href="https://github.com/wsr1949/iOS_LWAIGCKit.git">
    <img src="https://img.shields.io/badge/Support-CocoaPods -aquamarine.svg">
</a>
<a href="https://github.com/wsr1949/iOS_LWAIGCKit.git">
    <img src="https://img.shields.io/badge/Language-Objective_C -red.svg">
</a>
<a href="https://github.com/wsr1949/iOS_LWAIGCKit.git">
    <img src="https://img.shields.io/badge/License-MIT -gold.svg">
</a>

</p>


# iOS_LWAIGCKit

#### AI智能框架，负责AI智能请求交互等功能的封装。

## 兼容性（XCFramework）

#### 支持`iOS 14.0 及以上操作系统`

- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -


## 安装（CocoaPods）

##### 在 `Podfile` 中添加
```ruby
pod 'iOS_LWAIGCKit', git: 'https://github.com/wsr1949/iOS_LWAIGCKit.git'
```

##### 终端执行 
```ruby
pod install
```

## 导入使用

##### 导入头文件
```ruby
#import <iOS_LWAIGCKit/iOS_LWAIGCKit.h>
```

##### 支持的语种 阅 `language.json` 附件，接口中语言参数均使用文件中的 `langType` 字段


## 初始化、连接

##### 初始化（每次切换设备都需要重新调用）
```ruby
/**
 初始化（每次切换设备都需要重新调用）
 */
+ (void)initAIGCWithModel:(LWAIGCModel * _Nonnull)model;
```

##### AI语音智能体(配置音频参数，连接WebSocket)
```ruby
/**
 AI语音智能体(配置音频参数，连接WebSocket)
 @param audioInfo           此音频参数参数为智能体对话输入的音频格式信息
 @param resultCallback      连接结果回调，error参部分错误码 LWAIGCERRORCODE
 */
+ (void)requestConnectAiVoiceAgentWebSocket:(LWAIGCAudioInfoModel * _Nonnull)audioInfo resultCallback:(void (^)(NSError * _Nullable error))resultCallback;
```
##### 连接业务错误码
 ```ruby
/// 错误码
typedef NS_ENUM(NSInteger, LWAIGCERRORCODE) {
    ERRORCODE_SAME      = 500001,   // 用户同一设备重复连接服务器
    ERRORCODE_AUTH      = 500002,   // 当前设备未进行授权
    ERRORCODE_SECRETKEY = 500003,   // 服务器密钥错误（请找商务经理进行申请）
    ERRORCODE_STOCK     = 500004,   // 当前设备未入库
    ERRORCODE_APPID     = 500005,   // APPID错误
} NS_SWIFT_NAME(LWAIGCERRORCODE);
```

##### AI语音智能体(断开WebSocket)
```ruby
/**
 AI语音智能体(断开WebSocket)
 */
+ (void)disconnectAiVoiceAgentWebSocket;
```

##### AI语音智能体(WebSocket连接状态)
```ruby
/**
 AI语音智能体(WebSocket连接状态)
 */
+ (LWAIGCWEBSOCKETSTATUS)aiVoiceAgentWebSocketState;
```


## 语音助手（Chat）

##### 注册智能体对话回调
```ruby
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
```

##### 开始对话语音识别
```ruby
/**
 AI语音智能体(开始对话语音识别)
 @param mode     stt类型
 @param llmType  LLM模型类型
 @param language 语言类型
 */
+ (void)startChatSpeechRecognition:(LWAIGCSTTMODE)mode llmType:(LWLLMMODELTYPE)llmType language:(NSInteger)language;
```

##### 发送对话语音数据
```ruby
/**
 AI语音智能体(发送对话语音数据)
 */
+ (void)sendChatVoiceData:(NSData *)data;
```

##### 停止对话语音识别，手动模式必须调用
```ruby
/**
 AI语音智能体(停止对话语音识别，手动模式必须调用)
 */
+ (void)stopChatSpeechRecognition;
```

##### 中止对话响应
```ruby
/**
 AI语音智能体(中止对话响应)
 @param sessionId    会话ID
 */
+ (void)abortResponseWithSessionId:(NSString * _Nonnull)sessionId;
```

##### AI语音智能体（发送识别图片）
```ruby
/**
 AI语音智能体（发送识别图片）
 @param data        图片数据
 @param question    问题描述
 @param task_id     mcp命令中的任务ID
 */
+ (void)sendRecognitionImageData:(NSData * _Nonnull)data question:(NSString * _Nonnull)question task_id:(NSString * _Nonnull)task_id;
```


## 对话翻译

##### 翻译结果均为流式返回，数据结构如下，其中 `action` 为 `recognizing` 表示识别中，`action` 为 `recognized` 表示句子识别完成；同一个句子 `messageId` 相同；`text` 为语音识别内容，`translation_text` 为语音翻译内容
```ruby
{
    "type": "xxx",
    "session_id": "xxx",
    "direction": "xxx",
    "data": {
        "text": "今天天气怎么样？",
        "request_id": "<8位字符串>",
        "messageId":1,
        "action": "recognized",
        "trans": [{
            "translation_text": "How the weather like today?",
            "language": "en-US"
        }]
    }
}
```

##### 音频流查阅 `LWAIGCAudioStream` 类，其中 `action` 为 `start` 表示发送开始，`action` 为 `send` 表示发送中，`action` 为 `end` 表示发送结束；同一个句子 `message_id` 相同；


##### 注册智能体翻译回调
```ruby
/**
 注册智能体翻译回调
 @param translationTextCallback     语音转文本翻译回调
 @param translationAudioCallback    音频翻译回调
 */
+ (void)registerTranslationTextCallback:(LWAIGCTranslateTextCallback)translationTextCallback
               translationAudioCallback:(LWAIGCAudioCallback)translationAudioCallback;
```

##### 设置翻译语种及音频信息
```ruby
/**
 AI语音智能体（设置翻译语种及音频信息）
 @param translateModel  翻译语种及音频信息
 */
+ (void)setTranslationInfo:(LWAIGCTranslateModel * _Nonnull)translateModel;
```

##### 开始翻译语音识别
```ruby
/**
 AI语音智能体（开始翻译语音识别）
 @param requestId   请求唯一ID
 */
+ (void)startTranslateSpeechRecognition:(NSString * _Nonnull)requestId;
```

##### 发送翻译语音数据
```ruby
/**
 AI语音智能体（发送翻译语音数据）
 */
+ (void)sendTranslateVoiceData:(NSData *)data;
```

##### 停止翻译语音识别
```ruby
/**
 AI语音智能体（停止翻译语音识别）
 */
+ (void)stopTranslateSpeechRecognition;
```


## 同声传译

##### AI
```ruby
/**
 注册智能体同声传译回调
 @param simultaneousInterpretationTextCallback     语音转文本同声传译回调
 @param simultaneousInterpretationAudioCallback    音频同声传译回调
 */
+ (void)registerSimultaneousInterpretationTextCallback:(LWAIGCTranslateTextCallback)simultaneousInterpretationTextCallback
               simultaneousInterpretationAudioCallback:(LWAIGCAudioCallback)simultaneousInterpretationAudioCallback;
```

##### 设置翻译语种及音频信息
```ruby
/**
 AI语音智能体（设置翻译语种及音频信息）
 @param translateModel  翻译语种及音频信息
 */
+ (void)setTranslationInfo:(LWAIGCTranslateModel * _Nonnull)translateModel;
```

##### 开始同声传译语音识别
```ruby
/**
 AI语音智能体（开始同声传译语音识别）
 @param requestId   请求唯一ID
 */
+ (void)startSimultaneousInterpretationSpeechRecognition:(NSString *)requestId;
```

##### 发送同声传译语音数据
```ruby
/**
 AI语音智能体（发送同声传译语音数据）
 */
+ (void)sendSimultaneousInterpretationVoiceData:(NSData *)data;
```

##### 停止同声传译语音识别
```ruby
/**
 AI语音智能体（停止同声传译语音识别）
 */
+ (void)stopSimultaneousInterpretationSpeechRecognition;
```


## 音视频翻译（使用ZEGO即构 https://console.zego.im ）

##### 创建房间，获取的参数用于ZEGO登录房间
```ruby
/**
 AI语音智能体（创建房间）
 @param queryRoomModel  房间创建参数
 @param callback        房间信息回调
 */
+ (void)requestCreateRoomWithModel:(LWAIGCQueryRoomModel * _Nonnull)queryRoomModel
                      withCallback:(LWAIGCRoomQryCallback)callback;
```

##### 注册智能体通话翻译回调
```ruby
/**
 注册智能体通话翻译回调
 @param callTranslationTextCallback     语音转文本通话翻译回调
 */
+ (void)registerCallTranslationTextCallback:(LWAIGCTranslateTextCallback)callTranslationTextCallback;

在接收到自己的语音翻译结果时，需要将翻译结果通过ZEGO自定义消息发送给对方
- (void)sendCustomCommand:(NSString *)command
               toUserList:(nullable NSArray<ZegoUser *> *)toUserList
                   roomID:(NSString *)roomID
                 callback:(nullable ZegoIMSendCustomCommandCallback)callback;
```

##### 设置翻译语种及音频信息
```ruby
/**
 AI语音智能体（设置翻译语种及音频信息）
 @param translateModel  翻译语种及音频信息
 */
+ (void)setTranslationInfo:(LWAIGCTranslateModel * _Nonnull)translateModel;


在ZEGO的自定义消息回调中处理
- (void)onIMRecvCustomCommand:(NSString *)command fromUser:(ZegoUser *)fromUser roomID:(NSString *)roomID

解析command的json信息：
当 `messageType` 为 `language-change` 时，`language` 为对方选择的语言类型，需要调用setTranslationInfo:设置翻译语种及音频信息

当 `messageType` 为 `translate` 时，`translation_text` 为对方语言的翻译结果

```

##### 开始通话翻译语音识别
```ruby
/**
 开始通话翻译语音识别
 */
+ (void)startCallTranslationSpeechRecognition:(NSString *)requestId;
```

##### 发送通话翻译语音数据
```ruby
/**
 AI语音智能体（发送通话翻译语音数据）
 */
+ (void)sendCallTranslationVoiceData:(NSData *)data;

这里的语言数据使用ZEGO的音频回调
- (void)onCapturedAudioData:(const unsigned char *)data dataLength:(unsigned int)dataLength param:(ZegoAudioFrameParam *)param
```

##### 停止通话翻译语音识别
```ruby
 /**
  停止通话翻译语音识别
  */
+ (void)stopCallTranslationSpeechRecognition;
```

##### 获取图片翻译支持的语言列表
```ruby
/**
 获取图片翻译支持的语言列表
 */
+ (void)getImageTranslationLangListWithCallback:(LWAIGCLangListCallback)callback;
```

##### 图片翻译
```ruby
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
```

## 版本记录
```ruby
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
```
