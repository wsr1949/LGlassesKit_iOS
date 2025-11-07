//
//  LWAIGCMTGDetailsModel.h
//  FissionBluetooth
//
//  Created by LINWEAR on 2025-03-17.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LWAIGCMTGDetailsModel : NSObject

/// 创建任务时生成的TaskId
@property (nonatomic, copy) NSString *TaskId;

/// 语音转写原始json数据
@property (nonatomic, strong) NSData *sttData;;
/// 语音转写模型
@property (nonatomic, strong) LWAIGCMTGSttModel *sttModel;

/// 摘要总结原始json数据
@property (nonatomic, strong) NSData *saData;;
/// 摘要总结
@property (nonatomic, strong) LWAIGCMTGSaModel *saModel;

/// 要点提炼原始json数据
@property (nonatomic, strong) NSData *kpData;;
/// 要点提炼
@property (nonatomic, strong) LWAIGCMTGKpModel *kpModel;

/// 章节速览原始json数据
@property (nonatomic, strong) NSData *tocData;;
/// 章节速览
@property (nonatomic, strong) LWAIGCMTGTocModel *tocModel;

@end

NS_ASSUME_NONNULL_END
