//
//  LGlassesKit.h
//  LGlassesKit_iOS
//
//  Created by LINWEAR on 2025-09-19.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LGlassesKit : NSObject

/**
 注册委托代理
 @param delegate    委托代理
 @param enableLog   是否开启日志 详@link 委托代理方法 notifySdkLog:
 */
+ (void)registerDelegate:(id <LDelegate> _Nonnull)delegate enableLog:(BOOL)enableLog;

/**
 开始扫描设备
 @param callback    设备扫描回调
 @param timeout     扫描超时时间，秒
 */
+ (void)startScanningWithCallback:(LDiscoverPeripheralCallback _Nonnull)callback timeout:(int)timeout;

/**
 停止扫描设备
 */
+ (void)stopScanning;

/**
 连接设备
 @param uuid        设备UUID
 @param timeout     连接超时时间，秒
 @note  连接结果通过委托代理LDelegate返回 详@link bleConnectionStatus:error:
 */
+ (void)connectingDevice:(NSString * _Nonnull)uuid timeout:(int)timeout;

/**
 断开设备连接
 */
+ (void)disconnectDevice;

/**
 中心蓝牙状态
 @return    中心蓝牙状态
*/
+ (CBManagerState)centralManagerState;

/**
 BLE连接状态
 @return    BLE连接状态
 */
+ (LBleStatus)bleConnectStatus;

/**
 设置系统时间
 */
+ (void)setSystemTimeWithCallback:(LResultCallback _Nonnull)callback;

/**
 设置LED亮度
 @param brightness  led亮度
 */
+ (void)setLEDBrightness:(LLedBrightness)brightness callback:(LResultCallback _Nonnull)callback;

/**
 设置录像时长
 @param duration    录制时长，秒
 */
+ (void)setVideoRecordingDuration:(NSInteger)duration callback:(LResultCallback _Nonnull)callback;

/**
 设置佩戴检测
 @param open    是否开启佩戴检测
 */
+ (void)setWearDetection:(BOOL)open callback:(LResultCallback _Nonnull)callback;

/**
 设置语音唤醒
 @param open    是否开启语音唤醒
 */
+ (void)setVoiceWakeUp:(BOOL)open callback:(LResultCallback _Nonnull)callback;

/**
 设置快捷手势功能
 @param action  快捷手势
 @param event   手势功能
 */
+ (void)setGesturesAction:(LGestureActions)action event:(LGestureEvents)event callback:(LResultCallback _Nonnull)callback;

/**
 重置快捷手势功能
 */
+ (void)resetGesturesActionWithCallback:(LResultCallback _Nonnull)callback;

/**
 设置久坐提醒
 @param duration    久坐时长，分钟
 */
+ (void)setSedentaryReminderTime:(NSInteger)duration callback:(LResultCallback _Nonnull)callback;

/**
 重启设备
 */
+ (void)setRestartDeviceWithCallback:(LResultCallback _Nonnull)callback;

/**
 恢复出厂设置
 */
+ (void)setFactoryResetWithCallback:(LResultCallback _Nonnull)callback;

/**
 获取设备电池电量
 */
+ (void)getDeviceBatteryWithCallback:(LBatteryCallback _Nonnull)callback;

/**
 开启拍照
 @param type    拍照类型，当类型为LPhotoType_PhotoRecognition时，成功拍照后图片会通过委托代理LDelegate返回 详@link notifyAIRecognizePhotoData:
 */
+ (void)startTakingPhotos:(LPhotoType)type callback:(LResultCallback _Nonnull)callback;

/**
 照片拍摄模式
 @param mode    拍照模式
 */
+ (void)setPhotoShootingMode:(LPhotoMode)mode callback:(LResultCallback _Nonnull)callback;

/**
 设置拍摄方向
 @param direction    拍摄方向
 */
+ (void)setShootingDirection:(LShootingDirection)direction callback:(LResultCallback _Nonnull)callback;

/**
 开启录像
 */
+ (void)startVideoRecordingWithCallback:(LResultCallback _Nonnull)callback;

/**
 停止录像
 */
