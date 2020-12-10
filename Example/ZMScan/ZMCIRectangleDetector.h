//
//  ZMCIRectangleDetector.h
//  ZMScan_Example
//
//  Created by Sper on 2020/12/7.
//  Copyright © 2020 wmelon. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZMQuadrilateral.h"

NS_ASSUME_NONNULL_BEGIN

@interface ZMCIRectangleDetector : NSObject

+ (void)rectangleWithImage:(CIImage *)image
                completion:(void(^)(ZMQuadrilateral *quad))completion;

@end

NS_ASSUME_NONNULL_END
