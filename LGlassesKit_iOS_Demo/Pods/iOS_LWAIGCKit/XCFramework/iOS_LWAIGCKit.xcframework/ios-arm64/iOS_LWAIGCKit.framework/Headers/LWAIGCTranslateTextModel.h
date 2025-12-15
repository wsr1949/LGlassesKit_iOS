//
//  LWAIGCTranslateTextModel.h
//  iOS_LWAIGCKit
//
//  Created by LINWEAR on 2025-12-04.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@class LWAIGCTranslateItemModel;

@interface LWAIGCTranslateTextModel : NSObject

/// 会话ID
@property (nonatomic, copy) NSString *session_id;

/// 原文
@property (nonatomic, copy) NSString *text;

/// 唯一ID
@property (nonatomic, copy) NSString *request_id;

/// 译文列表
@property (nonatomic, strong) NSArray <LWAIGCTranslateItemModel *> *trans;

@end

@interface LWAIGCTranslateItemModel : NSObject

/// 译文
@property (nonatomic, copy) NSString *translation_text;

/// 语种
@property (nonatomic, copy) NSString *language;

@end

NS_ASSUME_NONNULL_END
