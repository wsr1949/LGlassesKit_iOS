//
//  LWAIGCQueryListModel.h
//  FissionBluetooth
//
//  Created by LINWEAR on 2025-03-19.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LWAIGCQueryListModel : NSObject

/// 当前分页
@property (nonatomic, assign) NSInteger page;

/// 当前分页大小
@property (nonatomic, assign) NSInteger pageSize;

/// 请求唯一会话ID，有默认值
@property (nonatomic, copy) NSString *convId;

/// 用户ID
@property (nonatomic, copy, nullable) NSString *uuid;

@end

NS_ASSUME_NONNULL_END
