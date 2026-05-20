//
//  LOtaUpgradeViewController.m
//  LGlassesKit_iOS_Demo
//
//  Created by LINWEAR on 2025-11-24.
//

#import "LOtaUpgradeViewController.h"
#import <UniformTypeIdentifiers/UniformTypeIdentifiers.h>

@interface LOtaUpgradeViewController () <UIDocumentPickerDelegate>

@property (nonatomic, strong) UILabel *fileLabel;
@property (nonatomic, strong) UIProgressView *progressView;
@property (nonatomic, strong) UILabel *progressLabel;
@property (nonatomic, strong) UILabel *statusLabel;
@property (nonatomic, strong) UIButton *otaButton;

@end

@implementation LOtaUpgradeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"🚀OTA升级";
    
    LWEAKSELF
    [self addRightBarButtonItem:@"选择文件" itemEvent:^{
        [weakSelf presentDocumentPickerViewController];
    }];
    
    
    UILabel *fileLabel = [UILabel new];
    fileLabel.text = @"请选择文件";
    fileLabel.textColor = LTextColor;
    fileLabel.font = UIFontMake(16);
    fileLabel.numberOfLines = 0;
    [self.view addSubview:fileLabel];
    self.fileLabel = fileLabel;
    
    
    UIProgressView *progressView = [UIProgressView new];
    progressView.progressTintColor = UIColor.systemGreenColor;
    progressView.trackTintColor = UIColor.lightGrayColor;
    progressView.hidden = YES;
    [self.view addSubview:progressView];
    self.progressView = progressView;
    
    
    UILabel *progressLabel = [UILabel new];
    progressLabel.textColor = LTextColor;
    progressLabel.font = UIFontMake(16);
    progressLabel.textAlignment = NSTextAlignmentRight;
    progressLabel.hidden = YES;
    [self.view addSubview:progressLabel];
    self.progressLabel = progressLabel;
    
    
    UILabel *statusLabel = [UILabel new];
    statusLabel.textColor = LTextColor;
    statusLabel.font = UIFontBoldMake(18);
    statusLabel.textAlignment = NSTextAlignmentCenter;
    statusLabel.numberOfLines = 0;
    statusLabel.hidden = YES;
    [self.view addSubview:statusLabel];
    self.statusLabel = statusLabel;
    
    
    UIButton *otaButton = [UIButton buttonWithType:UIButtonTypeCustom];
    otaButton.backgroundColor = UIColor.systemGreenColor;
    otaButton.titleLabel.font = UIFontBoldMake(16);
    [otaButton setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
    [otaButton setTitle:@"🚀OTA升级" forState:UIControlStateNormal];
    otaButton.enabled = NO;
    [self.view addSubview:otaButton];
    [ATools addAction:otaButton callback:^{
        [weakSelf selectUpgradeType];
    }];
    self.otaButton = otaButton;
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];

    UIEdgeInsets safeAreaInsets = self.safeAreaInsets;
    CGFloat top = safeAreaInsets.top + 30;
    CGFloat left = safeAreaInsets.left + 30;
    CGFloat right = safeAreaInsets.right + 30;
    CGFloat bottom = safeAreaInsets.bottom;
    
    [self.fileLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(top);
        make.left.mas_equalTo(left);
        make.right.mas_equalTo(-right);
    }];
    
    [self.progressView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.fileLabel.mas_bottom).offset(30);
        make.left.mas_equalTo(left);
        make.right.mas_equalTo(-right-60);
    }];
    
    [self.progressLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.progressView.mas_centerY);
        make.left.mas_equalTo(self.progressView.mas_right);
        make.right.mas_equalTo(self.fileLabel.mas_right);
    }];
    
    [self.statusLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.progressLabel.mas_bottom).offset(10);
        make.left.mas_equalTo(self.fileLabel.mas_left);
        make.right.mas_equalTo(self.fileLabel.mas_right);
    }];
    
    [self.otaButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(-bottom);
        make.left.mas_equalTo(left);
        make.right.mas_equalTo(-right);
        make.height.mas_equalTo(50);
    }];
}

     
- (void)presentDocumentPickerViewController
{
    UTType *binType = [UTType typeWithFilenameExtension:@"bin"];
    UTType *ufwType = [UTType typeWithFilenameExtension:@"ufw"];
    
    UIDocumentPickerViewController *documentPickerViewController = [[UIDocumentPickerViewController alloc] initForOpeningContentTypes:@[binType, ufwType]];
    documentPickerViewController.delegate = self;
    [self presentViewController:documentPickerViewController animated:YES completion:nil];
}

