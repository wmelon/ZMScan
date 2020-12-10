//
//  ZMCIRectangleDetector.m
//  ZMScan_Example
//
//  Created by Sper on 2020/12/7.
//  Copyright © 2020 wmelon. All rights reserved.
//

#import "ZMCIRectangleDetector.h"
#import <AVFoundation/AVFoundation.h>
#import "NSArray+ZMUtils.h"

@implementation ZMCIRectangleDetector

+ (void)rectangleWithImage:(CIImage *)image
                completion:(void(^)(ZMQuadrilateral *quad))completion {
    
    ZMQuadrilateral *quad = [self rectangleWithImage:image];
    
    if (completion) {
        completion(quad);
    }
}

+ (ZMQuadrilateral *)rectangleWithImage:(CIImage *)image {
    CIDetector *rectangleDetector = [CIDetector detectorOfType:CIDetectorTypeRectangle context:[CIContext contextWithOptions:nil] options:@{CIDetectorAccuracy:CIDetectorAccuracyHigh}];
    
    NSArray<CIFeature *> *rectangleFeatures = [rectangleDetector featuresInImage:image];
    
    NSMutableArray<ZMQuadrilateral *> *quads = [NSMutableArray arrayWithCapacity:rectangleFeatures.count];
    [rectangleFeatures enumerateObjectsUsingBlock:^(CIFeature * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[CIRectangleFeature class]]) {
            [quads addObject:[[ZMQuadrilateral alloc] initWithRectangleFeature:(CIRectangleFeature *)obj]];
        }
    }];
    
    /// 获取最大的矩形框
    ZMQuadrilateral *biggest = [NSArray biggest:quads];
    return biggest;
}

@end
