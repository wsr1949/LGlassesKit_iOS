//
//  LWAIGCMTGSttModel.h
//  FissionBluetooth
//
//  Created by LINWEAR on 2025-03-15.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class LWAIGCMTGPaModel;
@class LWAIGCMTGWrModel;
@class LWAIGCMTGTrModel;

/// 语音转写
@interface LWAIGCMTGSttModel : NSObject

/// 创建任务时生成的TaskId
@property (nonatomic, copy) NSString *TaskId;

/// 语音转写结果对象
@property (nonatomic, strong) LWAIGCMTGTrModel *Transcription;

@end


/// 音频转写结果
@interface LWAIGCMTGTrModel : NSObject

/// 语音转写结构以段落形式组织的集合
@property (nonatomic, strong) NSArray <LWAIGCMTGPaModel *> *Paragraphs;

/// 有效音频片断范围，单位为毫秒；索引0有效音频片段的开始时间，索引1有效音频片段的结束时间
@property (nonatomic, strong) NSArray <NSArray <NSNumber *> *> *AudioSegments;

@end


/// 音频转写结构，段落形式
@interface LWAIGCMTGPaModel : NSObject

/// 段落级别id
@property (nonatomic, copy) NSString *ParagraphId;

/// 发言人id
@property (nonatomic, copy) NSString *SpeakerId;

/// 自定义发言人名称(自定义字段，一般为nil，为方便模型转换处理)
@property (nonatomic, copy) NSString *CustomSpeakerName;

/// 该段落包含的word信息
@property (nonatomic, strong) NSArray <LWAIGCMTGWrModel *> *Words;

@end


/// 段落包含的word
@interface LWAIGCMTGWrModel : NSObject

/// word序号，通常无须关注
@property (nonatomic, assign) NSUInteger Id;

/// 句子id，同属于一个SentenceId的word信息可以组装成一句话
@property (nonatomic, assign) NSUInteger SentenceId;

/// 该word相对于音频起始时间的开始时间，相对时间戳，单位毫秒
@property (nonatomic, assign) NSUInteger Start;

/// 该word相对于音频起始时间的结束时间，相对时间戳，单位毫秒
@property (nonatomic, assign) NSUInteger End;

/// word文本
@property (nonatomic, copy) NSString *Text;

@end

NS_ASSUME_NONNULL_END
