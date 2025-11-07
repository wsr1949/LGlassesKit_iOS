//
//  LWAIGCMTGTocModel.h
//  FissionBluetooth
//
//  Created by LINWEAR on 2025-03-15.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class LWAIGCMTGAcsModel;

/// 章节速览
@interface LWAIGCMTGTocModel : NSObject

/// 创建任务时生成的TaskId
@property (nonatomic, copy) NSString *TaskId;

/// 章节速览集合， 含有0个、1个或多个章节速览信息
@property (nonatomic, strong) NSArray <LWAIGCMTGAcsModel *> *AutoChapters;

@end


/// 章节速览集合
@interface LWAIGCMTGAcsModel : NSObject

/// 该章节序号
@property (nonatomic, assign) NSUInteger Id;

/// 该章节相对于音频起始时间的开始时间，相对时间戳，单位毫秒
@property (nonatomic, assign) NSUInteger Start;

/// 该章节相对于音频起始时间的结束时间，相对时间戳，单位毫秒
@property (nonatomic, assign) NSUInteger End;

/// 该章节的一句话标题
@property (nonatomic, copy) NSString *Headline;

/// 章节总结
@property (nonatomic, copy) NSString *Summary;

@end

NS_ASSUME_NONNULL_END
