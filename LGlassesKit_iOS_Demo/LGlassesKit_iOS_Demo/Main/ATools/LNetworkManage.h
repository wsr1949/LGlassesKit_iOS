//
//  LNetworkManage.h
//  LGlassesKit_iOS_Demo
//
//  Created by LINWEAR on 2025-11-25.
//

#import <Foundation/Foundation.h>
@class LDownloadFile;

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, LNetworkMode) {
    LNetworkMode_None,
    LNetworkMode_Download,
    LNetworkMode_Upload,
};

typedef void(^LDownloadFileCallback)(NSArray <LDownloadFile *> * files);

@interface LNetworkManage : NSObject

/// 单例
+ (LNetworkManage *)sharedInstance;

@property (nonatomic, assign) LNetworkMode networkMode;

/// 下载文件
- (void)downloadFileWithCallback:(LDownloadFileCallback)callback;

@end


@interface LDownloadFile : NSObject

@property (nonatomic, strong) LFileModel *fileModel;
@property (nonatomic, copy) NSURL *fileUrl;

/**
 下载文件
 1.获取文件列表
 2.下载文件
 3.删除文件
 4.上报下载数量
 */
+ (void)downloadFileWithCallback:(LDownloadFileCallback)callback;

@end

NS_ASSUME_NONNULL_END
