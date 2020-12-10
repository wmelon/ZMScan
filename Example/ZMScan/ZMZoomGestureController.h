//
//  ZMZoomGestureController.h
//  ZMScan_Example
//
//  Created by Sper on 2020/12/9.
//  Copyright © 2020 wmelon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZMQuadrilateralView.h"

NS_ASSUME_NONNULL_BEGIN

@interface ZMZoomGestureController : UIViewController

@property (nonatomic, strong, readonly) UILongPressGestureRecognizer *touchDown;

- (instancetype)initWithImage:(UIImage *)image quadView:(ZMQuadrilateralView *)quadView;

@end

NS_ASSUME_NONNULL_END
