//
//  ZMImageScannerResults.m
//  ZMScan_Example
//
//  Created by Sper on 2020/12/7.
//  Copyright © 2020 wmelon. All rights reserved.
//

#import "ZMImageScannerResults.h"

@implementation ZMImageScannerScan

- (instancetype)initWithImage:(UIImage *)image {
    if (self = [super init]) {
        _image = image;
    }
    return self;
}

@end

@interface ZMImageScannerResults()
@property (nonatomic, strong) ZMQuadrilateral *detectedRectangle;

@property (nonatomic, strong) UIImage *originalImage;
@property (nonatomic, strong) UIImage *croppedImage;
@end

@implementation ZMImageScannerResults

- (instancetype)initWithQuad:(ZMQuadrilateral *)quad
                originalScan:(ZMImageScannerScan *)originalScan
                 croppedScan:(ZMImageScannerScan *)croppedScan {
    if (self = [super init]) {
        self.detectedRectangle = quad;
        
        _originalScan = originalScan;
        _croppedScan = croppedScan;
    }
    return self;
}

@end
