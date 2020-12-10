//
//  ZMUtils.h
//  ZMScan_Example
//
//  Created by Sper on 2020/12/10.
//  Copyright © 2020 wmelon. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZMUtils : NSObject

/// 两点之间的距离
/// @param point
/// @param toPoint
+ (CGFloat)distancePoint:(CGPoint)point toPoint:(CGPoint)toPoint;

@end

NS_ASSUME_NONNULL_END
