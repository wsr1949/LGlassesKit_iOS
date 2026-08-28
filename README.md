![LOGO](https://github.com/wsr1949/LGlassesKit_iOS/blob/main/Resources/000.jpg)

<p align="left">

<a href="https://github.com/wsr1949/LGlassesKit_iOS.git">
    <img src="https://img.shields.io/badge/Release-1.1.1 -Green.svg">
</a>
<a href="https://github.com/wsr1949/LGlassesKit_iOS.git">
    <img src="https://img.shields.io/badge/Support-iOS14.0+ -blue.svg">
</a>
<a href="https://github.com/wsr1949/LGlassesKit_iOS.git">
    <img src="https://img.shields.io/badge/Support-CocoaPods -aquamarine.svg">
</a>
<a href="https://github.com/wsr1949/LGlassesKit_iOS.git">
    <img src="https://img.shields.io/badge/Language-Objective_C -red.svg">
</a>
<a href="https://github.com/wsr1949/LGlassesKit_iOS.git">
    <img src="https://img.shields.io/badge/License-MIT -gold.svg">
</a>

</p>


- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -


# 👓LGlassesKit_iOS

#### LGlassesKit_iOS 为智能眼镜的iOS框架，负责与智能眼镜设备通信等功能的封装。

## 兼容性（XCFramework）

#### 支持 `iOS 14.0 及以上操作系统`

#### [⚠️请仔细阅读 `README` 集成SDK；参考提供的示例 `Demo`，以帮助您更好地理解 `API` 的使用！](#NOTE)

#### [🎈提供的示例 `Demo` 片段仅供演示用途，并未经过严格测试，不要作为商用目的使用！](#NOTE)

#### [‼️设备有多个 `系列`，为确保能够正常交互，连接成功后需要设置该设备属于哪个 `系列`，API详参：`+ (void)setDeviceSeries:(LDeviceSeries)series;`](#NOTE)

- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -


## 一、安装（CocoaPods）

##### 1. 在 `Podfile` 中添加

眼镜SDK
```ruby
pod 'LGlassesKit_iOS', git: 'https://github.com/wsr1949/LGlassesKit_iOS.git'
```

AI SDK（如有自己的AI服务可不集成）
```ruby
pod 'iOS_LWAIGCKit', git: 'https://github.com/wsr1949/iOS_LWAIGCKit.git'
```

##### 2. 终端执行 
```ruby
pod install
```

## 二、Info.plist 添加隐私权限描述

##### 1. 蓝牙权限
```objective-c
Privacy - Bluetooth Always Usage Description
```

##### 2. 本地网络权限
```objective-c
Privacy - Local Network Usage Description
```

![001](https://github.com/wsr1949/LGlassesKit_iOS/blob/main/Resources/001.png)

## 三、TARGRTS 添加 Capability

##### 1. 访问Wi-Fi信息 
```objective-c
Access Wi-Fi Information
```

##### 2. 热点
```objective-c
Hotspot
```

##### 3. 扩展虚拟地址 `（可选）`
```objective-c
Extended Virtual Addressing
```

##### 4. 后台模式 `Background Modes` 勾选
```objective-c 
Uses Bluetooth LE accessories
```

![002](https://github.com/wsr1949/LGlassesKit_iOS/blob/main/Resources/002.png)


- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -


# 🎉开始使用

## 一、导入头文件
```objective-c 
#import <LGlassesKit_iOS/LGlassesKit_iOS.h>
```

## 二、初始化SDK（详阅LGlassesKit.h）注册委托代理

##### 注册委托代理
```ruby 
/**
 注册委托代理
 @param delegate    委托代理
 @param enableLog   是否开启日志 详@link 委托代理方法 notifySdkLog:
 */
+ (void)registerDelegate:(id <LDelegate> _Nonnull)delegate enableLog:(BOOL)enableLog;
```

## 三、实现委托代理方法

##### 中心蓝牙状态
```ruby
/**
 中心蓝牙状态
 @param status      蓝牙状态
 */
- (void)centralBluetoothStatus:(CBManagerState)status;
```

##### BLE连接状态
```ruby
/**
 BLE连接状态
 @param status      ble状态
 @param error       错误
 */
- (void)bleConnectionStatus:(LBleStatus)status error:(NSError * _Nullable)error;
```

##### SDK日志，enableLog需要设置开启
```ruby
/**
 SDK日志，enableLog需要设置开启
 @param logText     日志
 */
- (void)notifySdkLog:(NSString * _Nullable)logText;
```

##### 每次拍照或录像成功，通知缩略图数量
```ruby
/**
 每次拍照或录像成功，通知缩略图数量
 @param count       数量
 */
- (void)notifyThumbnailsCount:(NSInteger)count;
```

##### 通知设备电池电量信息
```ruby
/**
 通知设备电池电量信息
 @param batteryModel        电池电量信息
 */
- (void)notifyDeviceBatteryInfo:(LBatteryModel * _Nonnull)batteryModel;
```

##### 通知AI语音助手状态
```ruby
/**
 通知AI语音助手状态
 @param activated   激活状态，YES激活 NO未激活
 */
- (void)notifyAIVoiceAssistantStatus:(BOOL)activated;
```

##### 通知语音数据
```ruby
/**
 通知语音数据
 @param voiceData   语音数据（opus格式）
 */
- (void)notifyVoiceData:(NSData * _Nullable)voiceData;
```

##### 通知停止语音识别
```ruby
/**
 通知停止语音识别
 */
- (void)notifyStopSpeechRecognition;
```

##### 通知停止语音播报
```ruby
/**
 通知停止语音播报
 */
- (void)notifyStopVoicePlayback;
```

##### 通知拍照状态
```ruby
/**
 通知拍照状态
 @param activated   激活状态，YES激活 NO未激活
 */
- (void)notifyDevicePhotoTakingStatus:(BOOL)activated;
```

##### 通知录音状态
```ruby
/**
 通知录音状态
 @param activated   激活状态，YES激活 NO未激活
 */
- (void)notifyAudioRecordingStatus:(BOOL)activated;
```

##### 通知录像状态
```ruby
/**
 通知录像状态
 @param activated   激活状态，YES激活 NO未激活
 */
- (void)notifyVideoRecordingStatus:(BOOL)activated;
```

##### 通知设备其他状态
```ruby
/**
 通知设备其他状态
 @param status     状态
 */
- (void)notifyDeviceOtherStatus:(LOtherStatus)status;
```

##### 通知设备音乐播放状态
```ruby
/**
 通知设备音乐播放状态
 @param playing     音乐播放状态，YES播放 NO暂停
 */
- (void)notifyDeviceMusicPlayingStatus:(BOOL)playing;
```

##### 通知设备佩戴状态
```ruby
/**
 通知设备佩戴状态
 @param wearing     佩戴状态，YES佩戴 NO未佩戴
 */
- (void)notifyDeviceWearingStatus:(BOOL)wearing;
```

##### 通知设备导入状态
```ruby
/**
 通知设备导入状态
 @param importing   导入状态，YES正在导入 NO未导入
 */
- (void)notifyDeviceImportingStatus:(BOOL)importing;
```

##### 通知设备按键事件
```ruby
/**
 通知设备按键事件
 @param event       事件
 */
- (void)notifyDeviceButtonEvents:(LButtonEvents)event;
```


## 四、命令方法

##### 开始扫描设备
```ruby
/**
 开始扫描设备
 @param callback            设备扫描回调
 @param timeout             扫描超时时间，秒
 @param broadcastAnalysis   是否解析广播，YES解析成功才回调，NO不解析广播数据直接回调
 */
+ (void)startScanningWithCallback:(LDiscoverPeripheralCallback _Nonnull)callback timeout:(int)timeout broadcastAnalysis:(BOOL)broadcastAnalysis;
```

##### 停止扫描设备
```ruby
/**
 停止扫描设备
 */
+ (void)stopScanning;
```

##### 连接设备
```ruby
/**
 连接设备
 @param uuid        设备UUID
 @param timeout     连接超时时间，秒
 @note  连接结果通过委托代理LDelegate返回 详@link bleConnectionStatus:error:
 */
+ (void)connectingDevice:(NSString * _Nonnull)uuid timeout:(int)timeout;
```

##### 断开设备连接
```ruby
/**
 断开设备连接
 */
+ (void)disconnectDevice;
```

##### 中心蓝牙状态
```ruby
/**
 中心蓝牙状态
 @return    中心蓝牙状态
*/
+ (CBManagerState)centralManagerState;
```

##### BLE连接状态
```ruby
/**
 BLE连接状态
 @return    BLE连接状态
 */
+ (LBleStatus)bleConnectStatus;
```

##### 设置设备系列
```ruby
/**
 设置设备系列
 @note  Wi-Fi热点地址不同、接口不同
 */
+ (void)setDeviceSeries:(LDeviceSeries)series;
```

##### 设置系统时间
```ruby
/**
 设置系统时间
 */
+ (void)setSystemTimeWithCallback:(LResultCallback _Nonnull)callback;
```

##### 设置LED亮度
```ruby
/**
 设置LED亮度
 @param brightness  led亮度
 */
+ (void)setLEDBrightness:(LLedBrightness)brightness callback:(LResultCallback _Nonnull)callback;
```

##### 设置录像时长
```ruby
/**
 设置录像时长
 @param duration    录制时长，秒
 */
+ (void)setVideoRecordingDuration:(NSInteger)duration callback:(LResultCallback _Nonnull)callback;
```

##### 设置佩戴检测
```ruby
/**
 设置佩戴检测
 @param open    是否开启佩戴检测
 */
+ (void)setWearDetection:(BOOL)open callback:(LResultCallback _Nonnull)callback;
```

##### 获取语音指令控制
```ruby
/**
 获取语音指令控制
 */
+ (void)getVoiceCmdControlWithCallback:(LDeviceVoiceCmdControlCallback _Nonnull)callback;
```

##### 设置语音指令控制
```ruby
/**
 设置语音指令控制
 @param control     语音控制
 */
+ (void)setVoiceCmdControl:(LVoiceCmdControl)control callback:(LResultCallback _Nonnull)callback;
```

##### 设置快捷手势功能
```ruby
/**
 设置快捷手势功能
 @param action  快捷手势
 @param event   手势功能
 */
+ (void)setGesturesAction:(LGestureActions)action event:(LGestureEvents)event callback:(LResultCallback _Nonnull)callback;
```

#### 重置快捷手势功能
```ruby
/**
 重置快捷手势功能
 */
+ (void)resetGesturesActionWithCallback:(LResultCallback _Nonnull)callback;
```

##### 设置久坐提醒
```ruby
/**
 设置久坐提醒
 @param duration    久坐时长，分钟
 */
+ (void)setSedentaryReminderTime:(NSInteger)duration callback:(LResultCallback _Nonnull)callback;
```

##### 重启设备
```ruby
/**
 重启设备
 */
+ (void)setRestartDeviceWithCallback:(LResultCallback _Nonnull)callback;
```

##### 恢复出厂设置
```ruby
/**
 恢复出厂设置
 */
+ (void)setFactoryResetWithCallback:(LResultCallback _Nonnull)callback;
```

##### 获取设备电池电量
```ruby
/**
 获取设备电池电量
 */
+ (void)getDeviceBatteryWithCallback:(LBatteryCallback _Nonnull)callback;
```

##### 开启拍照，仅拍照
```ruby
/**
 开启拍照，仅拍照
 */
+ (void)startPhotoTakingWithCallback:(LResultCallback _Nonnull)callback;
```

##### 开启拍照，返回图片数据
```ruby
/**
 开启拍照，返回图片数据
 */
+ (void)startPhotoTakingWithCompletion:(LPhotoCallback _Nonnull)completion;
```

##### 照片拍摄模式
```ruby
/**
 照片拍摄模式
 @param mode    拍照模式
 */
+ (void)setPhotoShootingMode:(LPhotoMode)mode callback:(LResultCallback _Nonnull)callback;
```

##### 设置拍摄方向
```ruby
/**
 设置拍摄方向
 @param direction    拍摄方向
 */
+ (void)setShootingDirection:(LShootingDirection)direction callback:(LResultCallback _Nonnull)callback;
```

##### 开启录像
```ruby
/**
 开启录像
 */
+ (void)startVideoRecordingWithCallback:(LResultCallback _Nonnull)callback;
```

##### 停止录像
```ruby
/**
 停止录像
 */
+ (void)stopVideoRecordingWithCallback:(LResultCallback _Nonnull)callback;
```

##### 开启录音
```ruby
/**
 开启录音
 */
+ (void)startAudioRecordingWithCallback:(LResultCallback _Nonnull)callback;
```

##### 停止录音
```ruby
/**
 停止录音
 */
+ (void)stopAudioRecordingWithCallback:(LResultCallback _Nonnull)callback;
```

##### 获取设备控制参数
```ruby
/**
 获取设备控制参数
 */
+ (void)getDeviceControlParamWithCallback:(LDeviceControlParamCallback _Nonnull)callback;
```

##### 获取设备版本
```ruby
/**
 获取设备版本
 */
+ (void)getDeviceVersionWithCallback:(LDeviceVersionCallback _Nonnull)callback;
```

##### 中断语音传输
```ruby
/**
 中断语音传输
 */
+ (void)abortVoiceTransmissionWithCallback:(LResultCallback _Nonnull)callback;
```

##### 恢复语音传输
```ruby
/**
 恢复语音传输
 */
+ (void)resumeVoiceTransmissionWithCallback:(LResultCallback _Nonnull)callback;
```

##### 获取当前文件(缩略图)数量
```ruby
/**
 获取当前文件(缩略图)数量
 @note 获取成功后数量会通过委托代理LDelegate返回 详@link notifyThumbnailsCount:
 */
+ (void)getThumbnailsCountWithCallback:(LResultCallback _Nonnull)callback;
```

##### 开始导入文件
```ruby
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
```

##### 🚀开始OTA升级（BLE模块）
```ruby
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
```

##### 🚀开始ISP升级（Wi-Fi模块）
```ruby
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
```

##### 设置离线语音语种
```ruby
/**
 设置离线语音语种
 */
+ (void)setOfflineVoiceLanguage:(LOfflineVoiceLanguage)language callback:(LResultCallback _Nonnull)callback;
```

##### 音乐控制
```ruby
/**
 音乐控制
 */
+ (void)setupMusicControls:(LMusicControl)control callback:(LResultCallback _Nonnull)callback;
```

##### 音量控制
```ruby
/**
 音量控制
 */
+ (void)setupVolumeControls:(LVolumeControl)control callback:(LResultCallback _Nonnull)callback;
```

##### 通话控制
```ruby
/**
 通话控制
 */
+ (void)setupCallControls:(LCallControl)control callback:(LResultCallback _Nonnull)callback;
```

##### 获取设备音量
```ruby
/**
 获取设备音量
 */
+ (void)getDeviceVolumeWithCallback:(LDeviceVolumeCallback _Nonnull)callback;
```

##### 设置设备音量
```ruby
/**
 设置设备音量
 @param volume  音量档位：系统提示音量和通话音量共16档，0-15；媒体播放音量共17挡，0-16。
 */
+ (void)setDeviceVolume:(int)volume type:(LVolumeType)type callback:(LResultCallback _Nonnull)callback;
```

- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -


# 版本记录🚀
```ruby
 project    2026-07-14  Version:1.1.1   Build:2026071401
            1.新增委托代理方法 详@link LDelegate
                通知设备导入状态 notifyDeviceImportingStatus:
            2.新增设置设备系列 详@link（LGlassesKit）setDeviceSeries: 兼容S/T系列设备
            3.优化已知问题

 project    2026-05-28  Version:1.1.0   Build:2026052801
            1.修复已知问题

 project    2026-05-27  Version:1.0.9   Build:2026052701
            1.新增音乐控制 详@link（LGlassesKit）setupMusicControls: callback:
            2.新增音量控制 详@link（LGlassesKit）setupVolumeControls:callback:
            3.新增通话控制 详@link（LGlassesKit）setupCallControls:callback:
            4.新增设置设备音量 详@link（LGlassesKit）getDeviceVolumeWithCallback:
            5.新增获取设备音量 详@link（LGlassesKit）setDeviceVolume:type:callback:

 project    2026-05-20  Version:1.0.8   Build:2026052001
            1.移除 startTakingPhotos:callback: 拍照方法 及 拍照类型枚举LPhotoType，新增以下2个方法区分
                - 仅拍照 详@link （LGlassesKit）startPhotoTakingWithCallback:
                - 拍照并返回图片 详@link （LGlassesKit）startPhotoTakingWithCompletion:
            2.移除委托代理方法（LDelegate）notifyAIRecognizePhotoData: 使用代替方法 详@link startPhotoTakingWithCompletion:
            3.移除委托代理方法（LDelegate）notifyWifiHotspotName: 以及 wifiHotspotConnectionStatus:error:
            4.新增导入文件封装方法 详@link （LGlassesKit）startImportingFilesWithProgressCallback:importedCallback:completion:
            5.优化ISP升级方法 详@link （LGlassesKit）startIspUpgradeWithFilePath:ispVersion:upgradeProgressCallback:upgradeResultCallback:
            6.移除设置语音唤醒方法 setVoiceWakeUp:callback: 使用代替方法 详@link setVoiceCmdControl:callback:
            7.新增获取语音指令控制（LGlassesKit）getVoiceCmdControlWithCallback
            8.新增设置语音指令控制（LGlassesKit）setVoiceCmdControl:callback:

 project    2026-04-30  Version:1.0.7   Build:2026043001
            1.新增委托代理方法 详@link LDelegate
                通知设备按键事件 notifyDeviceButtonEvents:
            2.修复偶现拍照状态异常BUG

 project    2026-02-02  Version:1.0.6   Build:2026020201
            1.优化下载方法，支持本地目标地址 详@link downloadFile:targetUrl:progressCallback:completeCallback
            2.新增委托代理方法 详@link LDelegate
                通知设备其他状态 notifyDeviceOtherStatus:
                通知设备音乐播放状态 notifyDeviceMusicPlayingStatus:
            3.修复已知解析错误BUG

 project    2026-01-06  Version:1.0.5   Build:2026010601
            1.修复已知解析错误BUG

 project    2026-01-05  Version:1.0.4   Build:2026010501
            1.更新「开始扫描设备」方法 startScanningWithCallback:timeout:broadcastAnalysis: 新增broadcastAnalysis是否解析广播，YES解析成功才回调，NO不解析广播数据直接回调

 project    2025-12-22  Version:1.0.3   Build:2025122201
            1.更新OTA升级方法（LGlassesKit）startOtaUpgradeWithFilePath...
                - 增加 isRestoreUpgrade 恢复OTA升级，true恢复升级，false正常升级
                - 增加 restoreReconnectMethod 恢复OTA升级的设备回连方式，isRestore==true时（必填）使用正确的回连方式；isRestore==false时则使用None即可
                - 增加 restoreReconnectDevice 恢复OTA升级的设备，isRestore==true时（必填）使用正确的设备；isRestore==false时则传nil即可
                - 修改 reconnectCallback 设备回连回调，增加 reconnectMethod 回连方式、reconnectDevice 回连设备
            2.更新ISP升级方法（LGlassesKit）startIspUpgradeWithFilePath...
                - 增加 ispVersion 升级版本号
                - 移除 restartCallback 重启回调，升级成功设备不会重启

 project    2025-12-15  Version:1.0.2   Build:2025121501
            1.新增委托代理方法 @link LDelegate
                通知拍照状态 notifyDevicePhotoTakingStatus:
                通知录音状态 notifyAudioRecordingStatus:
                通知录像状态 notifyVideoRecordingStatus:
                通知设备佩戴状态 notifyDeviceWearingStatus:
            2.新增进入ISP升级模式方法（LGlassesKit）enableIspUpgradeModeWithCallback:
            3.更新OTA升级方法（LGlassesKit）startOtaUpgradeWithFilePath...
            4.更新ISP升级方法（LGlassesKit）startIspUpgradeWithFilePath...
            5.新增设置离线语音语种方法（LGlassesKit）setOfflineVoiceLanguage:
            6.其他已知问题优化

 project    2025-11-25  Version:1.0.1   Build:2025112501
            1.新增区分Ble连接失败状态（LMacro）LBleStatusConnectionFailed
            2.新增区分Wi-Fi连接失败状态（LMacro）LWiFiHotspotStatusConnectionFailed
            3.新增OTA升级方法（LGlassesKit）startOtaUpgradeWithFilePath...
            4.新增ISP升级方法（LGlassesKit）startIspUpgradeWithFilePath...

 project    2025-10-13  Version:1.0.0   Build:2025091901
            1.首版
```
