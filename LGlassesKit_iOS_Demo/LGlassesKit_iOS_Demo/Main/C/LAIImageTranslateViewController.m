//
//  LAIImageTranslateViewController.m
//  LGlassesKit_iOS_Demo
//
//  Created by LINWEAR on 2026-01-26.
//

#import "LAIImageTranslateViewController.h"

@interface LAIImageTranslateViewController () <UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (nonatomic, strong) UIImageView *imgView;

@property (nonatomic, strong) UIButton *original;

@property (nonatomic, strong) UIButton *translation;

/// 支持的原语种
@property (nonatomic, strong) NSArray <LWAIGCLangListModel *> *originalLangs;
@property (nonatomic, assign) NSInteger originalSelectIndex;

/// 支持的翻译语种
@property (nonatomic, strong) NSArray <LWAIGCLangListModel *> *translateLangs;
@property (nonatomic, assign) NSInteger translateSelectIndex;

@end

@implementation LAIImageTranslateViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"图片翻译";
        
    LWEAKSELF
    [self addRightBarButtonItem:@"拍照" itemEvent:^{
        [weakSelf takePhoto];
    }];
    
    UIImageView *imgView = [UIImageView new];
    imgView.contentMode = UIViewContentModeScaleAspectFit;
    [self.view addSubview:imgView];
    self.imgView = imgView;
    
    UIButton *original = [UIButton buttonWithType:UIButtonTypeCustom];
    original.backgroundColor = UIColor.redColor;
    original.titleLabel.numberOfLines = 2;
    [original setTitle:@"选择原文" forState:UIControlStateNormal];
    [self.view addSubview:original];
    self.original = original;
    // 原文
    [ATools addAction:original callback:^{
        /// 单列文本选择器
        BRTextPickerView *textPickerView = [[BRTextPickerView alloc]initWithPickerMode:BRTextPickerComponentSingle];
        textPickerView.title = @"原文";
        // 设置数据源
        NSMutableArray *dataSourceArr = NSMutableArray.array;
        [weakSelf.originalLangs enumerateObjectsUsingBlock:^(LWAIGCLangListModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [dataSourceArr addObject:obj.name];
        }];
        textPickerView.dataSourceArr = dataSourceArr.copy;
        textPickerView.selectIndex = weakSelf.originalSelectIndex;
        textPickerView.singleResultBlock = ^(BRTextModel * _Nullable model, NSInteger index) {
              NSLog(@"选择的值：%@", model.text);
            weakSelf.originalSelectIndex = index;
            GCD_MAIN_QUEUE(^{
                [weakSelf.original setTitle:model.text forState:UIControlStateNormal];
            });
        };
        [textPickerView show];
    }];
    
    UIButton *translation = [UIButton buttonWithType:UIButtonTypeCustom];
    translation.backgroundColor = UIColor.blueColor;
    translation.titleLabel.numberOfLines = 2;
    [translation setTitle:@"选择译文" forState:UIControlStateNormal];
    [self.view addSubview:translation];
    self.translation = translation;
    // 译文
    [ATools addAction:translation callback:^{
        /// 单列文本选择器
        BRTextPickerView *textPickerView = [[BRTextPickerView alloc]initWithPickerMode:BRTextPickerComponentSingle];
        textPickerView.title = @"译文";
        // 设置数据源
        NSMutableArray *dataSourceArr = NSMutableArray.array;
        [weakSelf.translateLangs enumerateObjectsUsingBlock:^(LWAIGCLangListModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [dataSourceArr addObject:obj.name];
        }];
        textPickerView.dataSourceArr = dataSourceArr.copy;
        textPickerView.selectIndex = weakSelf.translateSelectIndex;
        textPickerView.singleResultBlock = ^(BRTextModel * _Nullable model, NSInteger index) {
              NSLog(@"选择的值：%@", model.text);
            weakSelf.translateSelectIndex = index;
            GCD_MAIN_QUEUE(^{
                [weakSelf.translation setTitle:model.text forState:UIControlStateNormal];
            });
        };
        [textPickerView show];
    }];
    
    // 请求支持的语种
    [LHUD showLoading:nil];
    [LWAIGCKit getImageTranslationLangListWithCallback:^(NSArray<LWAIGCLangListModel *> * _Nullable result, NSError * _Nullable error) {
        if (error) {
            [LHUD showText:error.localizedDescription];
        } else {
            [LHUD dismiss];
            
            /// 支持的原语种
            NSMutableArray <LWAIGCLangListModel *> *originalLangs = NSMutableArray.array;
            /// 支持的翻译语种
            NSMutableArray <LWAIGCLangListModel *> *translateLangs = NSMutableArray.array;
            
            [result enumerateObjectsUsingBlock:^(LWAIGCLangListModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                
                if (obj.supportSource) { /// 支持的原语种
                    [originalLangs addObject:obj];
                }
                if (obj.supportTarget) { /// 支持的翻译语种
                    [translateLangs addObject:obj];
                }
            }];
            
            weakSelf.originalLangs = originalLangs.copy;
            weakSelf.translateLangs = translateLangs.copy;
        }
    }];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    [self.imgView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.safeAreaInsets);
    }];
    
    [self.original mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.safeAreaInsets.top);
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(self.view.mas_centerXWithinMargins);
        make.height.mas_equalTo(50);
    }];
    
    [self.translation mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.original.mas_top);
        make.left.mas_equalTo(self.original.mas_right);
        make.right.mas_equalTo(0);
        make.height.mas_equalTo(self.original.mas_height);
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

