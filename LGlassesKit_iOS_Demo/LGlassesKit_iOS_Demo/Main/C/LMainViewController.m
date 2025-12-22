//
//  LMainViewController.m
//  LGlassesKit_iOS_Demo
//
//  Created by LINWEAR on 2025-09-20.
//

#import "LMainViewController.h"
#import "LMainHeaderView.h"
#import "LScanDeviceViewController.h"
#import "LMediaListViewController.h"
#import "LAIVoiceAssistantViewController.h"
#import "LAITranslationViewController.h"
#import "LOtaUpgradeViewController.h"

@interface LMainViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray <NSString *> *dataSource;

/// 连接
@property (nonatomic, strong) UIButton *connectButton;
/// 媒体数量
@property (nonatomic, assign) NSInteger mediaCount;

@property (nonatomic, assign) BOOL charging;
@property (nonatomic, assign) int battery;
@property (nonatomic, strong) LDeviceVersionModel *versionModel;

@end

static NSString *const LMainCellID = @"UITableViewCell";
static NSString *const LMainHeaderID = @"LMainHeaderView";
static NSString *const LMainFooterID = @"LMainFooterView";

@implementation LMainViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self reloadConnectView];
    
    RLMOtaDeviceModel *otaModel = RLMOtaDeviceModel.allObjects.lastObject;
    if (otaModel) {
        /// 确认是否恢复ota升级
        LWEAKSELF
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"恢复OTA升级" message:@"检测到有未完成的OTA设备，是否恢复？" preferredStyle:UIAlertControllerStyleAlert];
        
        //添加取消按钮
        UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
        [alertController addAction:cancel];
        
        //添加恢复按钮
        UIAlertAction *confirm = [UIAlertAction actionWithTitle:@"恢复" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            // 前往ota升级
            LOtaUpgradeViewController *vc = LOtaUpgradeViewController.new;
            [weakSelf.navigationController pushViewController:vc animated:YES];
        }];
        [alertController addAction:confirm];
        
        //显示
        [self presentViewController:alertController animated:YES completion:nil];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // 注册眼镜👓SDK
    [LGlassesKit registerDelegate:self enableLog:YES];
    
    
    UIView *titleView = UIView.new;
    UIButton *connectButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [connectButton setTitleColor:LTextColor forState:UIControlStateNormal];
    [connectButton setImage:UIImageMake(@"ic_disconnect") forState:UIControlStateNormal];
    [connectButton setImage:UIImageMake(@"ic_connect") forState:UIControlStateSelected];
    [titleView addSubview:connectButton];
    [connectButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    self.connectButton = connectButton;
    // 连接状态
    self.navigationItem.titleView = titleView;
    
    
    // 扫描/断开
    LWEAKSELF
    [self addRightBarButtonItem:@"扫描/断开" itemEvent:^{
        RLMDeviceModel *deviceModel = RLMDeviceModel.allObjects.lastObject;
        if (deviceModel) {
            // 断开蓝牙设备
            [LGlassesKit disconnectDevice];
            // 断开Wi-Fi热点
            [LGlassesKit disconnectWiFiHotspot];
            // 断开智能体
            [LAIGC disconnectAgentWebSocket];
            // 删除设备记录
            [deviceModel deleteObject];
            // 删除ota设备记录
            [RLMOtaDeviceModel.allObjects.lastObject deleteObject];
            // 刷新
            [weakSelf reloadConnectView];
        } else {
            // 扫描设备
            LScanDeviceViewController *vc = [LScanDeviceViewController new];
            [weakSelf.navigationController pushViewController:vc animated:YES];
        }
    }];
    
    
    // 列表
    UITableView *tableView = [ATools mainTableView:self style:UITableViewStylePlain cellIds:@[LMainCellID] headerFooterIds:@[LMainHeaderID, LMainFooterID]];
    [self.view addSubview:tableView];
    self.tableView = tableView;
    
    // 加载数据源
    [self loadDataSource];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    [self.tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.safeAreaInsets);
    }];
}

#pragma mark - 刷新连接状态
- (void)reloadConnectView
{
    NSString *deviceName = [RLMDeviceModel.allObjects.lastObject deviceName];
    [self.connectButton setTitle:IF_NULL(deviceName) ? @"无设备" : deviceName  forState:UIControlStateNormal];
    self.connectButton.selected = [LGlassesKit bleConnectStatus] == LBleStatusConnected;
    
    [self.tableView reloadData];
}

