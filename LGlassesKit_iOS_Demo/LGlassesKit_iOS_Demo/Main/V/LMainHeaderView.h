//
//  LMainHeaderView.h
//  LGlassesKit_iOS_Demo
//
//  Created by LINWEAR on 2025-10-21.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^LMainHeaderViewCallback)(void);

@interface LMainHeaderView : UITableViewHeaderFooterView

- (void)reloadCount:(NSInteger)count callback:(LMainHeaderViewCallback)callback;

@end

NS_ASSUME_NONNULL_END
