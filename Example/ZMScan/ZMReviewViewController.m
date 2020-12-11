//
//  ZMReviewViewController.m
//  ZMScan_Example
//
//  Created by Sper on 2020/12/9.
//  Copyright © 2020 wmelon. All rights reserved.
//

#import "ZMReviewViewController.h"
#import "UIImage+ZMOrientation.h"
#import "ZMMaterialCollCell.h"

@interface ZMReviewViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>
@property (nonatomic, strong) UIImageView *bgImageView;
@property (nonatomic, strong) UIImageView *borderImageView;

@property (nonatomic, strong) ZMImageScannerResults *results;
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UIBarButtonItem *rotateButton;
@property (nonatomic, strong) UIBarButtonItem *changeButtton;

@property (nonatomic, strong) UIImage *image;
@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, strong) NSArray<UIImage *> *images;

@property (nonatomic, assign) NSInteger currentIndex;


@property (nonatomic, assign) BOOL isSelected;
@property (nonatomic, strong) NSArray *borderWidth;

@end

@implementation ZMReviewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.imageView.image = self.image;
    [self.view addSubview:self.bgImageView];
    [self.view addSubview:self.borderImageView];
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.imageView];
    [self.view addSubview:self.collectionView];
    self.navigationItem.rightBarButtonItems = @[self.rotateButton,self.changeButtton];
    
    self.title = @"结果查看";
    
    self.images = @[[UIImage imageNamed:@"icon_xiangkuang_00"],
                    [UIImage imageNamed:@"icon_xiangkuang_01"],
                    [UIImage imageNamed:@"icon_xiangkuang_02"],
                    [UIImage imageNamed:@"icon_xiangkuang_03"],
                    [UIImage imageNamed:@"icon_xiangkuang_04"],
                    [UIImage imageNamed:@"icon_xiangkuang_05"]];
    self.borderWidth = @[@(190),@(30),@(45),@(18),@(65),@(150)];
    [self.collectionView reloadData];
    
    
    CGSize imageSize = self.image.size;
    CGFloat imageViewWidth = self.view.frame.size.width - 160;
    CGFloat imageViewHeight = imageViewWidth * imageSize.height / imageSize.width;
    self.imageView.frame = CGRectMake(80, (self.view.frame.size.height - imageViewHeight) / 2.0, imageViewWidth, imageViewHeight);
    self.imageView.center = self.view.center;
}

- (instancetype)initWithResults:(ZMImageScannerResults *)results {
    if (self = [super init]) {
        _results = results;
        self.image = results.croppedScan.image;
        
    }
    return self;
}
#pragma mark -- button action
- (void)rotateImage {
    /// 每次旋转90度
    self.image = [self.image rotatedByDegrees:-90];
    self.imageView.image = self.image;
}
- (void)changeImage:(UIBarButtonItem *)button {
    self.isSelected = !self.isSelected;
    
    if (self.isSelected) {
        
        self.borderImageView.image = nil;
        
        CGFloat imageViewWidth = self.imageView.frame.size.width;
        CGFloat imageViewHeight = self.imageView.frame.size.height;
        
        CGFloat width = 40;
        UIImageView *topLeftIv = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, width, width)];
        topLeftIv.image = [UIImage imageNamed:[NSString stringWithFormat:@"icon_xiangkuang_0%ld_topLeft",self.currentIndex]];
        [self.borderImageView addSubview:topLeftIv];
        
        UIImageView *topRightIv = [[UIImageView alloc] initWithFrame:CGRectMake(imageViewWidth - width, 0, width, width)];
        topRightIv.image = [UIImage imageNamed:[NSString stringWithFormat:@"icon_xiangkuang_0%ld_topRight",self.currentIndex]];
        [self.borderImageView addSubview:topRightIv];
        
        
        UIImageView *bottomLeftIv = [[UIImageView alloc] initWithFrame:CGRectMake(0, imageViewHeight - width, width, width)];
        bottomLeftIv.image = [UIImage imageNamed:[NSString stringWithFormat:@"icon_xiangkuang_0%ld_bottomLeft",self.currentIndex]];
        [self.borderImageView addSubview:bottomLeftIv];
        
        
        UIImageView *bottomRightIv = [[UIImageView alloc] initWithFrame:CGRectMake(imageViewWidth - width, imageViewHeight - width, width, width)];
        bottomRightIv.image = [UIImage imageNamed:[NSString stringWithFormat:@"icon_xiangkuang_0%ld_bottomRight",self.currentIndex]];
        [self.borderImageView addSubview:bottomRightIv];
        
        CGFloat lineWidth = 40;
        NSInteger lineCount = imageViewWidth / lineWidth;
        for (int i = 0; i < lineCount - 2; i++ ){
            UIImageView *lineIv = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(topLeftIv.frame) + lineWidth * i, 0, lineWidth, lineWidth)];
            lineIv.image = [UIImage imageNamed:[NSString stringWithFormat:@"icon_xiangkuang_0%ld_line",self.currentIndex]];
            [self.borderImageView addSubview:lineIv];
        }
        
        for (int i = 0; i < lineCount - 2; i++ ){
            UIImageView *lineIv = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(bottomLeftIv.frame) + lineWidth * i, CGRectGetMinY(bottomLeftIv.frame), lineWidth, lineWidth)];
            lineIv.image = [UIImage imageNamed:[NSString stringWithFormat:@"icon_xiangkuang_0%ld_line",self.currentIndex]];
            [self.borderImageView addSubview:lineIv];
        }
        
        NSInteger vertCount = imageViewHeight / lineWidth;
        for (int i = 0; i < vertCount - 2; i++ ){
            UIImageView *lineIv = [[UIImageView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(topLeftIv.frame) + lineWidth * i, lineWidth,lineWidth)];
            lineIv.image = [UIImage imageNamed:[NSString stringWithFormat:@"icon_xiangkuang_0%ld_vert",self.currentIndex]];
            [self.borderImageView addSubview:lineIv];
        }
        for (int i = 0; i < vertCount - 2; i++ ){
            UIImageView *lineIv = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMinX(topRightIv.frame), CGRectGetMaxY(topRightIv.frame) + lineWidth * i, lineWidth,lineWidth)];
            lineIv.image = [UIImage imageNamed:[NSString stringWithFormat:@"icon_xiangkuang_0%ld_vert",self.currentIndex]];
            [self.borderImageView addSubview:lineIv];
        }
        
    } else {
        UIImage *image = self.images[self.currentIndex];
        CGFloat top = image.size.height/3.0 - 10;
        CGFloat left = image.size.width/3.0 - 10;
        CGFloat bottom = image.size.height/3.0 - 10;
        CGFloat right = image.size.width/3.0 - 10;
        
        UIImage *stretchImage = [image resizableImageWithCapInsets:UIEdgeInsetsMake(top, left, bottom, right) resizingMode:(UIImageResizingModeStretch)];
        self.borderImageView.image = stretchImage;
        
        [self.borderImageView.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [obj removeFromSuperview];
        }];
    }
}