#pragma mark - UIDocumentPickerDelegate

- (void)documentPicker:(UIDocumentPickerViewController *)controller didPickDocumentsAtURLs:(NSArray <NSURL *>*)urls
{
    NSURL *url = urls.firstObject;
    
    //开启文件权限
    BOOL permission = [url startAccessingSecurityScopedResource];
    if (permission) {
        // 通过文件协调工具来得到新的文件地址，以此得到文件保护功能
        NSFileCoordinator *fileCoordinator = [[NSFileCoordinator alloc] init];
        __block NSError *error;
        LWEAKSELF
        [fileCoordinator coordinateReadingItemAtURL:url options:NSFileCoordinatorReadingWithoutChanges error:&error byAccessor:^(NSURL * _Nonnull newURL) {
            
            // 获取临时目录
            NSString *tempDir = NSTemporaryDirectory();
            NSString *fileName = [newURL lastPathComponent];
            NSURL *tempURL = [NSURL fileURLWithPath:[tempDir stringByAppendingPathComponent:fileName]];
            
            // 删除已存在的文件
            NSFileManager *fileManager = [NSFileManager defaultManager];
            if ([fileManager fileExistsAtPath:tempURL.path]) {
                [fileManager removeItemAtURL:tempURL error:nil];
            }
            
            // 复制文件到临时目录
            BOOL success = [fileManager copyItemAtURL:newURL toURL:tempURL error:&error];
            if (success) {
                weakSelf.fileLabel.text = tempURL.path;
                weakSelf.otaButton.enabled = !IF_NULL(tempURL.path);
            } else {
                [LHUD showText:[NSString stringWithFormat:@"文件复制失败 %@", error]];
            }
        }];
        
        //关闭文件权限
        [url stopAccessingSecurityScopedResource];
        
        if (error) [LHUD showText:error.localizedDescription];
    }
    else {
        [LHUD showText:@"没有文件权限"];
    }
}

