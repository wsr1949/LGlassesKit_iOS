//
//  LAudioWaveformView.m
//  LGlassesKit_iOS_Demo
//
//  Created by LINWEAR on 2025-12-03.
//

#import "LAudioWaveformView.h"

@interface LAudioWaveformView ()

@property (nonatomic, strong) CAGradientLayer *leftGradientLayer; //左声道layer
@property (nonatomic, strong) CAGradientLayer *rightGradientLayer; //右声道layer

@end

@implementation LAudioWaveformView

- (instancetype)init {
    if (self = [super init]) {
        self.backgroundColor = UIColor.systemBackgroundColor;
        [self configInit];
        [self.layer addSublayer:self.rightGradientLayer];
        [self.layer addSublayer:self.leftGradientLayer];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self configInit];
}

- (void)configInit {
    CGFloat barSpace = self.frame.size.width / (CGFloat)(80 * 3 - 1);
    self.barWidth = barSpace * 2;
    self.space = barSpace;
    self.bottomSpace = 0;
    self.topSpace = 0;
}

#pragma mark - public method
- (void)updateSpectra:(NSArray *)spectra {
    if (spectra.count == 0) return;
    [CATransaction begin];
    [CATransaction setDisableActions:YES];
    UIBezierPath *leftPath = [UIBezierPath bezierPath];
    NSUInteger count = [spectra.firstObject count];
    for (int i = 0; i < count; i++) {
        CGFloat x = (CGFloat)i * (self.barWidth + self.space) + self.space;
        CGFloat y = [self translateAmplitudeToYPosition:[spectra[0][i] floatValue]];
        CGRect rect = CGRectMake(x, y, self.barWidth, CGRectGetHeight(self.bounds) - self.bottomSpace -y);
        UIBezierPath *bar = [UIBezierPath bezierPathWithRect:rect];
        [leftPath appendPath:bar];
    }
    
    CAShapeLayer *leftMaskLayer = [CAShapeLayer layer];
    leftMaskLayer.path = leftPath.CGPath;
    self.leftGradientLayer.frame = CGRectMake(0, self.topSpace, CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds) - self.topSpace - self.bottomSpace);
    self.leftGradientLayer.mask = leftMaskLayer;
    
    if (spectra.count >= 2) {
        UIBezierPath *rightPath = [UIBezierPath bezierPath];
        count = [spectra[1] count];
        for (int i = 0; i < count; i++) {
            CGFloat x = (CGFloat)(count - 1 - i) * (self.barWidth + self.space) + self.space;
            CGFloat y = [self translateAmplitudeToYPosition:[spectra[1][i] floatValue]];
            CGRect rect = CGRectMake(x, y, self.barWidth, CGRectGetHeight(self.bounds) - self.bottomSpace -y);
            UIBezierPath *bar = [UIBezierPath bezierPathWithRect:rect];
            [rightPath appendPath:bar];
        }
        CAShapeLayer *rightMaskLayer = [CAShapeLayer layer];
        rightMaskLayer.path = rightPath.CGPath;
        self.rightGradientLayer.frame = CGRectMake(0, self.topSpace, CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds) - self.topSpace - self.bottomSpace);
        self.rightGradientLayer.mask = rightMaskLayer;
    }
    [CATransaction commit];
}

#pragma mark - private method
- (CGFloat)translateAmplitudeToYPosition:(float)amplitude {
    CGFloat barHeight = (CGFloat)amplitude * (CGRectGetHeight(self.bounds) - self.bottomSpace - self.topSpace);
    return CGRectGetHeight(self.bounds) - self.bottomSpace - barHeight;
}

- (CAGradientLayer *)leftGradientLayer {
    if (!_leftGradientLayer) {
        _leftGradientLayer = [CAGradientLayer layer];
        _leftGradientLayer.colors = @[(id)[UIColor colorWithRed:235/255.0 green:18/255.0 blue:26/255.0 alpha:1.0].CGColor, (id)[UIColor colorWithRed:255/255.0 green:165/255.0 blue:0/255.0 alpha:1.0].CGColor];
        _leftGradientLayer.locations = @[@0.6, @1.0];
    }
    return _leftGradientLayer;
}

- (CAGradientLayer *)rightGradientLayer {
    if (!_rightGradientLayer) {
        _rightGradientLayer = [CAGradientLayer layer];
        _rightGradientLayer.colors = @[(id)[UIColor colorWithRed:0/255.0 green:128/255.0 blue:128/255.0 alpha:1.0].CGColor, (id)[UIColor colorWithRed:52/255.0 green:232/255.0 blue:158/255.0 alpha:1.0].CGColor];
        _rightGradientLayer.locations = @[@0.6, @1.0];
    }
    return _rightGradientLayer;
}

@end
