//
//  LGlassesKit_iOS.h
//  LGlassesKit_iOS
//
//  Created by LINWEAR on 2025-09-19.
//

#import <Foundation/Foundation.h>

//! Project version number for LGlassesKit_iOS.
FOUNDATION_EXPORT double LGlassesKit_iOSVersionNumber;

//! Project version string for LGlassesKit_iOS.
FOUNDATION_EXPORT const unsigned char LGlassesKit_iOSVersionString[];

// In this header, you should import all the public headers of your framework using statements like #import <LGlassesKit_iOS/PublicHeader.h>

/**
 框架名称：LGlassesKit_iOS.xcframework
 框架功能：智能眼镜的iOS框架，负责与智能眼镜设备通信等功能的封装。
                             
 GitHub @link https://github.com/wsr1949/LGlassesKit_iOS.git
 
 版本记录：
 
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
 
 project    2025-11-08  Version:1.0.0   Build:2025110801
            1.首版
 */

#import <CoreBluetooth/CoreBluetooth.h>

#import <LGlassesKit_iOS/LMacro.h>

#import <LGlassesKit_iOS/LPeripheralModel.h>
#import <LGlassesKit_iOS/LBatteryModel.h>
#import <LGlassesKit_iOS/LFileModel.h>
#import <LGlassesKit_iOS/LDeviceVersionModel.h>
#import <LGlassesKit_iOS/LDeviceControlParamModel.h>

#import <LGlassesKit_iOS/LCallback.h>
#import <LGlassesKit_iOS/LDelegate.h>

#import <LGlassesKit_iOS/LGlassesKit.h>

