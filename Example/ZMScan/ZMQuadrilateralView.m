//
//  ZMQuadrilateralView.m
//  ZMScan_Example
//
//  Created by Sper on 2020/12/8.
//  Copyright © 2020 wmelon. All rights reserved.
//

#import "ZMQuadrilateralView.h"
#import "ZMUtils.h"

@interface ZMQuadrilateralView()
/// 四边形图层
@property (nonatomic, strong) CAShapeLayer *quadLayer;
/// 四边形视图
@property (nonatomic, strong) UIView *quadView;
/// 顶点圆圈大小
@property (nonatomic, assign) CGSize cornerViewSize;
/// 可编辑状态下圆圈大小
@property (nonatomic, assign) CGSize highlightedCornerViewSize;
/// 是否可编辑状态
@property (nonatomic, assign) BOOL highlighted;

@property (nonatomic, strong) ZMEditScanCornerView *topLeftCornerView;
@property (nonatomic, strong) ZMEditScanCornerView *topRightCornerView;
@property (nonatomic, strong) ZMEditScanCornerView *bottomRightCornerView;
@property (nonatomic, strong) ZMEditScanCornerView *bottomLeftCornerView;

@end

@implementation ZMQuadrilateralView

- (instancetype)init {
    if (self = [super init]) {
        [self configUI];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self configUI];
    }
    return self;
}

- (void)configUI {
    self.cornerViewSize = CGSizeMake(20, 20);
    self.highlightedCornerViewSize = CGSizeMake(75, 75);
    
    [self addSubview:self.quadView];
    [self addSubview:self.topLeftCornerView];
    [self addSubview:self.topRightCornerView];
    [self addSubview:self.bottomLeftCornerView];
    [self addSubview:self.bottomRightCornerView];
    
    [self.quadView.layer addSublayer:self.quadLayer];
}

- (void)setEditable:(BOOL)editable {
    _editable = editable;
    [self cornerViewsHidden:!editable];
    self.quadLayer.fillColor = editable ? [UIColor colorWithWhite:0.0 alpha:0.6].CGColor : [UIColor colorWithWhite:1.0 alpha:0.5].CGColor;
    
    if (!self.quad) return;
    
    [self drawQuad:self.quad animated:false];
    [self layoutCornerViews:self.quad];
}

- (void)setStrokeColor:(CGColorRef)strokeColor {
    _strokeColor = strokeColor;
    self.quadLayer.strokeColor = strokeColor;
    self.topLeftCornerView.strokeColor = strokeColor;
    self.topRightCornerView.strokeColor = strokeColor;
    self.bottomRightCornerView.strokeColor = strokeColor;
    self.bottomLeftCornerView.strokeColor = strokeColor;
}

#pragma mark -- private method
- (void)cornerViewsHidden:(BOOL)hidden {
    self.topRightCornerView.hidden = hidden;
    self.topLeftCornerView.hidden = hidden;
    self.bottomRightCornerView.hidden = hidden;
    self.bottomLeftCornerView.hidden = hidden;
}

- (void)layoutCornerViews:(ZMQuadrilateral *)quad {
    self.topLeftCornerView.center = quad.topLeft;
    self.topRightCornerView.center = quad.topRight;
    self.bottomLeftCornerView.center = quad.bottomLeft;
    self.bottomRightCornerView.center = quad.bottomRight;
}

- (void)removeQuadrilateral {
    self.quadLayer.path = nil;
    self.quadLayer.hidden = YES;
}

#pragma mark -- drawings
- (void)drawQuadrilateral:(ZMQuadrilateral *)quad animated:(BOOL)animated {
    _quad = quad;
    [self drawQuad:quad animated:animated];
    
    if (self.editable) {
        [self cornerViewsHidden:false];
        [self layoutCornerViews:quad];
    }
}

- (void)drawQuad:(ZMQuadrilateral *)quad animated:(BOOL)animated {
    UIBezierPath *path = quad.path;
    
    if (self.editable) {
        path = [path bezierPathByReversingPath];
        UIBezierPath *rectPath = [UIBezierPath bezierPathWithRect:self.bounds];
        [path appendPath:rectPath];
    }
    
    if (animated) {
        CABasicAnimation *pathAnimation = [CABasicAnimation animationWithKeyPath:@"path"];
        pathAnimation.duration = 0.2;
        [self.quadLayer addAnimation:pathAnimation forKey:@"path"];
    }
    
    self.quadLayer.path = path.CGPath;
    self.quadLayer.hidden = false;
}

#pragma mark -- public method

