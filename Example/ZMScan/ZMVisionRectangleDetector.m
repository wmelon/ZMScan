//
//  ZMVisionRectangleDetector.m
//  ZMScan_Example
//
//  Created by Sper on 2020/12/7.
//  Copyright © 2020 wmelon. All rights reserved.
//

#import "ZMVisionRectangleDetector.h"
#import "NSArray+ZMUtils.h"

@implementation ZMVisionRectangleDetector

+ (void)completeImageRequest:(VNImageRequestHandler *)request
                       width:(CGFloat)width
                      height:(CGFloat)height
                    complete:(void(^)(ZMQuadrilateral *quad))complete {
    
    VNDetectRectanglesRequest *rectDetectRequest = [[VNDetectRectanglesRequest alloc] initWithCompletionHandler:^(VNRequest * _Nonnull request, NSError * _Nullable error) {
        NSArray *results = request.results;
        if (error || results.count <= 0){
            if (complete) {
                complete(nil);
            }
        } else {
            NSMutableArray<ZMQuadrilateral *> *quads = [NSMutableArray arrayWithCapacity:results.count];
            [results enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if ([obj isKindOfClass:[VNRectangleObservation class]]) {
                    VNRectangleObservation *rectangleObservation = (VNRectangleObservation *)obj;
                    ZMQuadrilateral *quad = [[ZMQuadrilateral alloc] initWithRectangleObservation:rectangleObservation];
                    [quads addObject:quad];
                }
            }];
            
            /// 获取最大的矩形框
            ZMQuadrilateral *biggest = [NSArray biggest:quads];
            
            /// 转换坐标
            CGAffineTransform transform = CGAffineTransformScale(CGAffineTransformIdentity, width, height);
            if (complete) {
                ZMQuadrilateral *resultQuad = [biggest applyingWithTransform:transform];
                complete(resultQuad);
            }
        }
    }];
    
    rectDetectRequest.minimumConfidence = 0.8;
    rectDetectRequest.maximumObservations = 15;
    rectDetectRequest.minimumAspectRatio = 0.3;
    /// 开始识别
    [request performRequests:@[rectDetectRequest] error:nil];
}

+ (void)rectangleWithPixelBuffer:(CVPixelBufferRef)pixelBuffer
                      completion:(void(^)(ZMQuadrilateral *quad))completion {
    
    VNImageRequestHandler *imageRequestHandler = [[VNImageRequestHandler alloc] initWithCVPixelBuffer:pixelBuffer options:@{}];
    
    CGFloat width = CVPixelBufferGetWidth(pixelBuffer);
    CGFloat height = CVPixelBufferGetHeight(pixelBuffer);
    
    [ZMVisionRectangleDetector completeImageRequest:imageRequestHandler width:width height:height complete:completion];
}


+ (void)rectangleWithImage:(CIImage *)image
                completion:(void(^)(ZMQuadrilateral *quad))completion {
    
    VNImageRequestHandler *imageRequestHandler = [[VNImageRequestHandler alloc] initWithCIImage:image options:@{}];
    
    CGFloat width = image.extent.size.width;
    CGFloat height = image.extent.size.height;
    
    [ZMVisionRectangleDetector completeImageRequest:imageRequestHandler width:width height:height complete:completion];
    
}


+ (void)rectangleWithImage:(CIImage *)image
               orientation:(CGImagePropertyOrientation)orientation
                completion:(void(^)(ZMQuadrilateral *quad))completion {
    
    VNImageRequestHandler *imageRequestHandler = [[VNImageRequestHandler alloc] initWithCIImage:image orientation:orientation options:@{}];
    
    CIImage *orientedImage = [image imageByApplyingOrientation:orientation];

    CGFloat width = orientedImage.extent.size.width;
    CGFloat height = orientedImage.extent.size.height;
    
    [ZMVisionRectangleDetector completeImageRequest:imageRequestHandler width:width height:height complete:completion];
}

@end
