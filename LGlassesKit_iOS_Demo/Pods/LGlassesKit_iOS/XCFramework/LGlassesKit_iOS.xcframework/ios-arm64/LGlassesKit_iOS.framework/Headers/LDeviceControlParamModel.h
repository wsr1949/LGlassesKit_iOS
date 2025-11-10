//
//  LDeviceControlParamModel.h
//  LGlassesKit_iOS
//
//  Created by LINWEAR on 2025-11-08.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LDeviceControlParamModel : NSObject

/// LED亮度
@property (nonatomic, assign) LLedBrightness ledBrightness;

/// 录像时长，秒
@property (nonatomic, assign) NSInteger videoDuration;

/// 佩戴检测开关状态
@property (nonatomic, assign) BOOL wearStatus;

/// 语音唤醒开关状态
@property (nonatomic, assign) BOOL wakeUpStatus;

/// 向前滑动
@property (nonatomic, assign) LGestureActions actions_1;
/// 事件
@property (nonatomic, assign) LGestureEvents events_1;

/// 向后滑动
@property (nonatomic, assign) LGestureActions actions_2;
/// 事件
@property (nonatomic, assign) LGestureEvents events_2;

/// 单击
@property (nonatomic, assign) LGestureActions actions_3;
/// 事件
@property (nonatomic, assign) LGestureEvents events_3;

/// 双击
@property (nonatomic, assign) LGestureActions actions_4;
/// 事件
@property (nonatomic, assign) LGestureEvents events_4;

/// 三击
@property (nonatomic, assign) LGestureActions actions_5;
/// 事件
@property (nonatomic, assign) LGestureEvents events_5;

/// 拍摄方向
@property (nonatomic, assign) LShootingDirection direction;

@end

NS_ASSUME_NONNULL_END
