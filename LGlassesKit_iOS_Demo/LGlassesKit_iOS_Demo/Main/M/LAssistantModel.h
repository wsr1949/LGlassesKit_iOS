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

@property (nonatomic, assign) LAssistantType assistantType;

@property (nonatomic, copy) NSString *param;

@property (nonatomic, assign) BOOL isAdd;

@end

NS_ASSUME_NONNULL_END
