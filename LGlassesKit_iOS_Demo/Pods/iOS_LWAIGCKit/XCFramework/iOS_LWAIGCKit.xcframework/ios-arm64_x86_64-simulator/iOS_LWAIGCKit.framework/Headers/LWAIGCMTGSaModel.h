//
//  LWAIGCMTGSaModel.h
//  FissionBluetooth
//
//  Created by LINWEAR on 2025-03-15.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class LWAIGCMTGMmsModel;
@class LWAIGCMTGQasModel;
@class LWAIGCMTGCsModel;
@class LWAIGCMTGSuModel;

/// 摘要总结
@interface LWAIGCMTGSaModel : NSObject

/// 创建任务时生成的TaskId
@property (nonatomic, copy) NSString *TaskId;

/// 摘要结果对象，可能包含0个或多个不同摘要类型的结果
@property (nonatomic, strong) LWAIGCMTGSuModel *Summarization;

@end


/// 摘要结果
@interface LWAIGCMTGSuModel : NSObject

/// 全文摘要结果
@property (nonatomic, copy) NSString *ParagraphSummary;

/// 全文摘要标题
@property (nonatomic, copy) NSString *ParagraphTitle;

/// 发言总结摘要结果列表
@property (nonatomic, strong) NSArray <LWAIGCMTGCsModel *> *ConversationalSummary;

/// 问答回顾摘要结果列表
@property (nonatomic, strong) NSArray <LWAIGCMTGQasModel *> *QuestionsAnsweringSummary;

/// 思维导图结果列表
@property (nonatomic, strong) NSArray <LWAIGCMTGMmsModel *> *MindMapSummary;

@end


/// 发言总结摘要结果
@interface LWAIGCMTGCsModel : NSObject

/// 发言人id
@property (nonatomic, copy) NSString *SpeakerId;

/// 自定义发言人名称(自定义字段，一般为nil，为方便模型转换处理)
@property (nonatomic, copy) NSString *CustomSpeakerName;

/// 该发言人对应的总结
@property (nonatomic, copy) NSString *Summary;

@end


/// 问答回顾摘要结果
@interface LWAIGCMTGQasModel : NSObject

/// 问题
@property (nonatomic, copy) NSString *Question;

/// 提炼出该问题对应的原语音转写的SentenceId列表
@property (nonatomic, strong) NSArray <NSNumber *> *SentenceIdsOfQuestion;

/// 问题对应的答案
@property (nonatomic, copy) NSString *Answer;

///总结出该答案对应的原语音转写的SentenceId列表
@property (nonatomic, strong) NSArray <NSNumber *> *SentenceIdsOfAnswer;

@end


/// 思维导图结果
@interface LWAIGCMTGMmsModel : NSObject

/// 思维导图单个节点的文本内容
@property (nonatomic, copy) NSString *Title;

/// 思维导图单个节点的子节点列表
@property (nonatomic, strong) NSArray <LWAIGCMTGMmsModel *> *Topic;

@end

NS_ASSUME_NONNULL_END
