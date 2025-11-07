//
//  LWAIGCMTGQryModel.h
//  FissionBluetooth
//
//  Created by LINWEAR on 2025-03-18.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class LWAIGCMTGQryItem;

@interface LWAIGCMTGQryModel : NSObject

/// 请求唯一会话ID
@property (nonatomic, copy) NSString *convId;

/// 当前分页
@property (nonatomic, assign) NSInteger page;

/// 当前分页大小
@property (nonatomic, assign) NSInteger pageSize;

/// 总页数
@property (nonatomic, assign) NSInteger total;

/// 列表
@property (nonatomic, strong, nullable) NSArray <LWAIGCMTGQryItem *> *list;

/// 错误
@property (nonatomic, strong, nullable) NSError *error;

@end


@interface LWAIGCMTGQryItem : NSObject

/// 任务创建时间
@property (nonatomic, assign) NSInteger createTime;

/// 任务完成时间
@property (nonatomic, assign) NSInteger completeTime;

/// 客户端确认时间
@property (nonatomic, assign) NSInteger ackTime;

/// 任务ID
@property (nonatomic, copy) NSString *taskId;

/// 会议原始音频URL
@property (nonatomic, copy) NSString *meetingOriginFile;

/// 会议纪要Zip URL (处理的结果)
@property (nonatomic, copy, nullable) NSString *meetingZipFile;

/// 会议纪要 - 标题 （未处理成功，则统一返回空字符串）
@property (nonatomic, copy, nullable) NSString *meetingTitle;

/// 会议纪要 - 大纲（未处理成功，则统一返回空字符串）
@property (nonatomic, copy, nullable) NSString *meetingSummary;

/// 设备ID
@property (nonatomic, copy) NSString *deviceId;

/// 设备名称
@property (nonatomic, copy) NSString *deviceName;

/// 设备型号
@property (nonatomic, copy) NSString *deviceModel;

/// 客户端请求唯一标识符
@property (nonatomic, copy) NSString *userAgent;

/// 任务状态
@property (nonatomic, assign) LWAIGCMTGTASKSTATUS taskStatus;

/// 任务失败原因，正常则返回为空
@property (nonatomic, copy, nullable) NSString *errorMsg;

/// 音频录制时间【单位：秒】
@property (nonatomic, assign) NSInteger recordTime;

/// 音频录制时长【单位：毫秒】
@property (nonatomic, assign) NSInteger recordDuration;

/// 关键词
@property (nonatomic, strong, nullable) NSArray <NSString *> *keyWords;

/// wss监听地址
@property (nonatomic, copy) NSString *wss;



/// 请求唯一会话ID（仅主动查询时有效）
@property (nonatomic, copy) NSString *convId;

/// 错误（仅主动查询时有效）
@property (nonatomic, strong, nullable) NSError *error;

@end

NS_ASSUME_NONNULL_END
