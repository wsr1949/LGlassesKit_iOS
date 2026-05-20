//
//  LAssistantModel.h
//  LGlassesKit_iOS_Demo
//
//  Created by LINWEAR on 2025-10-29.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, LAssistantType) {
    LAssistantType_AssistantText,
    LAssistantType_UserText,
    LAssistantType_UserImage,
};

@interface LAssistantModel : NSObject

/// 类型
@property (nonatomic, assign) LAssistantType assistantType;

/// 消息ID
@property (nonatomic, copy) NSString *messageId;

/// 文本
@property (nonatomic, copy) NSString *param;

@end

NS_ASSUME_NONNULL_END