+ (void)stopVideoRecordingWithCallback:(LResultCallback _Nonnull)callback;

/**
 开启录音
 */
+ (void)startAudioRecordingWithCallback:(LResultCallback _Nonnull)callback;

/**
 停止录音
 */
+ (void)stopAudioRecordingWithCallback:(LResultCallback _Nonnull)callback;

/**
 获取设备控制参数
 */
+ (void)getDeviceControlParamWithCallback:(LDeviceControlParamCallback _Nonnull)callback;

/**
 获取设备版本
 */
+ (void)getDeviceVersionWithCallback:(LDeviceVersionCallback _Nonnull)callback;

/**
 中断语音传输
 */
+ (void)abortVoiceTransmissionWithCallback:(LResultCallback _Nonnull)callback;

/**
 恢复语音传输
 */
+ (void)resumeVoiceTransmissionWithCallback:(LResultCallback _Nonnull)callback;

/**
 获取当前文件(缩略图)数量
 @note 获取成功后数量会通过委托代理LDelegate返回 详@link notifyThumbnailsCount:
 */
+ (void)getThumbnailsCountWithCallback:(LResultCallback _Nonnull)callback;

/**
 打开Wi-Fi热点
 @note Wi-Fi热点成功打开后名称会通过委托代理LDelegate返回 详@link notifyWifiHotspotName:
 */
+ (void)openWifiHotspotWithCallback:(LResultCallback _Nonnull)callback;

/**
 连接Wi-Fi热点
 @param wifiHotspotName    Wi-Fi热点名称
 @note  连接结果通过委托代理LDelegate返回 详@link wifiHotspotConnectionStatus:error:
 */
+ (void)connectingWiFiHotspot:(NSString * _Nonnull)wifiHotspotName;

/**
 断开Wi-Fi热点连接
 */
+ (void)disconnectWiFiHotspot;

/**
 Wi-Fi热点连接状态
 @return    Wi-Fi热点连接状态
 */
+ (LWiFiHotspotStatus)wifiHotspotStatus;

/**
 请求文件列表
 */
+ (void)requestFileListWithCallback:(LFileListCallback _Nonnull)callback;

/**
 文件下载
 @param fileName    文件名称
 */
+ (void)downloadFile:(NSString * _Nonnull)fileName progressCallback:(LDownloadProgressCallback _Nonnull)progressCallback completeCallback:(LDownloadCallback _Nonnull)completeCallback;

/**
 文件删除
 @param filePath    文件路径
 */
+ (void)deleteFile:(NSString * _Nonnull)filePath callback:(LResultCallback _Nonnull)callback;

/**
 上报文件下载个数
 @param count    已下载个数
 */
+ (void)reportFileDownloadsCount:(NSInteger)count callback:(LResultCallback _Nonnull)callback;


/**
 🚀开始OTA升级
 @param filePath                    ota文件本地路径
 @param preparingProgressCallback   ota准备进度回调
 @param upgradeProgressCallback     ota升级进度回调
 @param upgradeResultCallback       ota升级结果回调
 */
+ (void)startOtaUpgradeWithFilePath:(NSString * _Nonnull)filePath
          preparingProgressCallback:(LOtaUpgradeProgressCallback _Nonnull)preparingProgressCallback
            upgradeProgressCallback:(LOtaUpgradeProgressCallback _Nonnull)upgradeProgressCallback
              upgradeResultCallback:(LResultCallback _Nonnull)upgradeResultCallback;


/**
 🚀开始ISP升级（需要先打开并连接Wi-Fi热点）
 @param filePath                    isp文件本地路径
 @param upgradeProgressCallback     isp升级进度回调
 @param upgradeResultCallback       isp升级结果回调
 */
+ (void)startIspUpgradeWithFilePath:(NSString * _Nonnull)filePath
            upgradeProgressCallback:(LOtaUpgradeProgressCallback _Nonnull)upgradeProgressCallback
              upgradeResultCallback:(LResultCallback _Nonnull)upgradeResultCallback;


@end

NS_ASSUME_NONNULL_END