#pragma mark -- collectionView delegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.images.count;
}
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ZMMaterialCollCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([ZMMaterialCollCell class]) forIndexPath:indexPath];
    UIImage *image = self.images[indexPath.row];
    [cell showImage:image selectHandle:^(ZMMaterialCollCell * _Nonnull cell, UIImage * _Nonnull image) {
        
    }];
    cell.contentView.backgroundColor = [UIColor yellowColor];
    return cell;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 10;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 10;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(80, 80);
}
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(0, 10, 0, 10);
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    UIImage *image = self.images[indexPath.row];
    self.currentIndex = indexPath.row;
    
    CGFloat reallyBoder = [self.borderWidth[indexPath.row] floatValue];
    
    UIImage *stretchImage = [image resizableImageWithCapInsets:UIEdgeInsetsMake(reallyBoder, reallyBoder, reallyBoder, reallyBoder) resizingMode:(UIImageResizingModeStretch)];
    self.borderImageView.image = stretchImage;
    
    
    CGFloat scaled = 1.0;
    if (reallyBoder >= 80) {
        scaled = reallyBoder / 80.0;
        reallyBoder = 80;
    }
    
    CGFloat top = reallyBoder;
    CGFloat left = top;
    CGFloat bottom = top;
    CGFloat right = top;
    
    
    CGSize imageSize = self.image.size;
    
    CGFloat imageViewWidth = (self.view.frame.size.width - 160) / scaled;
    CGFloat imageViewHeight = (imageViewWidth * imageSize.height / imageSize.width);
    
    
    self.imageView.frame = CGRectMake((self.view.frame.size.width - imageViewWidth) / 2.0, (self.view.frame.size.height - imageViewHeight) / 2.0, imageViewWidth, imageViewHeight);
    
    
    self.borderImageView.frame = CGRectMake(self.imageView.frame.origin.x - left, self.imageView.frame.origin.y - top, self.imageView.frame.size.width + left + right, self.imageView.frame.size.height + top + bottom);
}


#pragma mark -- getter
- (UIImageView *)bgImageView {
    if (_bgImageView == nil) {
        _bgImageView = [[UIImageView alloc] init];
        _bgImageView.contentMode = UIViewContentModeScaleAspectFit;
        _bgImageView.backgroundColor = [UIColor redColor];
        _bgImageView.clipsToBounds = YES;
        _bgImageView.image = [UIImage imageNamed:@"icon_bg_image"];
    }
    return _bgImageView;
}
- (UIImageView *)borderImageView {
    if (!_borderImageView) {
        UIImageView *imageView = [[UIImageView alloc] init];
//        imageView.contentMode = UIViewContentModeScaleAspectFit;
//        imageView.clipsToBounds = true;
//        imageView.opaque = true;
        _borderImageView = imageView;
    }
    return _borderImageView;
}
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
- (UIBarButtonItem *)changeButtton {
    if (!_changeButtton) {
        UIBarButtonItem *button = [[UIBarButtonItem alloc] initWithTitle:@"变化" style:(UIBarButtonItemStylePlain) target:self action:@selector(changeImage:)];
        button.tintColor = [UIColor redColor];
        _changeButtton = button;
    }
    return _changeButtton;
}
- (UICollectionView *)collectionView {
    if (_collectionView == nil) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        _collectionView.backgroundColor = [UIColor redColor];
        [_collectionView registerClass:[ZMMaterialCollCell class] forCellWithReuseIdentifier:NSStringFromClass([ZMMaterialCollCell class])];
    }
    return _collectionView;
}
- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    
    self.bgImageView.frame = self.view.bounds;
    
    
    
//    self.borderImageView.frame = self.imageView.bounds;
//    self.borderImageView.center = self.view.center;
//    CGAffineTransform transform = CGAffineTransformMakeScale(1.3, 1.3);
//    [self.borderImageView setTransform:transform];
    

    
    self.collectionView.frame = CGRectMake(0, self.view.frame.size.height - 100 - 34, self.view.frame.size.width, 100);
}

- (void)dealloc {
    NSLog(@"dealloc  ---- %@",self);
}

@end
