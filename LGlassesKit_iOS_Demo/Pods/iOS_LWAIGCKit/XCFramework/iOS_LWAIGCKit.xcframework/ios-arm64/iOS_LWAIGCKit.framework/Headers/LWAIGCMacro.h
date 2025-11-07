//
//  LWAIGCMacro.h
//  FissionBluetooth
//
//  Created by LINWEAR on 2025-03-03.
//

#ifndef LWAIGCMacro_h
#define LWAIGCMacro_h

/// 模型类型
typedef NS_ENUM(NSInteger, LWAIGCMODETYPE) {
    DEEPSEEK_V3 = 1,    //DeepSeek v3
    DEEPSEEK_R1 = 2,    //DeepSeek r1
    TOOGYI_257B = 3,    //通义千问2.5-7B
    ERNIE_BOT   = 4,    //文心一言
} NS_SWIFT_NAME(LWAIGCMODETYPE);


/// 服务器节点类型
typedef NS_ENUM(NSInteger, LWAIGCSERVERNODETYPE) {
    DEV_DOMAIN,         //开发（内部调试）
    TEST_DOMAIN,        //测试（内部调试）
    CHINA_DOMAIN,       //中国正式
    GERMANY_DOMAIN,     //德国正式
    SINGAPORE_DOMAIN,   //新加坡正式
} NS_SWIFT_NAME(LWAIGCSERVERNODETYPE);


/// 会议纪要任务状态
typedef NS_ENUM(NSInteger, LWAIGCMTGTASKSTATUS) {
    TASK_PENDING    = 0,    //任务待处理
    TASK_PROCESSING = 1,    //任务处理中
    TASK_SUCCESSFUL = 2,    //任务处理成功
    TASK_CONFIRMED  = 3,    //任务用户已确认
    TASK_FAILED     = 4     //任务失败
} NS_SWIFT_NAME(LWAIGCMTGTASKSTATUS);


/// Web Socket连接状态
typedef NS_ENUM(NSInteger, LWAIGCWEBSOCKETSTATUS) {
    WEBSOCKET_CONNECTING    = 0,    //连接中
    WEBSOCKET_CONNECTED     = 1,    //已连接
    WEBSOCKET_DISCONNECTING = 2,    //断开中
    WEBSOCKET_DISCONNECTED  = 3,    //已断开
} NS_SWIFT_NAME(LWAIGCWEBSOCKETSTATUS);


/// 语音转文本类型
typedef NS_ENUM(NSInteger, LWAIGCSTTMODE) {
    STT_AUTO        = 0,    //自动停止（服务器VAD）自动判断是否停止
    STT_MANUAL      = 1,    //手动停止，客户端发送stop指令，服务端才会停止
    STT_SEMI_AUTO   = 2,    //半自动，服务器VAD识别到说话停止后，向客户端发送stop指令
} NS_SWIFT_NAME(LWAIGCSTTMODE);


/// 文本转语音TTS状态
typedef NS_ENUM(NSInteger, LWAIGCTTSSTATUS) {
    LWAIGCTTSSTATUS_START,          //TTS开始
    LWAIGCTTSSTATUS_SENTENCE_START, //句子开始（播放）
    LWAIGCTTSSTATUS_SENTENCE_END,   //句子停止
    LWAIGCTTSSTATUS_STOP,           //TTS停止
} NS_SWIFT_NAME(LWAIGCTTSSTATUS);


/// MCP命令
typedef NS_ENUM(NSInteger, LWAIGCMCPCMD) {
    LWAIGCMCPCMD_AI_IMAGE_RECOGNIYION,  // AI识图
    // 更多待拓展...
} NS_SWIFT_NAME(LWAIGCMCPCMD);


#endif /* LWAIGCMacro_h */
