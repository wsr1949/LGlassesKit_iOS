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
    
    // Wi-Fi连接成功
    [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(ispUpgradeNotify) name:LIspUpgradeNotifyKey object:nil];
}

- (void)ispUpgradeNotify
{
    /// 开始isp升级
    [self startIspUpgradeWithFilePath:self.fileLabel.text];
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
    UIAlertAction *ota = [UIAlertAction actionWithTitle:@"OTA升级" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [weakSelf startOtaUpgradeWithFilePath:weakSelf.fileLabel.text];
    }];
    [alertController addAction:ota];
    
    //添加ISP按钮
    UIAlertAction *isp = [UIAlertAction actionWithTitle:@"ISP升级" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        /// 打开Wi-Fi
        if (LGlassesKit.wifiHotspotStatus == LWiFiHotspotStatusConnected) {
            [weakSelf startIspUpgradeWithFilePath:weakSelf.fileLabel.text];
        } else {
            [weakSelf openWiFi];
        }
    }];
    [alertController addAction:isp];
    
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
{
    self.otaButton.enabled = NO;
    
    LWEAKSELF
    [LGlassesKit startOtaUpgradeWithFilePath:filePath preparingProgressCallback:^(double progress) {
        
        weakSelf.progressView.hidden = NO;
        weakSelf.progressView.progress = progress/100.0;
        weakSelf.progressLabel.hidden = NO;
        weakSelf.progressLabel.text = [NSString stringWithFormat:@"%.0f%%", progress];
        weakSelf.statusLabel.hidden = NO;
        weakSelf.statusLabel.textColor = LTextColor;
        weakSelf.statusLabel.text = @"OTA文件检验中";
        
    } upgradeProgressCallback:^(double progress) {
        
        weakSelf.progressView.progress = progress/100.0;
        weakSelf.progressLabel.text = [NSString stringWithFormat:@"%.0f%%", progress];
        weakSelf.statusLabel.text = @"OTA升级中";
        
    } upgradeResultCallback:^(NSError * _Nullable error) {
        
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
        }
        
        weakSelf.otaButton.enabled = YES;
    }];
}

/// 打开Wi-Fi
- (void)openWiFi
{
    // 打开Wi-Fi热点
    // @note Wi-Fi热点成功打开后名称会通过委托代理LDelegate返回 详@link notifyWifiHotspotName:
    [LHUD showLoading:nil];
    [LGlassesKit openWifiHotspotWithCallback:^(NSError * _Nullable error) {
        [LHUD showText:[NSString stringWithFormat:@"打开Wi-Fi热点 %@", error]];
        LNetworkManage.sharedInstance.networkMode = LNetworkMode_Upload;
    }];
}

/// 开始isp升级
- (void)startIspUpgradeWithFilePath:(NSString *)filePath
{
    self.otaButton.enabled = NO;
    
    LWEAKSELF
    [LGlassesKit startIspUpgradeWithFilePath:filePath upgradeProgressCallback:^(double progress) {
        
        weakSelf.progressView.hidden = NO;
        weakSelf.progressView.progress = progress/100.0;
        weakSelf.progressLabel.hidden = NO;
        weakSelf.progressLabel.text = [NSString stringWithFormat:@"%.0f%%", progress];
        weakSelf.statusLabel.hidden = NO;
        weakSelf.statusLabel.textColor = LTextColor;
        weakSelf.statusLabel.text = @"ISP升级中";
        
    } upgradeResultCallback:^(NSError * _Nullable error) {
        
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
        }
        
        // 断开Wi-Fi
        [LGlassesKit disconnectWiFiHotspot];
        
        weakSelf.otaButton.enabled = YES;
    }];
}


- (void)dealloc {
    [NSNotificationCenter.defaultCenter removeObserver:self];
}

@end
