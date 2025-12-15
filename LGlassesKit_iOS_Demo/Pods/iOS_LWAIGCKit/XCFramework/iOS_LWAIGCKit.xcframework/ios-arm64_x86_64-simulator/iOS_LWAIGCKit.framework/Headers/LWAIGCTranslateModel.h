//
//  LWAIGCTranslateModel.h
//  iOS_LWAIGCKit
//
//  Created by LINWEAR on 2025-12-03.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LWAIGCTranslateModel : NSObject

/// 源语种
@property (nonatomic, assign) NSInteger from_language;

/// 目标语种列表
@property (nonatomic, strong, nonnull) NSArray <NSNumber *> *to_language_list;

/// 音频参数
@property (nonatomic, strong) LWAIGCAudioInfoModel *audioInfo;

@end

NS_ASSUME_NONNULL_END
