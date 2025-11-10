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
+ (void)registerDelegate:(id<LDelegate>)delegate enableLog:(BOOL)enableLog;

/**
 开始扫描设备
 @param callback    设备扫描回调
 @param timeout     扫描超时时间，秒
 */
+ (void)startScanningWithCallback:(LDiscoverPeripheralCallback)callback timeout:(int)timeout;

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
+ (void)connectingDevice:(NSString *)uuid timeout:(int)timeout;

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
+ (void)setSystemTimeWithCallback:(LResultCallback)callback;

/**
 设置LED亮度
 @param brightness  led亮度
 */
+ (void)setLEDBrightness:(LLedBrightness)brightness callback:(LResultCallback)callback;

/**
 设置录像时长
 @param duration    录制时长，秒
 */
+ (void)setVideoRecordingDuration:(NSInteger)duration callback:(LResultCallback)callback;

/**
 设置佩戴检测
 @param open    是否开启佩戴检测
 */
+ (void)setWearDetection:(BOOL)open callback:(LResultCallback)callback;

/**
 设置语音唤醒
 @param open    是否开启语音唤醒
 */
+ (void)setVoiceWakeUp:(BOOL)open callback:(LResultCallback)callback;

/**
 设置快捷手势功能
 @param action  快捷手势
 @param event   手势功能
 */
+ (void)setGesturesAction:(LGestureActions)action event:(LGestureEvents)event callback:(LResultCallback)callback;

/**
 重置快捷手势功能
 */
+ (void)resetGesturesActionWithCallback:(LResultCallback)callback;

/**
 设置久坐提醒
 @param duration    久坐时长，分钟
 */
+ (void)setSedentaryReminderTime:(NSInteger)duration callback:(LResultCallback)callback;

/**
 重启设备
 */
+ (void)setRestartDeviceWithCallback:(LResultCallback)callback;

/**
 恢复出厂设置
 */
+ (void)setFactoryResetWithCallback:(LResultCallback)callback;

/**
 获取设备电池电量
 */
+ (void)getDeviceBatteryWithCallback:(LResultNumberCallback)callback;

/**
 开启拍照
 @param type    拍照类型，当类型为LPhotoType_PhotoRecognition时，成功拍照后图片会通过委托代理LDelegate返回 详@link notifyAIRecognizePhotoData:
 */
+ (void)startTakingPhotos:(LPhotoType)type callback:(LResultCallback)callback;

/**
 照片拍摄模式
 @param mode    拍照模式
 */
+ (void)setPhotoShootingMode:(LPhotoMode)mode callback:(LResultCallback)callback;

/**
 设置拍摄方向
 @param direction    拍摄方向
 */
+ (void)setShootingDirection:(LShootingDirection)direction callback:(LResultCallback)callback;

/**
 开启录像
 */
+ (void)startVideoRecordingWithCallback:(LResultCallback)callback;

/**
 停止录像
 */
+ (void)stopVideoRecordingWithCallback:(LResultCallback)callback;

/**
 开启录音
 */
+ (void)startAudioRecordingWithCallback:(LResultCallback)callback;

/**
 停止录音
 */
+ (void)stopAudioRecordingWithCallback:(LResultCallback)callback;

/**
 获取设备控制参数
 */
+ (void)getDeviceControlParamWithCallback:(LDeviceControlParamCallback)callback;

/**
 获取设备版本
 */
+ (void)getDeviceVersionWithCallback:(LDeviceVersionCallback)callback;

/**
 中断语音传输
 */
+ (void)abortVoiceTransmissionWithCallback:(LResultCallback)callback;

/**
 恢复语音传输
 */
+ (void)resumeVoiceTransmissionWithCallback:(LResultCallback)callback;

/**
 获取当前文件(缩略图)数量
 @note 获取成功后数量会通过委托代理LDelegate返回 详@link notifyThumbnailsCount:
 */
+ (void)getThumbnailsCountWithCallback:(LResultCallback)callback;

/**
 打开Wi-Fi热点
 @note Wi-Fi热点成功打开后名称会通过委托代理LDelegate返回 详@link notifyWifiHotspotName:
 */
+ (void)openWifiHotspotWithCallback:(LResultCallback)callback;

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
+ (void)requestFileListWithCallback:(LFileListCallback)callback;

/**
 文件下载
 @param fileName    文件名称
 */
+ (void)downloadFile:(NSString *)fileName progressCallback:(LProgressCallback)progressCallback completeCallback:(LDownloadCallback)completeCallback;

/**
 文件删除
 @param filePath    文件路径
 */
+ (void)deleteFile:(NSString *)filePath callback:(LResultCallback)callback;

/**
 上报文件下载个数
 @param count    已下载个数
 */
+ (void)reportFileDownloadsCount:(NSInteger)count callback:(LResultCallback)callback;


@end

NS_ASSUME_NONNULL_END
