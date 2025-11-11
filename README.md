![LOGO](https://github.com/wsr1949/LGlassesKit_iOS/blob/main/Resources/000.png)

<p align="left">

<a href="https://github.com/wsr1949/LGlassesKit_iOS.git">
    <img src="https://img.shields.io/badge/Release-1.0.0 -Green.svg">
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

### [⚠️请仔细阅读 `README` 集成SDK；参考提供的示例 `Demo`，以帮助您更好地理解 `API` 的使用！](#NOTE)


- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -


## 一、安装（CocoaPods）

##### 1. 在 `Podfile` 中添加
```ruby
pod 'LGlassesKit_iOS', git: 'https://github.com/wsr1949/LGlassesKit_iOS.git'
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

##### 3. 扩展虚拟地址（可选）
```objective-c
Extended Virtual Addressing
```

##### 4. 后台模式`Background Modes`勾选
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

## 二、初始化SDK，注册委托代理

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

##### 通知Wi-Fi热点名称
```ruby
/**
 通知Wi-Fi热点名称
 @param wifiHotspotName     Wi-Fi热点名称
 */
- (void)notifyWifiHotspotName:(NSString * _Nullable)wifiHotspotName;
```

##### Wi-Fi热点连接状态
```ruby
/**
 Wi-Fi热点连接状态
 @param status      Wi-Fi状态
 @param error       错误
 */
- (void)wifiHotspotConnectionStatus:(LWiFiHotspotStatus)status error:(NSError * _Nullable)error;
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

##### 通知AI识图照片数据
```ruby
/**
 通知AI识图照片数据
 @param photoData   图片数据（JPG格式）
 @param error       错误
 */
- (void)notifyAIRecognizePhotoData:(NSData * _Nullable)photoData error:(NSError * _Nullable)error;
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

## 四、命令方法

##### 开始扫描设备
```ruby
/**
 开始扫描设备
 @param callback    设备扫描回调
 @param timeout     扫描超时时间，秒
 */
+ (void)startScanningWithCallback:(LDiscoverPeripheralCallback _Nonnull)callback timeout:(int)timeout;
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

##### 设置语音唤醒
```ruby
/**
 设置语音唤醒
 @param open    是否开启语音唤醒
 */
+ (void)setVoiceWakeUp:(BOOL)open callback:(LResultCallback _Nonnull)callback;
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
+ (void)getDeviceBatteryWithCallback:(LResultNumberCallback _Nonnull)callback;
```

##### 开启拍照
```ruby
/**
 开启拍照
 @param type    拍照类型，当类型为LPhotoType_PhotoRecognition时，成功拍照后图片会通过委托代理LDelegate返回 详@link notifyAIRecognizePhotoData:
 */
+ (void)startTakingPhotos:(LPhotoType)type callback:(LResultCallback _Nonnull)callback;
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

##### 打开Wi-Fi热点
```ruby
/**
 打开Wi-Fi热点
 @note Wi-Fi热点成功打开后名称会通过委托代理LDelegate返回 详@link notifyWifiHotspotName:
 */
+ (void)openWifiHotspotWithCallback:(LResultCallback _Nonnull)callback;
```

##### 连接Wi-Fi热点
```ruby
/**
 连接Wi-Fi热点
 @param wifiHotspotName    Wi-Fi热点名称
 @note  连接结果通过委托代理LDelegate返回 详@link wifiHotspotConnectionStatus:error:
 */
+ (void)connectingWiFiHotspot:(NSString * _Nonnull)wifiHotspotName;
```

##### 断开Wi-Fi热点连接
```ruby
/**
 断开Wi-Fi热点连接
 */
+ (void)disconnectWiFiHotspot;
```

##### Wi-Fi热点连接状态
```ruby
/**
 Wi-Fi热点连接状态
 @return    Wi-Fi热点连接状态
 */
+ (LWiFiHotspotStatus)wifiHotspotStatus;
```

##### 请求文件列表
```ruby
/**
 请求文件列表
 */
+ (void)requestFileListWithCallback:(LFileListCallback _Nonnull)callback;
```

##### 文件下载
```ruby
/**
 文件下载
 @param fileName    文件名称
 */
+ (void)downloadFile:(NSString * _Nonnull)fileName progressCallback:(LProgressCallback _Nonnull)progressCallback completeCallback:(LDownloadCallback _Nonnull)completeCallback;
```

##### 文件删除
```ruby
/**
 文件删除
 @param filePath    文件路径
 */
+ (void)deleteFile:(NSString * _Nonnull)filePath callback:(LResultCallback _Nonnull)callback;
```

##### 上报文件下载个数
```ruby
/**
 上报文件下载个数
 @param count    已下载个数
 */
+ (void)reportFileDownloadsCount:(NSInteger)count callback:(LResultCallback _Nonnull)callback;
```


- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -


# 版本记录🚀
```ruby
 project    2025-10-13  Version:1.0.0   Build:2025091901
            1.首版
```
