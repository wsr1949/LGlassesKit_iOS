//
//  LAudioRecorderView.h
//  LGlassesKit_iOS_Demo
//
//  Created by LINWEAR on 2025-12-03.
//

#import <UIKit/UIKit.h>
#import "LAudioWaveformView.h"

NS_ASSUME_NONNULL_BEGIN

typedef void(^LAudioRecorderComplete)(void);
#define LAudioRecorderUpdateSpectraKey @"LAudioRecorderUpdateSpectraKey"

@interface LAudioRecorderView : UIView

+ (instancetype)sharedManager;

- (void)showTitle:(NSString *)title complete:(LAudioRecorderComplete)complete;

- (void)dismiss;

@end

NS_ASSUME_NONNULL_END
