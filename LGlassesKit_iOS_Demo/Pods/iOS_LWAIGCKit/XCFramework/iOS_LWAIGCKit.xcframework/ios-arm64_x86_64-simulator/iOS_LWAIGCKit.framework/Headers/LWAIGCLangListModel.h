//
//  LWAIGCLangListModel.h
//  iOS_LWAIGCKit
//
//  Created by LINWEAR on 2026-01-28.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LWAIGCLangListModel : NSObject

/// 语言码
@property (nonatomic, copy) NSString *code;

/// 语言ID
@property (nonatomic, assign) NSInteger langType;

/// 语言名称（中文）
@property (nonatomic, copy) NSString *name;

/// 语言名称（英文）
@property (nonatomic, copy) NSString *nameEn;

/// 源语言是否支持
@property (nonatomic, assign) BOOL supportSource;

/// 目标语言是否支持
@property (nonatomic, assign) BOOL supportTarget;

@end

NS_ASSUME_NONNULL_END
