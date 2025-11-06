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


# LGlassesKit_iOS👓

LGlassesKit_iOS 为智能眼镜的iOS框架，负责与智能眼镜设备通信等功能的封装。

## 兼容性（XCFramework）

支持模拟器、真机（注意模拟器不支持蓝牙）`iOS 14.0 及以上操作系统`

## 安装（CocoaPods）

#### 1. 在 `Podfile` 中添加
```ruby
pod 'LGlassesKit_iOS', git: 'https://github.com/wsr1949/LGlassesKit_iOS.git'
```

#### 2. 终端执行 
```ruby
pod install
```

## Info.plist 添加隐私权限描述

#### 1. 蓝牙权限
```objective-c
Privacy - Bluetooth Always Usage Description
```

#### 2. 本地网络权限
```objective-c
Privacy - Local Network Usage Description
```

## TARGRTS 添加 Capability

#### 1. 访问Wi-Fi信息 
```objective-c
Access Wi-Fi Information
```

#### 2. 热点
```objective-c
Hotspot
```

#### 3. 扩展虚拟地址（可选）
```objective-c
Extended Virtual Addressing
```

#### 4. 后台模式`Background Modes`勾选
```objective-c 
Uses Bluetooth LE accessories
```

# 🎉开始使用，导入头文件
```objective-c 
#import <LGlassesKit_iOS/LGlassesKit_iOS.h>
```

### 初始化SDK，注册委托代理
```ruby 
/**
 注册委托代理
 @param delegate    委托代理
 @param enableLog   是否开启日志 详@link 委托代理方法 notifySdkLog:
 */
+ (void)registerDelegate:(id<LDelegate>)delegate enableLog:(BOOL)enableLog;
```

### 实现委托代理方法

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

#### SDK日志，enableLog需要设置开启
```ruby
/**
 SDK日志，enableLog需要设置开启
 @param logText     日志
 */
- (void)notifySdkLog:(NSString * _Nullable)logText;
```

#### 每次拍照或录像成功，通知缩略图数量
```ruby
/**
 每次拍照或录像成功，通知缩略图数量
 @param count       数量
 */
- (void)notifyThumbnailsCount:(NSInteger)count;
```

```ruby
/**
 通知Wi-Fi热点名称
 @param wifiHotspotName     Wi-Fi热点名称
 */
- (void)notifyWifiHotspotName:(NSString * _Nullable)wifiHotspotName;
```

```ruby
/**
 Wi-Fi热点连接状态
 @param status      Wi-Fi状态
 @param error       错误
 */
- (void)wifiHotspotConnectionStatus:(LWiFiHotspotStatus)status error:(NSError * _Nullable)error;
```

```ruby
/**
 通知设备电池电量信息
 @param batteryModel        电池电量信息
 */
- (void)notifyDeviceBatteryInfo:(LBatteryModel * _Nonnull)batteryModel;
```

```ruby
/**
 通知AI语音助手状态
 @param activated   激活状态，YES激活 NO未激活
 */
- (void)notifyAIVoiceAssistantStatus:(BOOL)activated;
```

```ruby
/**
 通知语音数据
 @param voiceData   语音数据（opus格式）
 */
- (void)notifyVoiceData:(NSData * _Nullable)voiceData;
```

```ruby
/**
 通知AI识图照片数据
 @param photoData   图片数据（JPG格式）
 @param error       错误
 */
- (void)notifyAIRecognizePhotoData:(NSData * _Nullable)photoData error:(NSError * _Nullable)error;
```

```ruby
/**
 通知停止语音识别
 */
- (void)notifyStopSpeechRecognition;
```

```ruby
/**
 通知停止语音播报
 */
- (void)notifyStopVoicePlayback;

```

 # 版本记录🚀
```ruby
 project    2025-10-13  Version:1.0.0   Build:2025091901
            1.首版
```
