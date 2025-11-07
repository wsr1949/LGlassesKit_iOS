//
//  LDownloadFile.h
//  LGlassesKit_iOS_Demo
//
//  Created by LINWEAR on 2025-11-07.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@class LDownloadFile;
typedef void(^LDownloadFileCallback)(NSArray <LDownloadFile *> * files);

@interface LDownloadFile : NSObject

/**
 下载文件
 1.获取文件列表
 2.下载文件
 3.删除文件
 4.上报下载数量
 */
+ (void)downloadFileWithCallback:(LDownloadFileCallback)callback;


@property (nonatomic, strong) LFileModel *fileModel;

@property (nonatomic, copy) NSURL *fileUrl;

@end

NS_ASSUME_NONNULL_END
