//
//  LDeviceSeriesPopoverController.m
//  LGlassesKit_iOS_Demo
//
//  Created by LINWEAR on 2026-07-14.
//

#import "LDeviceSeriesPopoverController.h"

@interface LDeviceSeriesPopoverController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, assign) LDeviceSeries selectedSeries;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray <NSNumber *> *seriesList;
@property (nonatomic, strong) NSArray <NSString *> *titleList;

@end

static NSString *const LDeviceSeriesCellID = @"LDeviceSeriesCell";

@implementation LDeviceSeriesPopoverController

- (instancetype)initWithSelectedSeries:(LDeviceSeries)selectedSeries {
    if (self = [super initWithNibName:nil bundle:nil]) {
        self.selectedSeries = selectedSeries;
        self.seriesList = @[@(LDeviceSeries_S), @(LDeviceSeries_T)];
        self.titleList = @[@"S系列", @"T系列"];
        self.preferredContentSize = CGSizeMake(160, 88);
        self.modalPresentationStyle = UIModalPresentationPopover;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = UIColor.systemBackgroundColor;
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.scrollEnabled = NO;
    tableView.separatorInset = UIEdgeInsetsMake(0, 16, 0, 16);
    tableView.rowHeight = 44;
    [tableView registerClass:UITableViewCell.class forCellReuseIdentifier:LDeviceSeriesCellID];
    [self.view addSubview:tableView];
    [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
    self.tableView = tableView;
}

#pragma mark - UITableViewDelegate, UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.seriesList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:LDeviceSeriesCellID forIndexPath:indexPath];
    cell.textLabel.font = UIFontMake(16);
    cell.textLabel.textColor = LTextColor;
    cell.textLabel.text = self.titleList[indexPath.row];
    
    LDeviceSeries series = (LDeviceSeries)[self.seriesList[indexPath.row] integerValue];
    cell.accessoryType = (series == self.selectedSeries) ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone;
    cell.tintColor = UIColor.systemBlueColor;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    LDeviceSeries series = (LDeviceSeries)[self.seriesList[indexPath.row] integerValue];
    self.selectedSeries = series;
    [tableView reloadData];
    
    if (self.selectionCallback) {
        self.selectionCallback(series);
    }
}

@end
