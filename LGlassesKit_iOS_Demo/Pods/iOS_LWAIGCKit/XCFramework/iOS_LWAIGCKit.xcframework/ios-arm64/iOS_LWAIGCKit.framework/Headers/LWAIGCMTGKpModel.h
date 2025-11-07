//
//  LWAIGCMTGKpModel.h
//  FissionBluetooth
//
//  Created by LINWEAR on 2025-03-15.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class LWAIGCMTGAuModel;
@class LWAIGCMTGKsModel;
@class LWAIGCMTGMaModel;

/// 要点提炼
@interface LWAIGCMTGKpModel : NSObject

/// 创建任务时生成的TaskId
@property (nonatomic, copy) NSString *TaskId;

/// 要点提炼结果对象，可能包含0个或多个不同类型的结果
@property (nonatomic, strong) LWAIGCMTGMaModel *MeetingAssistance;

@end


/// 要点提炼结果对象
@interface LWAIGCMTGMaModel : NSObject

/// 音频信息
@property (nonatomic, strong) LWAIGCMTGAuModel *AudioInfo;

/// 关键词提取结果
@property (nonatomic, strong) NSArray <NSString *> *Keywords;

/// 关键句提取结果，也称为重点内容
@property (nonatomic, strong) NSArray <LWAIGCMTGKsModel *> *KeySentences;

/// 待办内容、待办摘要的集合
@property (nonatomic, strong) NSArray <LWAIGCMTGKsModel *> *Actions;

@end


/// 音频信息
@interface LWAIGCMTGAuModel : NSObject

/// 录制时间，单位秒
@property (nonatomic, assign) NSUInteger RecordTime;

/// 录制时长，单位毫秒
@property (nonatomic, assign) NSUInteger RecordDuration;

/// 音频大小，单位：字节
@property (nonatomic, assign) NSUInteger Size;

/// 音频时长，单位：毫秒
@property (nonatomic, assign) NSUInteger Duration;

/// 音频采样率
@property (nonatomic, assign) NSUInteger SampleRate;

/// 思维导图 Web Url
@property (nonatomic, copy) NSString *MindMapPath;

/// 音频语种（multilingual表示多种类型混合）
@property (nonatomic, copy) NSString *Language;

@end


/// 要点提炼结果对象
@interface LWAIGCMTGKsModel : NSObject

/// 关键句序号
@property (nonatomic, assign) NSUInteger Id;

/// 该关键句在原ASR转写中对应的句子Id
@property (nonatomic, assign) NSUInteger SentenceId;

/// 相对于音频起始时间的开始时间，相对时间戳，单位毫秒
@property (nonatomic, assign) NSUInteger Start;

/// 相对于音频起始时间的结束时间，相对时间戳，单位毫秒
@property (nonatomic, assign) NSUInteger End;

/// 关键句信息
@property (nonatomic, copy) NSString *Text;

@end

NS_ASSUME_NONNULL_END