#pragma mark - 加载数据源
- (void)loadDataSource
{
    self.dataSource = @[
        @"设置系统时间",
        @"设置LED亮度",
        @"设置录像时长",
        @"佩戴检测设置",
        @"设置语音唤醒",
        @"设置快捷手势功能",
        @"重置快捷手势功能",
        @"设置久坐提醒",
        @"重启设备",
        @"恢复出厂设置",
        @"获取设备电量",
        @"开启拍照（只拍照）",
        @"开启拍照（拍照并返回）",
        @"照片拍摄模式",
        @"设置拍摄方向",
        @"开启录像",
        @"停止录像",
        @"开启录音",
        @"停止录音",
        @"获取设备控制参数",
        @"获取设备版本",
        @"打开Wi-Fi热点",
        @"获取当前文件(缩略图)数量",
        @"🤖AI语音助手",
        @"🔁AI翻译",
        @"🚀OTA升级",
        @"设置离线语音语种",
    ];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - UITableViewDelegate, UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSource.count;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (self.mediaCount > 0 && LGlassesKit.bleConnectStatus == LBleStatusConnected) {
        LMainHeaderView *header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:LMainHeaderID];
        [header reloadCount:self.mediaCount callback:^{
            // 打开Wi-Fi热点
            // @note Wi-Fi热点成功打开后名称会通过委托代理LDelegate返回 详@link notifyWifiHotspotName:
            [LHUD showLoading:nil];
            [LGlassesKit openWifiHotspotWithCallback:^(NSError * _Nullable error) {
                [LHUD showText:[NSString stringWithFormat:@"打开Wi-Fi热点 %@", error]];
                LNetworkManage.sharedInstance.networkMode = LNetworkMode_Download;
            }];
        }];
        return header;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (self.mediaCount > 0 && LGlassesKit.bleConnectStatus == LBleStatusConnected) {
        return UITableViewAutomaticDimension;
    }
    return 0.1;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if (LGlassesKit.bleConnectStatus == LBleStatusConnected) {
        LMainFooterView *footer = [tableView dequeueReusableHeaderFooterViewWithIdentifier:LMainFooterID];
        [footer reloadBattery:self.battery charging:self.charging version:self.versionModel];
        return footer;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (LGlassesKit.bleConnectStatus == LBleStatusConnected) {
        return UITableViewAutomaticDimension;
    }
    return 0.1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:LMainCellID forIndexPath:indexPath];
    if (indexPath.row < self.dataSource.count) {
        cell.textLabel.text = self.dataSource[indexPath.row];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    LWEAKSELF
    NSString *title = self.dataSource[indexPath.row];
    
    if ([title isEqualToString:@"设置系统时间"]) {
        [LGlassesKit setSystemTimeWithCallback:^(NSError * _Nullable error) {
            [LHUD showText:[NSString stringWithFormat:@"设置系统时间 %@", error]];
        }];
    }
    else if ([title isEqualToString:@"设置LED亮度"]) {
        [LGlassesKit setLEDBrightness:LLedBrightnessMedium callback:^(NSError * _Nullable error) {
            [LHUD showText:[NSString stringWithFormat:@"设置LED亮度 %@", error]];
        }];
    }
    else if ([title isEqualToString:@"设置录像时长"]) {
        [LGlassesKit setVideoRecordingDuration:60 callback:^(NSError * _Nullable error) {
            [LHUD showText:[NSString stringWithFormat:@"设置录像时长 %@", error]];
        }];
    }
    else if ([title isEqualToString:@"佩戴检测设置"]) {
        [LGlassesKit setWearDetection:YES callback:^(NSError * _Nullable error) {
            [LHUD showText:[NSString stringWithFormat:@"佩戴检测设置 %@", error]];
        }];
    }
    else if ([title isEqualToString:@"设置语音唤醒"]) {
        [LGlassesKit setVoiceWakeUp:YES callback:^(NSError * _Nullable error) {
            [LHUD showText:[NSString stringWithFormat:@"设置语音唤醒 %@", error]];
        }];
    }
    else if ([title isEqualToString:@"设置快捷手势功能"]) {
        [LGlassesKit setGesturesAction:LGestureActionSwipeBackward event:LGestureEventVolumeUp callback:^(NSError * _Nullable error) {
            [LHUD showText:[NSString stringWithFormat:@"设置快捷手势功能 %@", error]];
        }];
    }
    else if ([title isEqualToString:@"重置快捷手势功能"]) {
        [LGlassesKit resetGesturesActionWithCallback:^(NSError * _Nullable error) {
            [LHUD showText:[NSString stringWithFormat:@"重置快捷手势功能 %@", error]];
        }];
    }
    else if ([title isEqualToString:@"设置久坐提醒"]) {
        [LGlassesKit setSedentaryReminderTime:10 callback:^(NSError * _Nullable error) {
            [LHUD showText:[NSString stringWithFormat:@"设置久坐提醒 %@", error]];
        }];
    }
    else if ([title isEqualToString:@"重启设备"]) {
        [LGlassesKit setRestartDeviceWithCallback:^(NSError * _Nullable error) {
            [LHUD showText:[NSString stringWithFormat:@"重启设备 %@", error]];
        }];
    }
    else if ([title isEqualToString:@"恢复出厂设置"]) {
        [LGlassesKit setFactoryResetWithCallback:^(NSError * _Nullable error) {
            [LHUD showText:[NSString stringWithFormat:@"恢复出厂设置 %@", error]];
        }];
    }
    else if ([title isEqualToString:@"获取设备电量"]) {
        [LGlassesKit getDeviceBatteryWithCallback:^(LBatteryModel * _Nullable batteryModel, NSError * _Nullable error) {
            [LHUD showText:[NSString stringWithFormat:@"获取设备电量 %d（%@）", batteryModel.battery, error]];
            weakSelf.charging = batteryModel.charging;
            weakSelf.battery = batteryModel.battery;
            [weakSelf.tableView reloadData];
        }];
    }
    else if ([title isEqualToString:@"开启拍照（只拍照）"]) {
        [LGlassesKit startTakingPhotos:LPhotoType_OnlyTakePhotos callback:^(NSError * _Nullable error) {
            [LHUD showText:[NSString stringWithFormat:@"开启拍照 %@", error]];
        }];
    }
    else if ([title isEqualToString:@"开启拍照（拍照并返回）"]) {
        // 成功拍照后图片会通过委托代理LDelegate返回 详@link notifyAIRecognizePhotoData:
        [LGlassesKit startTakingPhotos:LPhotoType_PhotoRecognition callback:^(NSError * _Nullable error) {
            [LHUD showText:[NSString stringWithFormat:@"开启拍照 %@", error]];
        }];
    }
    else if ([title isEqualToString:@"照片拍摄模式"]) {
        [LGlassesKit setPhotoShootingMode:LPhotoMode_Standard callback:^(NSError * _Nullable error) {
            [LHUD showText:[NSString stringWithFormat:@"照片拍摄模式 %@", error]];
        }];
    }
    else if ([title isEqualToString:@"设置拍摄方向"]) {
        [LGlassesKit setShootingDirection:LShootingDirection_Horizontal callback:^(NSError * _Nullable error) {
            [LHUD showText:[NSString stringWithFormat:@"设置拍摄方向 %@", error]];
        }];
    }
    else if ([title isEqualToString:@"开启录像"]) {
        [LGlassesKit startVideoRecordingWithCallback:^(NSError * _Nullable error) {
            [LHUD showText:[NSString stringWithFormat:@"开启录像 %@", error]];
        }];
    }
    else if ([title isEqualToString:@"停止录像"]) {
        [LGlassesKit stopVideoRecordingWithCallback:^(NSError * _Nullable error) {
            [LHUD showText:[NSString stringWithFormat:@"停止录像 %@", error]];
        }];
    }
    else if ([title isEqualToString:@"开启录音"]) {
        [LGlassesKit startAudioRecordingWithCallback:^(NSError * _Nullable error) {
            [LHUD showText:[NSString stringWithFormat:@"开启录音 %@", error]];
        }];
    }
    else if ([title isEqualToString:@"停止录音"]) {
        [LGlassesKit stopAudioRecordingWithCallback:^(NSError * _Nullable error) {
            [LHUD showText:[NSString stringWithFormat:@"停止录音 %@", error]];
        }];
    }
    else if ([title isEqualToString:@"获取设备控制参数"]) {
        [LGlassesKit getDeviceControlParamWithCallback:^(LDeviceControlParamModel * _Nullable deviceModel, NSError * _Nullable error) {
            [LHUD showText:[NSString stringWithFormat:@"获取设备控制参数 %@", error]];
        }];
    }
    else if ([title isEqualToString:@"获取设备版本"]) {
        [LGlassesKit getDeviceVersionWithCallback:^(LDeviceVersionModel * _Nullable deviceModel, NSError * _Nullable error) {
            [LHUD showText:[NSString stringWithFormat:@"获取设备版本 %@", error]];
            if (!error) {
                weakSelf.versionModel = deviceModel;
                [weakSelf.tableView reloadData];
            }
        }];
    }
    else if ([title isEqualToString:@"打开Wi-Fi热点"]) {
        // @note Wi-Fi热点成功打开后名称会通过委托代理LDelegate返回 详@link notifyWifiHotspotName:
        [LGlassesKit openWifiHotspotWithCallback:^(NSError * _Nullable error) {
            [LHUD showText:[NSString stringWithFormat:@"打开Wi-Fi热点 %@", error]];
            LNetworkManage.sharedInstance.networkMode = LNetworkMode_None;
        }];
    }
    else if ([title isEqualToString:@"获取当前文件(缩略图)数量"]) {
        [LGlassesKit getThumbnailsCountWithCallback:^(NSError * _Nullable error) {
            [LHUD showText:[NSString stringWithFormat:@"获取当前文件(缩略图)数量 %@", error]];
        }];
    }
    else if ([title isEqualToString:@"🤖AI语音助手"]) {
        LAIVoiceAssistantViewController *vc = LAIVoiceAssistantViewController.new;
        [self.navigationController pushViewController:vc animated:YES];
    }
    else if ([title isEqualToString:@"🔁AI翻译"]) {
        LAITranslationViewController *vc = LAITranslationViewController.new;
        [self.navigationController pushViewController:vc animated:YES];
    }
    else if ([title isEqualToString:@"🚀OTA升级"]) {
        LOtaUpgradeViewController *vc = LOtaUpgradeViewController.new;
        [self.navigationController pushViewController:vc animated:YES];
    }
    else if ([title isEqualToString:@"设置离线语音语种"]) {
        [LGlassesKit setOfflineVoiceLanguage:LOfflineVoiceLanguage_zh callback:^(NSError * _Nullable error) {
            [LHUD showText:[NSString stringWithFormat:@"设置离线语音语种 %@", error]];
        }];
    }
}


#pragma mark - LGlassesKitDelegate

/// 日志
- (void)notifySdkLog:(NSString *)logText
{
    NSLog(@"%@", logText);
}

/// 中心蓝牙状态
- (void)centralBluetoothStatus:(CBManagerState)status
{
    if (status == CBManagerStatePoweredOn) {
        RLMDeviceModel *deviceModel = RLMDeviceModel.allObjects.lastObject;
        if (!IF_NULL(deviceModel.deviceUUID)) { // 有连接记录主动连接一下
            [LGlassesKit connectingDevice:deviceModel.deviceUUID timeout:60];
        }
    }
}

/// BLE连接状态
- (void)bleConnectionStatus:(LBleStatus)status error:(NSError *)error
{
    [self reloadConnectView];
    
    // 通知连接状态
    [NSNotificationCenter.defaultCenter postNotificationName:LScanDeviceConnectionStatusNotifi object:@(status)];
    
    if (status == LBleStatusConnected) { // 已连接，所有命令交互在此回调后才可进行
        
        [LHUD showText:@"连接成功"];
        
        LWEAKSELF
        // 1.设置系统时间
        [LGlassesKit setSystemTimeWithCallback:^(NSError * _Nullable error) {
            // do something...
        }];
        
        // 2.获取设备电量
        [LGlassesKit getDeviceBatteryWithCallback:^(LBatteryModel * _Nullable batteryModel, NSError * _Nullable error) {
            if (!error) { // 仅电量
                weakSelf.battery = batteryModel.battery;
                weakSelf.charging = batteryModel.charging;
                [weakSelf.tableView reloadData];
            }
        }];
        
        // 3.获取当前文件(缩略图)数量
        // @note 获取成功后数量会通过委托代理LDelegate返回 详@link notifyThumbnailsCount:
        [LGlassesKit getThumbnailsCountWithCallback:^(NSError * _Nullable error) {
            // do something...
        }];
        
        // 4.获取设备版本
        [LGlassesKit getDeviceVersionWithCallback:^(LDeviceVersionModel * _Nullable deviceModel, NSError * _Nullable error) {
            // do something...
            if (!error) {
                weakSelf.versionModel = deviceModel;
                [weakSelf.tableView reloadData];
            }
        }];
        
        // 其他需要的业务...
        
        
        // 注册AI🤖SDK
        [LAIGC registerAIGC];
        // 连接智能体
        [LAIGC connectAgentWebSocket];
    }
    else if (status == LBleStatusDisconnect) {
        [LHUD showText:@"连接断开"];
        // 断开智能体
        [LAIGC disconnectAgentWebSocket];
    }
    else if (status == LBleStatusConnectionFailed) {
        [LHUD showText:[NSString stringWithFormat:@"连接失败：%@", error]];
    }
}

/// 每次拍照或录像成功，通知缩略图数量
- (void)notifyThumbnailsCount:(NSInteger)count
{
    self.mediaCount = count;
    
    [self.tableView reloadData];
}

/// 通知Wi-Fi热点名称
- (void)notifyWifiHotspotName:(NSString *)wifiHotspotName
{
    // 连接Wi-Fi热点
    // @note 连接结果通过委托代理LDelegate返回 详@link wifiHotspotConnectionStatus:error:
    [LGlassesKit connectingWiFiHotspot:wifiHotspotName];
}

/// Wi-Fi热点连接状态
- (void)wifiHotspotConnectionStatus:(LWiFiHotspotStatus)status error:(NSError *)error
{
    LWEAKSELF
    
    if (status == LWiFiHotspotStatusConnected) {
        [LHUD showText:@"Wi-Fi热点连接成功"];
        
        LNetworkMode networkMode = LNetworkManage.sharedInstance.networkMode;
        
        if (networkMode == LNetworkMode_Download) {
            // 开始下载文件
            [LNetworkManage.sharedInstance downloadFileWithCallback:^(NSArray<LDownloadFile *> * _Nonnull files)
             {
                LNetworkManage.sharedInstance.networkMode = LNetworkMode_None;
                
                LMediaListViewController *vc = LMediaListViewController.new;
                vc.files = files;
                [weakSelf.navigationController pushViewController:vc animated:YES];
            }];
        }
        else if (networkMode == LNetworkMode_Upload) {
            // 开始上传文件
            [NSNotificationCenter.defaultCenter postNotificationName:LIspUpgradeNotifyKey object:nil];
        }
    }
    else if (status == LWiFiHotspotStatusDisconnect) {
        [LHUD showText:@"Wi-Fi热点连接断开"];
    }
    else if (status == LWiFiHotspotStatusConnectionFailed) {
        [LHUD showText:[NSString stringWithFormat:@"Wi-Fi热点连接失败：%@", error]];
    }
}

/// 通知设备电池电量信息
- (void)notifyDeviceBatteryInfo:(LBatteryModel *)batteryModel
{
    self.charging = batteryModel.charging;
    self.battery = batteryModel.battery;
    [self.tableView reloadData];
}

/// 通知AI语音助手状态
- (void)notifyAIVoiceAssistantStatus:(BOOL)activated
{
    if (activated) { // 已唤醒
        [LAIGC startRecording];
    }
}

/// 通知语音数据
- (void)notifyVoiceData:(NSData *)voiceData
{
    [LAIGC sendAudioData:voiceData]; // 发送语音
}

/// 通知AI识图照片数据
- (void)notifyAIRecognizePhotoData:(NSData *)photoData error:(NSError *)error
{
    if (error) {
        [LHUD showText:error.localizedDescription];
    }
    else if (photoData.length)
    {
        [LAIGC requestUploadImageData:photoData]; // 上传图片开始识图
    }
}

/// 通知拍照状态
- (void)notifyDevicePhotoTakingStatus:(BOOL)activated
{
    NSLog(@"通知拍照状态: %@", activated ? @"开始拍照" : @"结束拍照");
}

/// 通知录音状态
- (void)notifyAudioRecordingStatus:(BOOL)activated
{
    NSLog(@"通知录音状态: %@", activated ? @"开始录音" : @"停止录音");
}

/// 通知录像状态
- (void)notifyVideoRecordingStatus:(BOOL)activated
{
    NSLog(@"通知录像状态: %@", activated ? @"开始录像" : @"停止录像");
}
 
/// 通知设备佩戴状态
- (void)notifyDeviceWearingStatus:(BOOL)wearing
{
    NSLog(@"通知设备佩戴状态: %@", wearing ? @"已佩戴" : @"未佩戴");
}

@end
