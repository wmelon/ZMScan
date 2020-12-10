//
//  ZMEditScanCornerView.m
//  ZMScan_Example
//
//  Created by Sper on 2020/12/8.
//  Copyright © 2020 wmelon. All rights reserved.
//

#import "ZMEditScanCornerView.h"

@interface ZMEditScanCornerView()
@property (nonatomic, strong) UIImage *image;
@property (nonatomic, assign) BOOL isHighlighted;
@property (nonatomic, strong) CAShapeLayer *circleLayer;
@end

@implementation ZMEditScanCornerView
@synthesize position = _position;

- (instancetype)initWithFrame:(CGRect)frame position:(ZMCornerPosition)position {
    if (self = [super initWithFrame:frame]) {
        _position = position;
        self.backgroundColor = [UIColor clearColor];
        self.clipsToBounds = YES;
        
        [self.layer addSublayer:self.circleLayer];
    }
    return self;
}

- (void)highlightWithImage:(UIImage *)image {
    _highlighted = YES;
    _image = image;
    [self setNeedsDisplay];
}

- (void)reset {
    _highlighted = false;
    _image = nil;
    [self setNeedsDisplay];
}

- (void)setStrokeColor:(CGColorRef)strokeColor {
    _strokeColor = strokeColor;
    self.circleLayer.strokeColor = strokeColor;
}

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    
    UIBezierPath *bezierPath = [UIBezierPath bezierPathWithOvalInRect:CGRectInset(rect, self.circleLayer.lineWidth, self.circleLayer.lineWidth)];
    self.circleLayer.frame = rect;
    self.circleLayer.path = bezierPath.CGPath;
    
    [self.image drawInRect:rect];
}

- (CAShapeLayer *)circleLayer{
    if (_circleLayer == nil) {
        _circleLayer = [[CAShapeLayer alloc] init];
        _circleLayer.fillColor = [UIColor clearColor].CGColor;
        _circleLayer.strokeColor = [UIColor whiteColor].CGColor;
        _circleLayer.lineWidth = 1.0;
    }
    return _circleLayer;
}
- (void)layoutSubviews {
    [super layoutSubviews];
    self.layer.cornerRadius = self.bounds.size.width / 2.0;
}
@end