- (void)moveCorner:(ZMEditScanCornerView *)cornerView point:(CGPoint)point {
    if (!self.quad) return;
    
    CGPoint validPoint = [self validPoint:point cornerViewSize:cornerView.bounds.size inView:self];
    
    if ([self validConcaveQuad:self.quad point:point position:cornerView.position]){ /// 凹四边形不允许拖拽
        return;
    }
    
    cornerView.center = validPoint;
    ZMQuadrilateral *updateQuad = [self update:self.quad position:validPoint forCorner:cornerView.position];
    
    [self drawQuad:updateQuad animated:false];
}

- (void)resetHighlightedCornerViews {
    self.highlighted = false;
    [self resetHighlightedCornerViews:@[self.topLeftCornerView,self.topRightCornerView,self.bottomLeftCornerView,self.bottomRightCornerView]];
}

- (void)resetHighlightedCornerViews:(NSArray<ZMEditScanCornerView *> *)cornerViews {
    [cornerViews enumerateObjectsUsingBlock:^(ZMEditScanCornerView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [self resetHightlightedCornerView:obj];
    }];
}

- (void)resetHightlightedCornerView:(ZMEditScanCornerView *)cornerView {
    [cornerView reset];
    CGFloat pointX = cornerView.frame.origin.x + (cornerView.frame.size.width - self.cornerViewSize.width) / 2.0;
    CGFloat pointY = cornerView.frame.origin.y + (cornerView.frame.size.height - self.cornerViewSize.height) / 2.0;
    
    cornerView.frame = CGRectMake(pointX, pointY, self.cornerViewSize.width, self.cornerViewSize.height);
    [cornerView setNeedsDisplay];
}

- (ZMEditScanCornerView *)cornerViewForCornerPosition:(ZMCornerPosition)position {
    switch (position) {
        case ZMCornerPosition_topLeft:
            return self.topLeftCornerView;
        case ZMCornerPosition_topRight:
            return self.topRightCornerView;
        case ZMCornerPosition_bottomLeft:
            return self.bottomLeftCornerView;
        case ZMCornerPosition_bottomRight:
            return self.bottomRightCornerView;
    }
}

- (void)highlightCornerAtPosition:(ZMCornerPosition)position image:(UIImage *)image {
    if (self.editable == false) return;
    self.highlighted = YES;
    
    ZMEditScanCornerView *cornerView = [self cornerViewForCornerPosition:position];
    if (cornerView.highlighted) {
        [cornerView highlightWithImage:image];
        return;
    }
    
    CGFloat pointX = cornerView.frame.origin.x - (self.highlightedCornerViewSize.width - self.cornerViewSize.width) / 2.0;
    CGFloat pointY = cornerView.frame.origin.y - (self.highlightedCornerViewSize.height - self.cornerViewSize.height) / 2.0;
    
    cornerView.frame = CGRectMake(pointX, pointY, self.highlightedCornerViewSize.width, self.highlightedCornerViewSize.height);
    [cornerView highlightWithImage:image];
}

- (void)setHighlighted:(BOOL)highlighted {
    _highlighted = highlighted;
    self.quadLayer.fillColor = highlighted ? [UIColor clearColor].CGColor : [UIColor colorWithWhite:0.0 alpha:0.6].CGColor;
    highlighted ? [self bringSubviewToFront:self.quadView] : [self sendSubviewToBack:self.quadView];
}

#pragma mark -- Validation Point
- (CGPoint)validPoint:(CGPoint)point cornerViewSize:(CGSize)cornerViewSize inView:(UIView *)view {
    
    CGPoint validPoint = point;
    
    if (point.x > view.bounds.size.width) {
        validPoint.x = view.bounds.size.width;
    } else if (point.x < 0.0){
        validPoint.x = 0.0;
    }
    
    if (point.y > view.bounds.size.height) {
        validPoint.y = view.bounds.size.height;
    } else if (point.y < 0.0) {
        validPoint.y = 0.0;
    }
    
    return validPoint;
}

