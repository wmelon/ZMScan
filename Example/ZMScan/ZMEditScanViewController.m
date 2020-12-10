//
//  ZMEditScanViewController.m
//  ZMScan_Example
//
//  Created by Sper on 2020/12/8.
//  Copyright © 2020 wmelon. All rights reserved.
//

#import "ZMEditScanViewController.h"
#import "UIImage+ZMOrientation.h"
#import "ZMQuadrilateralView.h"
#import "ZMZoomGestureController.h"
#import "ZMReviewViewController.h"

@interface ZMEditScanViewController ()
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UIImage *image;
@property (nonatomic, strong) ZMQuadrilateral *quad;
@property (nonatomic, strong) UIColor *strokeColor;

/// 取消按钮
@property (nonatomic, strong) UIBarButtonItem *cancelButton;
/// 完成按钮
@property (nonatomic, strong) UIBarButtonItem *nextButton;

/// 绘制边框视图
@property (nonatomic, strong) ZMQuadrilateralView *quadView;

/// 放大拉线
@property (nonatomic, strong) ZMZoomGestureController *zoomGestureController;
@end

@implementation ZMEditScanViewController

- (instancetype)initWithImage:(UIImage *)image
                         quad:(ZMQuadrilateral *)quad {
    if (self = [super init]) {
        self.image = [image applyingPortraitOrientation];
        self.quad = quad ? : [self defaultQuadWithImage:image];
    }
    return self;
}

- (ZMQuadrilateral *)defaultQuadWithImage:(UIImage *)image {
    
    CGPoint topLeft = CGPointMake(image.size.width / 3.0, image.size.height / 3.0);
    CGPoint topRight = CGPointMake(2.0 * image.size.width / 3.0, image.size.height / 3.0);
    CGPoint bottomLeft = CGPointMake(image.size.width / 3.0, 2.0 * image.size.height / 3.0);
    CGPoint bottomRight = CGPointMake(2.0 * image.size.width / 3.0, 2.0 * image.size.height / 3.0);

    return [[ZMQuadrilateral alloc] initWithTopLeft:topLeft topRight:topRight bottomRight:bottomRight bottomLeft:bottomLeft];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self configUI];
}

#pragma mark -- UI 相关
- (void)configUI {
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"编辑图片";
    [self.view addSubview:self.imageView];
    [self.view addSubview:self.quadView];
    self.imageView.image = self.image;
    
    self.navigationItem.leftBarButtonItem = self.cancelButton;
    self.navigationItem.rightBarButtonItem = self.nextButton;
    
    self.zoomGestureController = [[ZMZoomGestureController alloc] initWithImage:self.image quadView:self.quadView];
    [self.view addGestureRecognizer:self.zoomGestureController.touchDown];
}

#pragma mark -- button actions
- (void)cancelAction:(UIButton *)button {
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)nextAction:(UIButton *)button {
    UIImage *image = self.image;
    /// 选中矩形物体，下一步进行图片的透视
    CIImage *ciImage = [CIImage imageWithCGImage:image.CGImage];
    if (!ciImage) { /// 打开失败界面
        return;
    }
    
    ZMQuadrilateral *quad = self.quadView.quad;
    if (!quad) { /// 打开界面失败
        return;
    }
    
    ZMQuadrilateral *scaledQuad = [quad scale:self.quadView.bounds.size toSize:image.size rotationAngle:0.0];
    ZMQuadrilateral *cartesianScaledQuad = [scaledQuad toCartesian:self.image.size.height];
    [cartesianScaledQuad reorganize];
    
    /// 图片方向
    CGImagePropertyOrientation cgOrientation = [image imagePropertyOrientation];
    CIImage *orientedImage = [ciImage imageByApplyingOrientation:cgOrientation];
    
    /// 四个点裁剪
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:[CIVector vectorWithCGPoint:cartesianScaledQuad.bottomLeft] forKey:@"inputTopLeft"];
    [params setValue:[CIVector vectorWithCGPoint:cartesianScaledQuad.bottomRight] forKey:@"inputTopRight"];
    [params setValue:[CIVector vectorWithCGPoint:cartesianScaledQuad.topLeft] forKey:@"inputBottomLeft"];
    [params setValue:[CIVector vectorWithCGPoint:cartesianScaledQuad.topRight] forKey:@"inputBottomRight"];
    CIImage *filteredImage = [orientedImage imageByApplyingFilter:@"CIPerspectiveCorrection" withInputParameters:params];
    
    /// 裁剪完成的图片
    UIImage *croppedImage = [UIImage imageFromCIImage:filteredImage];
          
    ZMImageScannerScan *originalScan = [[ZMImageScannerScan alloc] initWithImage:image];
    ZMImageScannerScan *croppedScan = [[ZMImageScannerScan alloc] initWithImage:croppedImage];
    
    ZMImageScannerResults *results = [[ZMImageScannerResults alloc] initWithQuad:scaledQuad originalScan:originalScan croppedScan:croppedScan];
    
    ZMReviewViewController *reviewVc = [[ZMReviewViewController alloc] initWithResults:results];
    [self.navigationController pushViewController:reviewVc animated:YES];
}

