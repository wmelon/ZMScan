//
//  ZMEditScanViewController.h
//  ZMScan_Example
//
//  Created by Sper on 2020/12/8.
//  Copyright © 2020 wmelon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZMQuadrilateral.h"

NS_ASSUME_NONNULL_BEGIN

@interface ZMEditScanViewController : UIViewController

- (instancetype)initWithImage:(UIImage *)image
                         quad:(ZMQuadrilateral *)quad;

@end

NS_ASSUME_NONNULL_END
