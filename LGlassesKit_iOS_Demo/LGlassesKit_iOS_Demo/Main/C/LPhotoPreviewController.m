//
//  LPhotoPreviewController.m
//  LGlassesKit_iOS_Demo
//
//  Created by LINWEAR on 2025-10-27.
//

#import "LPhotoPreviewController.h"

@interface LPhotoPreviewController ()

@property (nonatomic, copy) NSString *filePath;

@property (nonatomic, strong) UIImageView *imgView;

@end

@implementation LPhotoPreviewController

- (instancetype)initWithFilePath:(NSString *)filePath {
    if (self = [super init]) {
        self.filePath = filePath;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"照片预览";
    
    UIImage *img = [UIImage imageWithContentsOfFile:self.filePath];
    UIImageView *imgView = [[UIImageView alloc] initWithImage:img];
    imgView.contentMode = UIViewContentModeScaleAspectFit;
    [self.view addSubview:imgView];
    self.imgView = imgView;
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    [self.imgView mas_remakeConstraints:^(MASConstraintMaker *make) {
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

@end