#pragma mark -- getter

- (UIImageView *)imageView {
    if (!_imageView) {
        _imageView = [[UIImageView alloc] init];
        _imageView.clipsToBounds = true;
        _imageView.opaque = true;
        _imageView.backgroundColor = [UIColor blackColor];
        _imageView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _imageView;
}
- (ZMQuadrilateralView *)quadView {
    if (_quadView == nil) {
        _quadView = [[ZMQuadrilateralView alloc] init];
        _quadView.editable = true;
    }
    return _quadView;
}

- (UIBarButtonItem *)cancelButton {
    if (!_cancelButton) {
        _cancelButton = [[UIBarButtonItem alloc] initWithTitle:@"cancel" style:(UIBarButtonItemStylePlain) target:self action:@selector(cancelAction:)];
        _cancelButton.tintColor = [UIColor redColor];
    }
    return _cancelButton;
}

- (UIBarButtonItem *)nextButton {
    if (_nextButton == nil) {
        _nextButton = [[UIBarButtonItem alloc] initWithTitle:@"下一步" style:(UIBarButtonItemStyleDone) target:self action:@selector(nextAction:)];
        
        _nextButton.tintColor = [UIColor redColor];
    }
    return _nextButton;
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    [self adjustQuadViewConstraints];
}
- (void)adjustQuadViewConstraints {
    self.imageView.frame = self.view.bounds;
    
    CGRect frame = AVMakeRectWithAspectRatioInsideRect(self.image.size, self.imageView.bounds);
    CGFloat quadViewWidth = frame.size.width;
    CGFloat quadViewHeight = frame.size.height;

    CGFloat quadViewX = (self.view.frame.size.width - quadViewWidth) / 2.0;
    if (quadViewX <= 0.0) {
        quadViewX = 0.0;
    }
    CGFloat quadViewY = (self.view.frame.size.height - quadViewHeight) / 2.0;
    if (quadViewY <= 0.0) {
        quadViewY = 0.0;
    }
    
    self.quadView.frame = CGRectMake(quadViewX, quadViewY, quadViewWidth, quadViewHeight);
    /// 开始绘制选中框
    [self displayQuad:quadViewWidth quadViewHeight:quadViewHeight];
}

- (void)displayQuad:(CGFloat)quadViewWidth quadViewHeight:(CGFloat)quadViewHeight {
    CGSize imageSize = self.image.size;
    CGSize quadViewSize = CGSizeMake(quadViewWidth, quadViewHeight);
    
    CGAffineTransform scaleTransform = [self scaleTransform:imageSize toSize:quadViewSize];
    ZMQuadrilateral *transformedQuad = [self.quad applyingWithTransform:scaleTransform];
    
    [self.quadView drawQuadrilateral:transformedQuad animated:false];
}

- (CGAffineTransform)scaleTransform:(CGSize)fromSize toSize:(CGSize)toSize {
    CGFloat scale = MAX(toSize.width / fromSize.width, toSize.height / fromSize.height);
    return CGAffineTransformMakeScale(scale, scale);
}
- (void)dealloc {
    NSLog(@"dealloc ---- %@" , self);
}
@end
