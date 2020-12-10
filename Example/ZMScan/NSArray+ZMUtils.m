//
//  NSArray+ZMUtils.m
//  ZMScan_Example
//
//  Created by Sper on 2020/12/7.
//  Copyright © 2020 wmelon. All rights reserved.
//

#import "NSArray+ZMUtils.h"

@implementation NSArray (ZMUtils)

+ (ZMQuadrilateral *)biggest:(NSArray<ZMQuadrilateral *> *)quads {
    if (quads.count <= 0) return nil;
    
    __block ZMQuadrilateral *maxQuad = [quads firstObject];
    [quads enumerateObjectsUsingBlock:^(ZMQuadrilateral * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (maxQuad.perimeter <= obj.perimeter) {
            maxQuad = obj;
        }
    }];
    return maxQuad;
}

@end
