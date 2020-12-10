//
//  ZMImageScannerResults.h
//  ZMScan_Example
//
//  Created by Sper on 2020/12/7.
//  Copyright © 2020 wmelon. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZMQuadrilateral.h"

NS_ASSUME_NONNULL_BEGIN

@interface ZMImageScannerScan : NSObject

@property (nonatomic, strong, readonly) UIImage *image;

- (instancetype)initWithImage:(UIImage *)image;

@end

@interface ZMImageScannerResults : NSObject
/// 原始
@property (nonatomic, strong, readonly) ZMImageScannerScan *originalScan;
/// 裁剪
@property (nonatomic, strong, readonly) ZMImageScannerScan *croppedScan;

- (instancetype)initWithQuad:(ZMQuadrilateral *)quad
                originalScan:(ZMImageScannerScan *)originalScan
                 croppedScan:(ZMImageScannerScan *)croppedScan;

@end

NS_ASSUME_NONNULL_END
