//
//  LVolumeModel.h
//  LGlassesKit_iOS
//
//  Created by LINWEAR on 2026-05-26.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LVolumeModel : NSObject
/// 音量档位：系统提示音量和通话音量共16档，0-15；媒体播放音量共17挡，0-16。

/// 系统提示音量
@property (nonatomic, assign) int systemVolume;

/// 媒体播放音量
@property (nonatomic, assign) int mediaVolume;

/// 通话音量
@property (nonatomic, assign) int callVolume;

@end

NS_ASSUME_NONNULL_END
