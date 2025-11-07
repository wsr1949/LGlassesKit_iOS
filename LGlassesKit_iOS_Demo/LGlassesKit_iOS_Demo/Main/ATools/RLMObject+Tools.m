//
//  RLMObject+Tools.m
//  LGlassesKit_iOS_Demo
//
//  Created by LINWEAR on 2025-10-14.
//

#import "RLMObject+Tools.h"

@implementation RLMObject (Tools)

/// 保存or更新
- (void)saveOrUpdateObject
{
    RLMRealm *realm = RLMRealm.defaultRealm;
    [realm transactionWithBlock:^{
        [realm addOrUpdateObject:self];
    }];
}

/// 删除
- (void)deleteObject
{
    RLMRealm *realm = RLMRealm.defaultRealm;
    [realm transactionWithBlock:^{
        [realm deleteObject:self];
    }];
}

@end
