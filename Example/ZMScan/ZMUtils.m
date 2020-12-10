//
//  ZMUtils.m
//  ZMScan_Example
//
//  Created by Sper on 2020/12/10.
//  Copyright © 2020 wmelon. All rights reserved.
//

#import "ZMUtils.h"

@implementation ZMUtils

+ (CGFloat)distancePoint:(CGPoint)point toPoint:(CGPoint)toPoint{
    return hypot(point.x - toPoint.x, point.y - toPoint.y);
}

@end