/// 检测是否是凹四边形
- (BOOL)validConcaveQuad:(ZMQuadrilateral *)quad point:(CGPoint)point position:(ZMCornerPosition)position{
    BOOL isConcave = NO;
    
    switch (position) {
        case ZMCornerPosition_topLeft:
        {
            if (point.y < quad.bottomLeft.y && point.y < quad.bottomRight.y && point.x < quad.topRight.x && point.x < quad.bottomRight.x){
                UIBezierPath *path  = [UIBezierPath new];
                [path moveToPoint:quad.topRight];
                [path addLineToPoint:quad.bottomRight];
                [path addLineToPoint:quad.bottomLeft];
                [path closePath];
                
                isConcave = [path containsPoint:point];
            } else {
                isConcave = YES;
            }
        }
            break;
        case ZMCornerPosition_topRight:
        {
            if (point.y < quad.bottomRight.y && point.y < quad.bottomLeft.y && point.x > quad.bottomLeft.x && point.x > quad.topLeft.x){
                UIBezierPath *path  = [UIBezierPath new];
                [path moveToPoint:quad.topLeft];
                [path addLineToPoint:quad.bottomRight];
                [path addLineToPoint:quad.bottomLeft];
                [path closePath];
                
                isConcave = [path containsPoint:point];
            } else {
                isConcave = YES;
            }
        }
            break;
        case ZMCornerPosition_bottomLeft:
        {
            if (point.x < quad.bottomRight.x && point.x < quad.topRight.x && point.y > quad.topLeft.y && point.y > quad.topRight.y){
                UIBezierPath *path  = [UIBezierPath new];
                [path moveToPoint:quad.topRight];
                [path addLineToPoint:quad.bottomRight];
                [path addLineToPoint:quad.topLeft];
                [path closePath];
                
                isConcave = [path containsPoint:point];
            } else {
                isConcave = YES;
            }
        }
            break;
        case ZMCornerPosition_bottomRight:
        {
            if (point.x > quad.bottomLeft.x && point.x > quad.topLeft.x && point.y > quad.topRight.y && point.y > quad.topLeft.y){
                UIBezierPath *path  = [UIBezierPath new];
                [path moveToPoint:quad.topRight];
                [path addLineToPoint:quad.topLeft];
                [path addLineToPoint:quad.bottomLeft];
                [path closePath];
                
                isConcave = [path containsPoint:point];
            } else {
                isConcave = YES;
            }
        }
            break;
            
        default:
            break;
    }
    return isConcave;
}

#pragma mark -- Convenience

- (ZMQuadrilateral *)update:(ZMQuadrilateral *)quad
                   position:(CGPoint)position
                  forCorner:(ZMCornerPosition)corner {
    switch (corner) {
        case ZMCornerPosition_topLeft:
            quad.topLeft = position;
            break;
        case ZMCornerPosition_topRight:
            quad.topRight = position;
            break;
        case ZMCornerPosition_bottomLeft:
            quad.bottomLeft = position;
            break;
        case ZMCornerPosition_bottomRight:
            quad.bottomRight = position;
            break;
            
        default:
            break;
    }
    return quad;
}

#pragma mark -- getter
- (CAShapeLayer *)quadLayer {
    if (_quadLayer == nil) {
        _quadLayer = [[CAShapeLayer alloc] init];
        _quadLayer.strokeColor = [UIColor whiteColor].CGColor;
        _quadLayer.lineWidth = 1.0;
        _quadLayer.opacity = 1.0;
        _quadLayer.hidden = YES;
    }
    return _quadLayer;
}
- (UIView *)quadView {
    if (_quadView == nil) {
        _quadView = [[UIView alloc] init];
        _quadView.backgroundColor = [UIColor clearColor];
        _quadView.translatesAutoresizingMaskIntoConstraints = false;
    }
    return _quadView;
}
- (ZMEditScanCornerView *)topLeftCornerView {
    if (_topLeftCornerView == nil) {
        
        CGRect frame = CGRectMake(0, 0, self.cornerViewSize.width, self.cornerViewSize.height);
        _topLeftCornerView = [[ZMEditScanCornerView alloc] initWithFrame:frame position:(ZMCornerPosition_topLeft)];
    }
    return _topLeftCornerView;
}
- (ZMEditScanCornerView *)topRightCornerView {
    if (_topRightCornerView == nil) {
        
        CGRect frame = CGRectMake(0, 0, self.cornerViewSize.width, self.cornerViewSize.height);
        _topRightCornerView = [[ZMEditScanCornerView alloc] initWithFrame:frame position:(ZMCornerPosition_topRight)];
    }
    return _topRightCornerView;
}
- (ZMEditScanCornerView *)bottomLeftCornerView {
    if (_bottomLeftCornerView == nil) {
        
        CGRect frame = CGRectMake(0, 0, self.cornerViewSize.width, self.cornerViewSize.height);
        _bottomLeftCornerView = [[ZMEditScanCornerView alloc] initWithFrame:frame position:(ZMCornerPosition_bottomLeft)];
    }
    return _bottomLeftCornerView;
}
- (ZMEditScanCornerView *)bottomRightCornerView {
    if (_bottomRightCornerView == nil) {
        
        CGRect frame = CGRectMake(0, 0, self.cornerViewSize.width, self.cornerViewSize.height);
        _bottomRightCornerView = [[ZMEditScanCornerView alloc] initWithFrame:frame position:(ZMCornerPosition_bottomRight)];
    }
    return _bottomRightCornerView;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.quadView.frame = self.bounds;
    self.quadLayer.frame = self.bounds;
    if (self.quad){
        [self drawQuadrilateral:self.quad animated:false];
    }
}

- (void)dealloc {
    NSLog(@"dealloc ---- %@",self);
}

@end
