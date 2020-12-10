//
//  ZMImageScannerViewController.m
//  ZMScan_Example
//
//  Created by Sper on 2020/12/7.
//  Copyright © 2020 wmelon. All rights reserved.
//

#import "ZMImageScannerViewController.h"
#import "ZMQuadrilateral.h"
#import <CoreImage/CoreImage.h>
#import <AVFoundation/AVFoundation.h>
#import "ZMVisionRectangleDetector.h"
#import "ZMCIRectangleDetector.h"
#import "ZMEditScanViewController.h"
#import "UIImage+ZMOrientation.h"

@interface ZMImageScannerViewController ()
@property (nonatomic, strong) UIView *blackFlashView;
@property (nonatomic, weak  ) id<ZMScannerControllerDelegate> imageScannerDelegate;
@end

@implementation ZMImageScannerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (instancetype)initWithImage:(UIImage *)image delegate:(id<ZMScannerControllerDelegate>)delegate {
    if (self = [super init]) {
        _imageScannerDelegate = delegate;
        
        [self.view addSubview:self.blackFlashView];
        
        /// 检测图片
        [self detectWithImage:image completion:^(ZMQuadrilateral *detectedQuad) {
            /// 打开编辑界面
            ZMEditScanViewController *editVc = [[ZMEditScanViewController alloc] initWithImage:image quad:detectedQuad];
            [self setViewControllers:@[editVc] animated:YES];
        }];
    }
    return self;
}

- (void)detectWithImage:(UIImage *)image completion:(void(^)(ZMQuadrilateral *detectedQuad))completion{
    CIImage *ciImage = [CIImage imageWithCGImage:image.CGImage];
    if (!ciImage) return;
    
    /// 图片方向
    CGImagePropertyOrientation orientation = [image imagePropertyOrientation];
    CIImage *orientedImage = [ciImage imageByApplyingOrientation:orientation];
    
    /// 处理图片识别
    if (@available(iOS 11.0, *)) {
        [ZMVisionRectangleDetector rectangleWithImage:ciImage orientation:orientation completion:^(ZMQuadrilateral * _Nonnull quad) {
            ZMQuadrilateral *detectedQuad = [quad toCartesian:orientedImage.extent.size.height];
            if (completion) {
                completion(detectedQuad);
            }
        }];
    } else {
        [ZMCIRectangleDetector rectangleWithImage:ciImage completion:^(ZMQuadrilateral * _Nonnull quad) {
            ZMQuadrilateral *detectedQuad = [quad toCartesian:orientedImage.extent.size.height];
            if (completion) {
                completion(detectedQuad);
            }
        }];
    }
}

#pragma mark -- getter
- (UIView *)blackFlashView {
    if (_blackFlashView == nil) {
        _blackFlashView = [[UIView alloc] init];
        _blackFlashView.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.5];
        _blackFlashView.hidden = YES;
        _blackFlashView.translatesAutoresizingMaskIntoConstraints = false;
    }
    return _blackFlashView;
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    self.blackFlashView.frame = self.view.bounds;
}

@end
