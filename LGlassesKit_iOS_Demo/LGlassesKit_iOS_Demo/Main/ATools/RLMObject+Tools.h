//
//  RLMObject+Tools.h
//  LGlassesKit_iOS_Demo
//
//  Created by LINWEAR on 2025-10-14.
//

#import <Realm/Realm.h>

NS_ASSUME_NONNULL_BEGIN

@interface RLMObject (Tools)

/// 保存or更新
- (void)saveOrUpdateObject;

/// 删除
- (void)deleteObject;

@end

NS_ASSUME_NONNULL_END