- (void)takePhoto
{
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    picker.cameraDevice = UIImagePickerControllerCameraDeviceRear; // 后置摄像头
    picker.cameraCaptureMode = UIImagePickerControllerCameraCaptureModePhoto; // 拍照模式
    picker.showsCameraControls = YES;
    
    [self presentViewController:picker animated:YES completion:nil];
}

#pragma mark - UIImagePickerControllerDelegate

// 拍照完成
- (void)imagePickerController:(UIImagePickerController *)picker
        didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {

    UIImage *originalImage = info[UIImagePickerControllerOriginalImage];
    
    // 显示图片
    self.imgView.image = originalImage;
    
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    /**
     支持的图片格式： jpg、png
     图片大小限制：4MB
     图片尺寸限制：4096*4096
     */
    NSData *imgData = [LAIImageTranslateViewController process2048_2048_2MB_Image:originalImage]; // 2048、2MB
    
#warning - 实际请根据需要的语言设置
    NSInteger fromLanguage = self.originalLangs[self.originalSelectIndex].langType;
    NSInteger toLanguage = self.translateLangs[self.translateSelectIndex].langType;
    LWEAKSELF
    [LHUD showLoading:nil];
    [LAIGC startImageTranslationWithImageData:imgData fromLanguage:fromLanguage toLanguage:toLanguage callback:^(NSString * _Nonnull base64, NSError * _Nonnull error) {
        if (error) {
            [LHUD showText:error.localizedDescription];
        } else {
            [LHUD dismiss];
            // 返回base64图片
            NSData *data = [[NSData alloc] initWithBase64EncodedString:base64 options:0];
            UIImage *img = [UIImage imageWithData:data];
            weakSelf.imgView.image = img;
        }
    }];
}


/// 图片限制处理，2048x2048，2MB
+ (NSData *)process2048_2048_2MB_Image:(UIImage *)originalImage
{
    // 第一步：处理尺寸限制 (2048x2048)
    UIImage *resizedImage = [self resizeImageIfNeeded:originalImage maxDimension:2048]; // 这里限制为最大2048
    
    // 第二步：处理文件大小限制 (2MB)
    NSData *finalImageData = [self compressImageToSizeLimit:resizedImage maxFileSize:2 * 1024 * 1024]; // 这里限制为最大2MB
    
    return finalImageData;
}

#pragma mark - 尺寸缩放
+ (UIImage *)resizeImageIfNeeded:(UIImage *)image maxDimension:(CGFloat)maxDimension {
    CGFloat width = image.size.width;
    CGFloat height = image.size.height;
    
    // 如果图片尺寸已经在限制内，直接返回
    if (width <= maxDimension && height <= maxDimension) {
        return image;
    }
    
    // 计算缩放比例
    CGFloat scaleFactor = 0.0;
    if (width > height) {
        scaleFactor = maxDimension / width;
    } else {
        scaleFactor = maxDimension / height;
    }
    
    CGSize newSize = CGSizeMake(width * scaleFactor, height * scaleFactor);
    
    // 开始图形上下文
    UIGraphicsBeginImageContextWithOptions(newSize, NO, image.scale); // 使用原图的 scale，保持 Retina 显示正常
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *resizedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return resizedImage;
}

#pragma mark - 质量压缩（针对 JPEG）
+ (NSData *)compressImageToSizeLimit:(UIImage *)image maxFileSize:(NSUInteger)maxFileSize {
    // 初始压缩质量 (1.0 最高质量，0.0 最低质量)
    CGFloat compression = 1.0;
    NSData *imageData = UIImageJPEGRepresentation(image, compression);
    
    // 如果初始大小已经小于限制，直接返回
    if (imageData.length <= maxFileSize) {
        return imageData;
    }
    
    // 二分法查找合适的压缩质量
    CGFloat minCompression = 0.0;
    CGFloat maxCompression = 1.0;
    NSData *compressedData = imageData;
    
    // 最多尝试 10 次，避免无限循环
    for (int i = 0; i < 10; i++) {
        compression = (minCompression + maxCompression) / 2.0;
        compressedData = UIImageJPEGRepresentation(image, compression);
        
        if (compressedData.length < maxFileSize * 0.9) {
            // 如果压缩后的大小小于目标的 90%，提高质量下限
            minCompression = compression;
        } else if (compressedData.length > maxFileSize) {
            // 如果压缩后的大小仍然超过限制，降低质量上限
            maxCompression = compression;
        } else {
            // 在可接受范围内，直接退出
            break;
        }
    }
    
    // 如果最终压缩后的数据仍然大于限制（理论上应该不会，但做安全处理）
    // 可以尝试进一步降低质量，或者返回最后一次压缩的数据（根据你的业务需求决定）
    if (compressedData.length > maxFileSize) {
        // 这里作为最后手段，强制使用最低质量 0.0 再压缩一次
        compressedData = UIImageJPEGRepresentation(image, 0.0);
    }
    
    return compressedData;
}

@end
