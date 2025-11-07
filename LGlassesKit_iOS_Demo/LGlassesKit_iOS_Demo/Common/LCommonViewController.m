//
//  LCommonViewController.m
//  LGlassesKit_iOS_Demo
//
//  Created by LINWEAR on 2025-09-20.
//

#import "LCommonViewController.h"

typedef void(^LNavigationItemEvent)(void);

@interface LCommonViewController ()

@property (nonatomic, copy) LNavigationItemEvent rightItemEvent;

@end

@implementation LCommonViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = UIColor.whiteColor;
}

/// 添加单个导航栏右按钮
- (void)addRightBarButtonItem:(NSString *)title itemEvent:(void (^)(void))itemEvent
{
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:title style:UIBarButtonItemStylePlain target:self action:@selector(rightItemActionEvent)];
    self.rightItemEvent = itemEvent;
}
/// 导航栏右按钮响应事件
- (void)rightItemActionEvent
{
    if (self.rightItemEvent) {
        self.rightItemEvent();
    }
}

/// 安全区域
- (UIEdgeInsets)safeAreaInsets
{
    return self.view.safeAreaInsets;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)dealloc {
    NSLog(@"- - - - - - %@ dealloc - - - - - -", self.class);
}

@end
