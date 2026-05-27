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
 @param callback            设备扫描回调
 @param timeout             扫描超时时间，秒
 @param broadcastAnalysis   是否解析广播，YES解析成功才回调，NO不解析广播数据直接回调
 */
+ (void)startScanningWithCallback:(LDiscoverPeripheralCallback _Nonnull)callback timeout:(int)timeout broadcastAnalysis:(BOOL)broadcastAnalysis;

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
 @param open        是否开启佩戴检测
 */
+ (void)setWearDetection:(BOOL)open callback:(LResultCallback _Nonnull)callback;

/**
 获取语音指令控制
 */
+ (void)getVoiceCmdControlWithCallback:(LDeviceVoiceCmdControlCallback _Nonnull)callback;

/**
 设置语音指令控制
 @param control     语音控制
 */
+ (void)setVoiceCmdControl:(LVoiceCmdControl)control callback:(LResultCallback _Nonnull)callback;

/**
 设置快捷手势功能
 @param action      快捷手势
 @param event       手势功能
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
 开启拍照，仅拍照
 */
+ (void)startPhotoTakingWithCallback:(LResultCallback _Nonnull)callback;

/**
 开启拍照，返回图片数据
 */
+ (void)startPhotoTakingWithCompletion:(LPhotoCallback _Nonnull)completion;

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
 开始导入文件
 @param progressCallback            导入进度回调
                                        fileModel: 当前正在导入的文件信息
                                        currentIndex: 当前文件索引
                                        totalCount: 总的文件数量
                                        totalProgress: 总进度0-100
                                        speed: 速率，字节/秒
 @param importedCallback            当前已导入回调
                                        fileModel: 当前导入的文件信息
                                        locationUrl: 文件本地URL路径，注意⚠️url为系统temp目录下，如需长期缓存请及时移动文件至自己自身业务目录下
 @param completion                  完成回调
                                        complete: YES完成，NO失败 error不为nil
 */
+ (void)startImportingFilesWithProgressCallback:(void (^)(LFileModel *fileModel, NSInteger currentIndex, NSInteger totalCount, double totalProgress, double speed))progressCallback
                               importedCallback:(void (^)(LFileModel *fileModel, NSURL *locationUrl))importedCallback
                                     completion:(void (^)(BOOL complete, NSError * _Nullable error))completion;

/**
 🚀开始OTA升级（BLE模块）
 @param filePath                    ota文件本地路径
 @param isRestoreUpgrade            恢复OTA升级，true恢复升级，false正常升级
 @param restoreReconnectMethod      恢复OTA升级的设备回连方式，isRestore==true时（必填）使用正确的回连方式；isRestore==false时则使用None即可
 @param restoreReconnectDevice      恢复OTA升级的设备，isRestore==true时（必填）使用正确的设备；isRestore==false时则传nil即可
 @param preparingProgressCallback   ota准备进度回调
 @param reconnectCallback           ota设备回连回调
 @param upgradeProgressCallback     ota升级进度回调
 @param upgradeResultCallback       ota升级结果回调
 @param restartCallback             ota设备重启回调
 */
+ (void)startOtaUpgradeWithFilePath:(NSString * _Nonnull)filePath
                   isRestoreUpgrade:(BOOL)isRestoreUpgrade
               restoreReconnectMethod:(LOtaUpgradeReconnectMethod)restoreReconnectMethod
             restoreReconnectDevice:(NSString * _Nullable)restoreReconnectDevice
          preparingProgressCallback:(LOtaUpgradeProgressCallback _Nonnull)preparingProgressCallback
                  reconnectCallback:(LOtaUpgradeReconnectCallback _Nonnull)reconnectCallback
            upgradeProgressCallback:(LOtaUpgradeProgressCallback _Nonnull)upgradeProgressCallback
              upgradeResultCallback:(LResultCallback _Nonnull)upgradeResultCallback
                    restartCallback:(void (^ _Nonnull)(void))restartCallback;

/**
 🚀开始ISP升级（Wi-Fi模块）
 @param filePath                    isp文件本地路径
 @param ispVersion                  isp版本号，格式x.x.x
 @param upgradeProgressCallback     isp升级进度回调
 @param upgradeResultCallback       isp升级结果回调
 @note 先进入ISP升级模式，成功连接Wi-Fi热点后，再开始ISP升级
 */
+ (void)startIspUpgradeWithFilePath:(NSString * _Nonnull)filePath
                         ispVersion:(NSString * _Nonnull)ispVersion
            upgradeProgressCallback:(LOtaUpgradeProgressCallback _Nonnull)upgradeProgressCallback
              upgradeResultCallback:(LResultCallback _Nonnull)upgradeResultCallback;

/**
 设置离线语音语种
 */
+ (void)setOfflineVoiceLanguage:(LOfflineVoiceLanguage)language callback:(LResultCallback _Nonnull)callback;

/**
 音乐控制
 */
+ (void)setupMusicControls:(LMusicControl)control callback:(LResultCallback _Nonnull)callback;

/**
 音量控制
 */
+ (void)setupVolumeControls:(LVolumeControl)control callback:(LResultCallback _Nonnull)callback;

/**
 通话控制
 */
+ (void)setupCallControls:(LCallControl)control callback:(LResultCallback _Nonnull)callback;

/**
 获取设备音量
 */
+ (void)getDeviceVolumeWithCallback:(LDeviceVolumeCallback _Nonnull)callback;

/**
 设置设备音量
 @param volume  音量档位：系统提示音量和通话音量共16档，0-15；媒体播放音量共17挡，0-16。
 */
+ (void)setDeviceVolume:(int)volume type:(LVolumeType)type callback:(LResultCallback _Nonnull)callback;

@end

NS_ASSUME_NONNULL_END