- (void)selectUpgradeType
{
    LWEAKSELF
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"升级类型" message:@"请选择升级类型，OTA是ble升级，ISP是Wi-Fi升级（需要先打开并连接Wi-Fi热点）" preferredStyle:UIAlertControllerStyleActionSheet];
    
    //添加取消按钮
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [alertController addAction:cancel];
        
    //添加OTA按钮
    UIAlertAction *ota = [UIAlertAction actionWithTitle:@"OTA升级（⚠️蓝牙为.ufw文件）" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        RLMOtaDeviceModel *otaModel = RLMOtaDeviceModel.allObjects.lastObject;
        if (otaModel) {
            /// 确认是否恢复ota升级
            [weakSelf confirmRestoreOtaUpgrade:weakSelf.fileLabel.text isRestoreUpgrade:YES restoreReconnectMethod:otaModel.reconnectMethod restoreReconnectDevice:otaModel.reconnectDevice];
        } else {
            /// 开始ota升级🚀
            [weakSelf startOtaUpgradeWithFilePath:weakSelf.fileLabel.text isRestoreUpgrade:NO restoreReconnectMethod:LOtaUpgradeReconnectMethod_None restoreReconnectDevice:nil];
        }
    }];
    [alertController addAction:ota];
    
    //添加ISP按钮
    UIAlertAction *isp = [UIAlertAction actionWithTitle:@"ISP升级（⚠️Wi-Fi为.bin文件）" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        // 确定ISP版本号
        [weakSelf confirmIspVersion];
    }];
    [alertController addAction:isp];
    
    //显示
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)confirmIspVersion
{
    LWEAKSELF
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"ISP版本号" message:@"请确定此次升级的ISP版本号" preferredStyle:UIAlertControllerStyleAlert];
    
    //添加取消按钮
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [alertController addAction:cancel];
    
    // 添加文本输入框
    [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        textField.placeholder = @"ISP版本号，格式如 1.2.3";
        textField.autocapitalizationType = UITextAutocapitalizationTypeWords;
    }];
    
    //添加确定按钮
    UIAlertAction *confirm = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSString *ispVersion = alertController.textFields.firstObject.text;
        if (IF_NULL(ispVersion)) {
            [LHUD showText:@"请确定ISP版本号"];
        } else {
            /// 开始isp升级🚀
            [weakSelf startIspUpgradeWithFilePath:weakSelf.fileLabel.text ispVersion:ispVersion];
        }
    }];
    [alertController addAction:confirm];
    
    //显示
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)confirmRestoreOtaUpgrade:(NSString *)filePath
                isRestoreUpgrade:(BOOL)isRestoreUpgrade
          restoreReconnectMethod:(LOtaUpgradeReconnectMethod)restoreReconnectMethod
          restoreReconnectDevice:(NSString *)restoreReconnectDevice
{
    LWEAKSELF
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"恢复OTA升级" message:@"检测到有未完成的OTA设备，是否恢复？" preferredStyle:UIAlertControllerStyleAlert];
    
    //添加取消按钮
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [alertController addAction:cancel];
    
    //添加恢复按钮
    UIAlertAction *confirm = [UIAlertAction actionWithTitle:@"恢复" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        // 开始ota升级
        [weakSelf startOtaUpgradeWithFilePath:filePath isRestoreUpgrade:isRestoreUpgrade restoreReconnectMethod:restoreReconnectMethod restoreReconnectDevice:restoreReconnectDevice];
    }];
    [alertController addAction:confirm];
    
    //显示
    [self presentViewController:alertController animated:YES completion:nil];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

/// 开始ota升级
- (void)startOtaUpgradeWithFilePath:(NSString *)filePath
                   isRestoreUpgrade:(BOOL)isRestoreUpgrade
             restoreReconnectMethod:(LOtaUpgradeReconnectMethod)restoreReconnectMethod
             restoreReconnectDevice:(NSString *)restoreReconnectDevice
{
    self.otaButton.enabled = NO;
    
    LWEAKSELF
    [LHUD showLoading:nil];
    [LGlassesKit startOtaUpgradeWithFilePath:filePath isRestoreUpgrade:isRestoreUpgrade restoreReconnectMethod:restoreReconnectMethod restoreReconnectDevice:restoreReconnectDevice preparingProgressCallback:^(double progress) {
        [LHUD dismiss];
        
        weakSelf.progressView.hidden = NO;
        weakSelf.progressView.progress = progress/100.0;
        weakSelf.progressLabel.hidden = NO;
        weakSelf.progressLabel.text = [NSString stringWithFormat:@"%.0f%%", progress];
        weakSelf.statusLabel.hidden = NO;
        weakSelf.statusLabel.textColor = LTextColor;
        weakSelf.statusLabel.text = @"OTA文件检验中";
        
    } reconnectCallback:^(LOtaUpgradeReconnectMethod reconnectMethod, NSString * _Nonnull reconnectDevice) {
        [LHUD dismiss];
        
        // ⚠️OTA文件检验通过后，设备进入OTA模式，正在回连OTA模式的设备...
        /**
         ‼️由于芯片设计缘故，应用必须在此记录这个回连方式和设备，已应对一些升级异常场景：
         ⚠️例如 升级过程中app被kill或crash，重新打开app是无法正常回连设备的，因为设备处于ota模式，需要根据这个回连方式和设备来重新恢复ota
         ⚠️ota成功/失败：再移除记录
         */
        NSLog(@"回连方式 %lu 设备 %@", reconnectMethod, reconnectDevice);
        RLMDeviceModel *deviceModel = RLMDeviceModel.allObjects.lastObject;
        
        RLMOtaDeviceModel *otaModel = [RLMOtaDeviceModel new];
        otaModel.deviceMac = deviceModel.deviceMac;
        otaModel.reconnectMethod = reconnectMethod;
        otaModel.reconnectDevice = reconnectDevice;
        [otaModel saveOrUpdateObject];
        
    } upgradeProgressCallback:^(double progress) {
        [LHUD dismiss];
        
        weakSelf.progressView.hidden = NO;
        weakSelf.progressView.progress = progress/100.0;
        weakSelf.progressLabel.hidden = NO;
        weakSelf.progressLabel.text = [NSString stringWithFormat:@"%.0f%%", progress];
        weakSelf.statusLabel.hidden = NO;
        weakSelf.statusLabel.textColor = LTextColor;
        weakSelf.statusLabel.text = @"OTA升级中";
        
    } upgradeResultCallback:^(NSError * _Nullable error) {
        [LHUD dismiss];
        
        if (error) {
            weakSelf.progressView.hidden = YES;
            weakSelf.progressLabel.hidden = YES;
            weakSelf.statusLabel.hidden = NO;
            weakSelf.statusLabel.textColor = UIColor.systemRedColor;
            weakSelf.statusLabel.text = [NSString stringWithFormat:@"OTA升级失败: %@", error.localizedDescription];
        } else {
            weakSelf.progressView.hidden = YES;
            weakSelf.progressLabel.hidden = YES;
            weakSelf.statusLabel.hidden = NO;
            weakSelf.statusLabel.textColor = UIColor.systemGreenColor;
            weakSelf.statusLabel.text = @"OTA升级成功";
            
            [RLMOtaDeviceModel.allObjects.lastObject deleteObject];
        }
        
        weakSelf.otaButton.enabled = YES;
        
    } restartCallback:^{
        // ⚠️设备正在重启...
    }];
}

