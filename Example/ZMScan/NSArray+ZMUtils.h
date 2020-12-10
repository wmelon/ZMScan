//
//  NSArray+ZMUtils.h
//  ZMScan_Example
//
//  Created by Sper on 2020/12/7.
//  Copyright © 2020 wmelon. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZMQuadrilateral.h"

NS_ASSUME_NONNULL_BEGIN

@interface NSArray (ZMUtils)

/// 寻找周长最大的框
+ (ZMQuadrilateral *)biggest:(NSArray<ZMQuadrilateral *> *)quads;

@end

NS_ASSUME_NONNULL_END
