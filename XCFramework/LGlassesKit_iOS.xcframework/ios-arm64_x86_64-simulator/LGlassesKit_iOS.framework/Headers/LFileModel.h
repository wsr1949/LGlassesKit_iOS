//
//  LFileModel.h
//  LGlassesKit_iOS
//
//  Created by LINWEAR on 2025-10-21.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LFileModel : NSObject

/// 文件名称
@property (nonatomic, copy) NSString *name;

/// 文件路径
@property (nonatomic, copy) NSString *path;

/// 文件大小（字节）
@property (nonatomic, assign) NSInteger size;

/// 时间戳
@property (nonatomic, assign) NSInteger timecode;

/// 时间格式化
@property (nonatomic, copy) NSString *time;

@end

NS_ASSUME_NONNULL_END