/// 开始isp升级
- (void)startIspUpgradeWithFilePath:(NSString *)filePath ispVersion:(NSString *)ispVersion
{
    self.otaButton.enabled = NO;
    
    LWEAKSELF
    [LHUD showLoading:nil];
    [LGlassesKit startIspUpgradeWithFilePath:filePath ispVersion:ispVersion upgradeProgressCallback:^(double progress) {
        [LHUD dismiss];
        
        weakSelf.progressView.hidden = NO;
        weakSelf.progressView.progress = progress/100.0;
        weakSelf.progressLabel.hidden = NO;
        weakSelf.progressLabel.text = [NSString stringWithFormat:@"%.0f%%", progress];
        weakSelf.statusLabel.hidden = NO;
        weakSelf.statusLabel.textColor = LTextColor;
        weakSelf.statusLabel.text = @"ISP升级中";
        
    } upgradeResultCallback:^(NSError * _Nullable error) {
        [LHUD dismiss];
        
        if (error) {
            weakSelf.progressView.hidden = YES;
            weakSelf.progressLabel.hidden = YES;
            weakSelf.statusLabel.hidden = NO;
            weakSelf.statusLabel.textColor = UIColor.systemRedColor;
            weakSelf.statusLabel.text = [NSString stringWithFormat:@"ISP升级失败: %@", error.localizedDescription];
        } else {
            weakSelf.progressView.hidden = YES;
            weakSelf.progressLabel.hidden = YES;
            weakSelf.statusLabel.hidden = NO;
            weakSelf.statusLabel.textColor = UIColor.systemGreenColor;
            weakSelf.statusLabel.text = @"ISP升级成功";
            
            // 重新获取一下版本号
            [LGlassesKit getDeviceVersionWithCallback:^(LDeviceVersionModel * _Nullable deviceModel, NSError * _Nullable error) {
                if (!error) {
                    NSString *string = [NSString stringWithFormat:@"当前 isp 版本号 %@", deviceModel.ispVersion];
                    [LHUD showText:string];
                }
            }];
        }
        
        weakSelf.otaButton.enabled = YES;
        
    }];
}


- (void)dealloc {
    [NSNotificationCenter.defaultCenter removeObserver:self];
}

@end
