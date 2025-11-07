//
//  LDownloadFile.m
//  LGlassesKit_iOS_Demo
//
//  Created by LINWEAR on 2025-11-07.
//

#import "LDownloadFile.h"

@implementation LDownloadFile

/// 下载文件
+ (void)downloadFileWithCallback:(LDownloadFileCallback)callback
{
    [LDownloadFile requestFileList:callback];
}

/// 1.获取文件列表
+ (void)requestFileList:(LDownloadFileCallback)callback
{
    [LHUD showLoading:@"获取文件列表"];
    /// 获取文件列表
    [LGlassesKit requestFileListWithCallback:^(NSArray<LFileModel *> * _Nullable list, NSError * _Nullable error) {
        if (error) {
            [LHUD showText:error.localizedDescription];
            // 断开
            [LDownloadFile disconnectWiFi:0];
        } else {
            [LHUD showText:[NSString stringWithFormat:@"获取文件列表 个数%ld", list.count]];
            if (list.count) {
                // 下载文件
                [LDownloadFile downloadFile:list index:0 downloadCount:0 files:NSMutableArray.array callback:callback];
            } else {
                // 断开
                [LDownloadFile disconnectWiFi:0];
            }
        }
    }];
}

/// 2.下载文件
+ (void)downloadFile:(NSArray<LFileModel *> *)list
               index:(NSInteger)index
       downloadCount:(NSInteger)downloadCount
               files:(NSMutableArray <LDownloadFile *> *)files
            callback:(LDownloadFileCallback)callback
{
    NSInteger total = list.count;
    if (index < total) {
        
        LFileModel *fileModel = list[index];
        
        [LHUD showLoading:@"下载文件"];
        
        [LGlassesKit downloadFile:fileModel.name progressCallback:^(double progress, double speed) {
            
            NSString *speedString = nil;
            if (speed < 1024) {
                speedString = [NSString stringWithFormat:@"%.0f B/s", speed];
            } else if (speed < 1024 * 1024) {
                speedString = [NSString stringWithFormat:@"%.1f KB/s", speed / 1024];
            } else {
                speedString = [NSString stringWithFormat:@"%.1f MB/s", speed / (1024 * 1024)];
            }
            
            [LHUD showProgress:progress/100.0 text:[NSString stringWithFormat:@"%.0f%% - %@", progress, speedString]];
            
        } completeCallback:^(NSData * _Nullable data, NSError * _Nullable error) {
            
            if (!error && data.length)
            { // 下载成功
                NSURL *cachesDirectoryUrl = [[NSFileManager defaultManager] URLForDirectory:NSCachesDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:NO error:nil];
                NSURL *fileUrl = [cachesDirectoryUrl URLByAppendingPathComponent:[NSString stringWithFormat:@"%ld_%@", fileModel.timecode, fileModel.name]];
                
                if ([data writeToURL:fileUrl options:NSDataWritingAtomic error:&error]) {
                    
                    LDownloadFile *model = LDownloadFile.new;
                    model.fileModel = fileModel;
                    model.fileUrl = fileUrl;
                    
                    [files addObject:model];
                    
                    // 删除
                    [LDownloadFile deleteFile:fileModel.path callback:^(NSError * _Nullable error) {

                        [LDownloadFile downloadFile:list index:index+1 downloadCount:(error ? downloadCount : downloadCount+1) files:files callback:callback];
                    }];
                    
                } else {
                    // 失败，跳过...下载下一个
                    [LDownloadFile downloadFile:list index:index+1 downloadCount:downloadCount files:files callback:callback];
                }
            }
            else {
                // 失败，跳过...下载下一个
                [LDownloadFile downloadFile:list index:index+1 downloadCount:downloadCount files:files callback:callback];
            }
        }];
    }
    else {
        [LHUD dismiss];
        // 断开
        [LDownloadFile disconnectWiFi:downloadCount];
        // 完成回调
        GCD_MAIN_QUEUE(^{
            if (callback) callback(files.copy);
        });
    }
}

/// 3.删除文件
+ (void)deleteFile:(NSString *)path callback:(void(^)(NSError * error))callback
{
    [LGlassesKit deleteFile:path callback:callback];
}

/// 4.上报下载数量
+ (void)disconnectWiFi:(NSInteger)downloadCount
{
    // 上报...断电
    [LGlassesKit reportFileDownloadsCount:downloadCount callback:^(NSError * _Nullable error) {
        //...
    }];
    // 断开Wi-Fi
    [LGlassesKit disconnectWiFiHotspot];
}

@end
