//
//  LCommonNavigationController.m
//  LGlassesKit_iOS_Demo
//
//  Created by LINWEAR on 2025-09-22.
//

#import "LCommonNavigationController.h"

@interface LCommonNavigationController ()

@end

@implementation LCommonNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    NSDictionary *attributes = @{
        NSForegroundColorAttributeName: LTextColor,
        NSFontAttributeName: UIFontBoldMake(18)
    };
    
    [self.navigationBar setTitleTextAttributes:attributes];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
