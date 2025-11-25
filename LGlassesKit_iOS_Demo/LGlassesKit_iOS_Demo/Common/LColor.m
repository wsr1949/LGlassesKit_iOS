//
//  LColor.m
//  LGlassesKit_iOS_Demo
//
//  Created by LINWEAR on 2025-11-24.
//

#import "LColor.h"

@implementation LColor

+ (UIColor *)textColor {
    return [UIColor colorWithDynamicProvider:^UIColor * _Nonnull(UITraitCollection * _Nonnull traitCollection) {
        return traitCollection.userInterfaceStyle == UIUserInterfaceStyleDark ? UIColor.whiteColor : UIColor.blackColor;
    }];
}

@end
