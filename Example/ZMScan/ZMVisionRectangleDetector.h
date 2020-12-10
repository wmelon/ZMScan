//
//  ZMVisionRectangleDetector.h
//  ZMScan_Example
//
//  Created by Sper on 2020/12/7.
//  Copyright © 2020 wmelon. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZMQuadrilateral.h"
#import <Vision/Vision.h>
#import <CoreVideo/CoreVideo.h>

NS_ASSUME_NONNULL_BEGIN

API_AVAILABLE(macos(10.13), ios(11.0), tvos(11.0))
@interface ZMVisionRectangleDetector : NSObject

+ (void)completeImageRequest:(VNImageRequestHandler *)request
                       width:(CGFloat)width
                      height:(CGFloat)height
                    complete:(void(^)(ZMQuadrilateral *quad))complete;


+ (void)rectangleWithPixelBuffer:(CVPixelBufferRef)pixelBuffer
                      completion:(void(^)(ZMQuadrilateral *quad))completion;


+ (void)rectangleWithImage:(CIImage *)image
                completion:(void(^)(ZMQuadrilateral *quad))completion;


+ (void)rectangleWithImage:(CIImage *)image
               orientation:(CGImagePropertyOrientation)orientation
                completion:(void(^)(ZMQuadrilateral *quad))completion;

@end

NS_ASSUME_NONNULL_END
