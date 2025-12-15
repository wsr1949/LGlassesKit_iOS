//
//  LScanDeviceViewController.m
//  LGlassesKit_iOS_Demo
//
//  Created by LINWEAR on 2025-09-22.
//

#import "LScanDeviceViewController.h"
#import "LScanDeviceCell.h"

@interface LScanDeviceViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSMutableArray <LPeripheralModel *> *dataSource;

@property (nonatomic, strong) LPeripheralModel *peripheral;

@end

static NSString *const LScanDeviceCellID = @"LScanDeviceCell";

@implementation LScanDeviceViewController

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    if ([LGlassesKit centralManagerState] == CBManagerStatePoweredOn) {
        LWEAKSELF
        [LGlassesKit startScanningWithCallback:^(LPeripheralModel *peripheralModel) {
            
            // 检查重复
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"deviceMac == %@", peripheralModel.deviceMac];
            if (![weakSelf.dataSource filteredArrayUsingPredicate:predicate].count) {
                
                [weakSelf.dataSource addObject:peripheralModel];
                
                // 排序，信号由大到小
                NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"RSSI" ascending:NO];
                [weakSelf.dataSource sortUsingDescriptors:@[sortDescriptor]];
                [weakSelf.tableView reloadData];
            }
            
        } timeout:60];
    }
    else {
        [LHUD showText:@"蓝牙未打开"];
    }
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    [LGlassesKit stopScanning];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"扫描";
    
    UITableView *tableView = [ATools mainTableView:self style:UITableViewStylePlain cellIds:@[LScanDeviceCellID] headerFooterIds:nil];
    [self.view addSubview:tableView];
    self.tableView = tableView;
    
    self.dataSource = NSMutableArray.array;
    
    [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(deviceConnectionStatusNotifi:) name:LScanDeviceConnectionStatusNotifi object:nil];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    [self.tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.safeAreaInsets);
    }];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    LScanDeviceCell *cell = [tableView dequeueReusableCellWithIdentifier:LScanDeviceCellID forIndexPath:indexPath];
    if (indexPath.row < self.dataSource.count) {
        LPeripheralModel *model = self.dataSource[indexPath.row];
        cell.titLabel.text = model.deviceName;
        cell.detLabel.text = [NSString stringWithFormat:@"%@「适配号%@」", model.deviceMac, model.deviceMode];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    LPeripheralModel *peripheral = self.dataSource[indexPath.row];
    [LHUD showLoading:nil];
    self.peripheral = peripheral;
    [LGlassesKit connectingDevice:peripheral.deviceUUID timeout:60];
}

// 连接状态
- (void)deviceConnectionStatusNotifi:(NSNotification *)notifi
{
    LBleStatus status = (LBleStatus)[notifi.object integerValue];
    
    if (status == LBleStatusConnecting) {
        [LHUD showLoading:@"连接中"];
    }
    else {
        if (status == LBleStatusConnected) {
            [LHUD showText:@"已连接"];
            
            RLMDeviceModel *deviceModel = RLMDeviceModel.new;
            deviceModel.deviceName = self.peripheral.deviceName;
            deviceModel.deviceMac = self.peripheral.deviceMac;
            deviceModel.deviceMode = self.peripheral.deviceMode;
            deviceModel.deviceUUID = self.peripheral.peripheral.identifier.UUIDString;
            [deviceModel saveOrUpdateObject];
            
            [self.navigationController popViewControllerAnimated:YES];
        }
        else if (status == LBleStatusDisconnect) {
            // 连接断开
        }
        else if (status == LBleStatusConnectionFailed) {
            // 连接失败
        }
    }
}

- (void)dealloc {
    [NSNotificationCenter.defaultCenter removeObserver:self];
}

@end
