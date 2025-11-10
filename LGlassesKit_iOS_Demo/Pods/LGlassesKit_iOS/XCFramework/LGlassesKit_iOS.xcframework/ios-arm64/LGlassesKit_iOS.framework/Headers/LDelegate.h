//
//  LDelegate.h
//  LGlassesKit_iOS
//
//  Created by LINWEAR on 2025-10-16.
//

#ifndef LDelegate_h
#define LDelegate_h

/// 委托代理
@protocol LDelegate <NSObject>

@required

/**
 中心蓝牙状态
 @param status      蓝牙状态
 */
- (void)centralBluetoothStatus:(CBManagerState)status;

/**
 BLE连接状态
 @param status      ble状态
 @param error       错误
 */
- (void)bleConnectionStatus:(LBleStatus)status error:(NSError * _Nullable)error;



@optional

/**
 SDK日志，enableLog需要设置开启
 @param logText     日志
 */
- (void)notifySdkLog:(NSString * _Nullable)logText;

/**
 每次拍照或录像成功，通知缩略图数量
 @param count       数量
 */
- (void)notifyThumbnailsCount:(NSInteger)count;

/**
 通知Wi-Fi热点名称
 @param wifiHotspotName     Wi-Fi热点名称
 */
- (void)notifyWifiHotspotName:(NSString * _Nullable)wifiHotspotName;

/**
 Wi-Fi热点连接状态
 @param status      Wi-Fi状态
 @param error       错误
 */
- (void)wifiHotspotConnectionStatus:(LWiFiHotspotStatus)status error:(NSError * _Nullable)error;

/**
 通知设备电池电量信息
 @param batteryModel        电池电量信息
 */
- (void)notifyDeviceBatteryInfo:(LBatteryModel * _Nonnull)batteryModel;

/**
 通知AI语音助手状态
 @param activated   激活状态，YES激活 NO未激活
 */
- (void)notifyAIVoiceAssistantStatus:(BOOL)activated;

/**
 通知语音数据
 @param voiceData   语音数据（opus格式）
 */
- (void)notifyVoiceData:(NSData * _Nullable)voiceData;

/**
 通知AI识图照片数据
 @param photoData   图片数据（JPG格式）
 @param error       错误
 */
- (void)notifyAIRecognizePhotoData:(NSData * _Nullable)photoData error:(NSError * _Nullable)error;

/**
 通知停止语音识别
 */
- (void)notifyStopSpeechRecognition;

/**
 通知停止语音播报
 */
- (void)notifyStopVoicePlayback;

@end

#endif /* LDelegate_h */
