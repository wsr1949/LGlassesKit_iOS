//
//  LCallback.h
//  LGlassesKit_iOS
//
//  Created by LINWEAR on 2025-09-23.
//

#ifndef LCallback_h
#define LCallback_h

/**
 扫描设备回调
 @param peripheralModel     扫描到的设备
 */
typedef void(^LDiscoverPeripheralCallback)(LPeripheralModel * _Nonnull peripheralModel);

/**
 结果回调
 @param error               错误
 */
typedef void(^LResultCallback)(NSError * _Nullable error);

/**
 数值结果回调
 @param number              数值
 @param error               错误
 */
typedef void(^LResultNumberCallback)(NSNumber * _Nullable number, NSError * _Nullable error);

/**
 文件列表回调
 @param list                文件列表
 @param error               错误
 */
typedef void(^LFileListCallback)(NSArray <LFileModel *> * _Nullable list, NSError * _Nullable error);

/**
 进度回调
 @param progress            进度 0-100
 @param speed               速率 字节/秒
 */
typedef void(^LProgressCallback)(double progress, double speed);

/**
 文件下载回调
 @param data                文件数据
 @param error               错误
 */
typedef void(^LDownloadCallback)(NSData * _Nullable data, NSError * _Nullable error);

/**
 设备控制参数回调
 */
typedef void(^LDeviceControlParamCallback)(LDeviceControlParamModel * _Nullable deviceModel, NSError * _Nullable error);

/**
 设备版本回调
 @param deviceModel         设备版本
 @param error               错误
 */
typedef void(^LDeviceVersionCallback)(LDeviceVersionModel * _Nullable deviceModel, NSError * _Nullable error);


#endif /* LCallback_h */
