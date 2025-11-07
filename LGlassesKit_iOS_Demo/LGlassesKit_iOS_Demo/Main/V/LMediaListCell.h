//
//  LMediaListCell.h
//  LGlassesKit_iOS_Demo
//
//  Created by LINWEAR on 2025-11-07.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface LMediaListCell : UICollectionViewCell

- (void)reloadModel:(LDownloadFile *)fileModel;

@end

NS_ASSUME_NONNULL_END
