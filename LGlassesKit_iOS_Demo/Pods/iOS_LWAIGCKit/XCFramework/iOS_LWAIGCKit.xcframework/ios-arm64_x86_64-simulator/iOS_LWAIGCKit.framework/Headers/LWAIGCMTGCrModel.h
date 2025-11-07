//
//  LWAIGCMTGCrModel.h
//  FissionBluetooth
//
//  Created by LINWEAR on 2025-03-15.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/// 会议纪要任务创建结果
@interface LWAIGCMTGCrModel : NSObject

/// 任务ID
@property (nonatomic, copy, nullable) NSString *taskId;

/// 会议原始音频URL
@property (nonatomic, copy, nullable) NSString *meetingOriginFile;

/// web socket地址，用以监听任务回调
@property (nonatomic, copy, nullable) NSString *wss;

/// 请求唯一会话ID
@property (nonatomic, copy) NSString *convId;

/// 错误
@property (nonatomic, strong, nullable) NSError *error;

@end

NS_ASSUME_NONNULL_END
