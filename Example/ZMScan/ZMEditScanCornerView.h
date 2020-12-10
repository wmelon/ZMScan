//
//  ZMEditScanCornerView.h
//  ZMScan_Example
//
//  Created by Sper on 2020/12/8.
//  Copyright © 2020 wmelon. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger,ZMCornerPosition) {
    ZMCornerPosition_topLeft,
    ZMCornerPosition_topRight,
    ZMCornerPosition_bottomRight,
    ZMCornerPosition_bottomLeft
};

@interface ZMEditScanCornerView : UIView

@property (nonatomic, assign, readonly) ZMCornerPosition position;
@property (nonatomic, assign) CGColorRef strokeColor;
@property (nonatomic, assign) BOOL highlighted;

- (instancetype)initWithFrame:(CGRect)frame position:(ZMCornerPosition)position;

- (void)highlightWithImage:(UIImage *)image;

- (void)reset;

@end

NS_ASSUME_NONNULL_END
