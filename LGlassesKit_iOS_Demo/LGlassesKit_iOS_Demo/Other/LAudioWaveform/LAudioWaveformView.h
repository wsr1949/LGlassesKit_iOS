//
//  LAudioWaveformView.h
//  LGlassesKit_iOS_Demo
//
//  Created by LINWEAR on 2025-12-03.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface LAudioWaveformView : UIView

@property (nonatomic, assign) CGFloat barWidth;
@property (nonatomic, assign) CGFloat space;
@property (nonatomic, assign) CGFloat bottomSpace;
@property (nonatomic, assign) CGFloat topSpace;

- (void)updateSpectra:(NSArray<NSArray<NSNumber *> *> *)spectra;

@end

NS_ASSUME_NONNULL_END
