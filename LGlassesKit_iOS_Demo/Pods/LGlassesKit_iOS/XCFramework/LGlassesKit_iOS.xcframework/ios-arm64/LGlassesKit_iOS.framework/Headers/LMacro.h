//
//  LMacro.h
//  LGlassesKit_iOS
//
//  Created by LINWEAR on 2025-09-19.
//

#ifndef LMacro_h
#define LMacro_h

/// 部分定义的错误码
typedef NS_ENUM(NSInteger, LErrorCode)
{
    /// 蓝牙未激活
    LErrorCodeNotActivated      = 10001,
    /// 蓝牙未连接
    LErrorCodeBleNotConnected   = 10002,
    /// 蓝牙连接超时
    LErrorCodeConnectTimeout    = 10003,
    /// 命令响应超时
    LErrorCodeCmdRespTimeout    = 10004,
    /// Wi-Fi响应超时
    LErrorCodeWiFiRespTimeout   = 10005,
    /// Wi-Fi未连接
    LErrorCodeWiFiNotConnected  = 10006,
    /// AI图片传输失败
    LErrorCodeAiImageFailed     = 10007,
    /// OTA认证失败
    LErrorCodeOTAAuthenFailed   = 10008,
    /// 文件数据错误
    LErrorCodeFileDataError     = 10009,
    
} NS_SWIFT_NAME(LErrorCode);


/// BLE连接状态
typedef NS_ENUM(NSInteger, LBleStatus)
{
    /// 连接断开
    LBleStatusDisconnect        = 0,
    /// 连接中
    LBleStatusConnecting        = 1,
    /// 已连接
    LBleStatusConnected         = 2,
    /// 连接失败
    LBleStatusConnectionFailed  = 3,
    
} NS_SWIFT_NAME(LBleStatus);


/// Wi-Fi热点连接状态
typedef NS_ENUM(NSInteger, LWiFiHotspotStatus)
{
    /// 连接断开/连接失败
    LWiFiHotspotStatusDisconnect        = 0,
    /// 连接中
    LWiFiHotspotStatusConnecting        = 1,
    /// 已连接
    LWiFiHotspotStatusConnected         = 2,
    /// 连接失败
    LWiFiHotspotStatusConnectionFailed  = 3,
    
} NS_SWIFT_NAME(LWiFiHotspotStatus);


/// LED亮度
typedef NS_ENUM(NSInteger, LLedBrightness)
{
    /// 亮度低
    LLedBrightnessLow       = 0,
    /// 亮度中
    LLedBrightnessMedium    = 1,
    /// 亮度高
    LLedBrightnessHigh      = 2,
    
} NS_SWIFT_NAME(LLedBrightness);


/// 快捷手势动作
typedef NS_ENUM(NSInteger, LGestureActions)
{
    /// 向前滑动
    LGestureActionSwipeForward      = 0,
    /// 向后滑动
    LGestureActionSwipeBackward     = 1,
    /// 单击
    LGestureActionSingleClick       = 2,
    /// 双击
    LGestureActionDoubleClick       = 3,
    /// 三击
    LGestureActionTripleClick       = 4,
    
} NS_SWIFT_NAME(LGestureActions);


/// 快捷手势事件
typedef NS_ENUM(NSInteger, LGestureEvents)
{
    /// 调小音量
    LGestureEventVolumeDown     = 0,
    /// 调大音量
    LGestureEventVolumeUp       = 1,
    /// 暂停/播放
    LGestureEventPausePlay      = 2,
    /// 上一曲
    LGestureEventPreviousSong   = 3,
    /// 下一曲
    LGestureEventNextSong       = 4,
    /// 挂断
    LGestureEventEndCall        = 5,
    
} NS_SWIFT_NAME(LGestureEvents);


/// 拍照类型
typedef NS_ENUM(NSInteger, LPhotoType)
{
    /// 只拍照
    LPhotoType_OnlyTakePhotos   = 0,
    /// 拍照并传高清图(用于ai识图)
    LPhotoType_PhotoRecognition = 1,
    
} NS_SWIFT_NAME(LPhotoType);


/// 拍照模式
typedef NS_ENUM(NSInteger, LPhotoMode)
{
    /// 标准
    LPhotoMode_Standard = 0,
    /// 经典
    LPhotoMode_Classic  = 1,
    
} NS_SWIFT_NAME(LPhotoMode);


/// 拍摄方向
typedef NS_ENUM(NSInteger, LShootingDirection)
{
    /// 竖向
    LShootingDirection_Vertical     = 0,
    /// 横向
    LShootingDirection_Horizontal   = 1,
    
} NS_SWIFT_NAME(LShootingDirection);


#endif /* LMacro_h */
