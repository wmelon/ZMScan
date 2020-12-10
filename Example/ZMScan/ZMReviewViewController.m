//
//  ZMReviewViewController.m
//  ZMScan_Example
//
//  Created by Sper on 2020/12/9.
//  Copyright © 2020 wmelon. All rights reserved.
//

#import "ZMReviewViewController.h"
#import "UIImage+ZMOrientation.h"

@interface ZMReviewViewController ()
@property (nonatomic, strong) ZMImageScannerResults *results;
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UIBarButtonItem *rotateButton;
@property (nonatomic, strong) UIImage *image;
@end

@implementation ZMReviewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view addSubview:self.imageView];
    self.navigationItem.rightBarButtonItem = self.rotateButton;
    self.title = @"结果查看";
}

- (instancetype)initWithResults:(ZMImageScannerResults *)results {
    if (self = [super init]) {
        _results = results;
        self.image = results.croppedScan.image;
        self.imageView.image = self.image;
    }
    return self;
}
#pragma mark -- button action
- (void)rotateImage {
    /// 每次旋转90度
    self.image = [self.image rotatedByDegrees:-90];
    self.imageView.image = self.image;
}

#pragma mark -- getter
- (UIImageView *)imageView {
    if (!_imageView) {
        _imageView = [[UIImageView alloc] init];
        _imageView.clipsToBounds = true;
        _imageView.opaque = true;
        _imageView.backgroundColor = [UIColor blackColor];
        _imageView.contentMode = UIViewContentModeScaleAspectFit;
        _imageView.translatesAutoresizingMaskIntoConstraints = false;
    }
    return _imageView;
}
- (UIBarButtonItem *)rotateButton {
    if (!_rotateButton) {
        UIBarButtonItem *button = [[UIBarButtonItem alloc] initWithTitle:@"旋转" style:(UIBarButtonItemStylePlain) target:self action:@selector(rotateImage)];
        button.tintColor = [UIColor redColor];
        _rotateButton = button;
    }
    return _rotateButton;
}
- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    self.imageView.frame = self.view.bounds;
}

- (void)dealloc {
    NSLog(@"dealloc  ---- %@",self);
}

@end
