//
//  LDeviceStatusModel.h
//  LGlassesKit_iOS
//
//  Created by LINWEAR on 2026-09-02.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LDeviceStatusModel : NSObject

/// 是否正在拍照
@property (nonatomic, assign) BOOL photoTaking;

/// 是否正在录音
@property (nonatomic, assign) BOOL audioRecording;

/// 是否正在录像
@property (nonatomic, assign) BOOL videoRecording;

/// 音乐正在播放
@property (nonatomic, assign) BOOL musicPlaying;

/// 设备是否已佩戴
@property (nonatomic, assign) BOOL deviceWearing;

/// 是否正在导入中
@property (nonatomic, assign) BOOL importing;

@end

NS_ASSUME_NONNULL_END
