//
//  LCommonViewController.m
//  LGlassesKit_iOS_Demo
//
//  Created by LINWEAR on 2025-09-20.
//

#import "LCommonViewController.h"

@interface LCommonViewController ()

@end

@implementation LCommonViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = UIColor.systemBackgroundColor;
}

/// 添加单个导航栏右按钮
- (void)addRightBarButtonItem:(NSString *)title itemEvent:(void (^)(void))itemEvent
{
    UIAction *action = [UIAction actionWithTitle:title image:nil identifier:nil handler:^(__kindof UIAction * _Nonnull action) {
        GCD_MAIN_QUEUE(^{
            if (itemEvent) itemEvent();
        });
    }];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithPrimaryAction:action];
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
