//
//  LDeviceSeriesPopoverController.h
//  LGlassesKit_iOS_Demo
//
//  Created by LINWEAR on 2026-07-14.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^LDeviceSeriesSelectionCallback)(LDeviceSeries series);

@interface LDeviceSeriesPopoverController : UIViewController

@property (nonatomic, copy, nullable) LDeviceSeriesSelectionCallback selectionCallback;

- (instancetype)initWithSelectedSeries:(LDeviceSeries)selectedSeries;

@end

NS_ASSUME_NONNULL_END
