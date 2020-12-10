//
//  UIImage+ZMOrientation.h
//  ZMScan_Example
//
//  Created by Sper on 2020/12/8.
//  Copyright © 2020 wmelon. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIImage (ZMOrientation)

/// 矫正图片方向
- (UIImage *)applyingPortraitOrientation;

/// 旋转图片
/// @param degrees 旋转角度
- (UIImage *)rotatedByDegrees:(CGFloat)degrees;

/// 缩放图片
/// @param point 触摸点 * 图片相对视图的比例
/// @param scaleFactor 缩放比例
/// @param size 视图的大小
- (UIImage *)scaledImage:(CGPoint)point scaleFactor:(CGFloat)scaleFactor targetSize:(CGSize)size;

/// 获取图片的CG方向
- (CGImagePropertyOrientation)imagePropertyOrientation;

/// Creates a UIImage from the specified CIImage.
/// @param ciImage
+ (UIImage *)imageFromCIImage:(CIImage *)ciImage;

@end

NS_ASSUME_NONNULL_END
