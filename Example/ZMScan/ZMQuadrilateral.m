//
//  ZMQuadrilateral.m
//  ZMScan_Example
//
//  Created by Sper on 2020/12/7.
//  Copyright © 2020 wmelon. All rights reserved.
//

#import "ZMQuadrilateral.h"
#import <AVFoundation/AVFoundation.h>
#import "ZMUtils.h"

@implementation ZMQuadrilateral

- (instancetype)initWithRectangleFeature:(CIRectangleFeature *_Nonnull)rectangleFeature {
    if (self = [super init]) {
        _topLeft = rectangleFeature.topLeft;
        _topRight = rectangleFeature.topRight;
        _bottomLeft = rectangleFeature.bottomLeft;
        _bottomRight = rectangleFeature.bottomRight;
    }
    return self;
}

- (instancetype)initWithRectangleObservation:(VNRectangleObservation *)rectangleObservation  API_AVAILABLE(ios(11.0)){
    if (self = [super init]) {
        _topLeft = rectangleObservation.topLeft;
        _topRight = rectangleObservation.topRight;
        _bottomLeft = rectangleObservation.bottomLeft;
        _bottomRight = rectangleObservation.bottomRight;
    }
    return self;
}

- (instancetype)initWithTopLeft:(CGPoint)topLeft
                       topRight:(CGPoint)topRight
                    bottomRight:(CGPoint)bottomRight
                     bottomLeft:(CGPoint)bottomLeft {
    if (self = [super init]) {
        _topLeft = topLeft;
        _topRight = topRight;
        _bottomRight = bottomRight;
        _bottomLeft = bottomLeft;
    }
    return self;
}

- (UIBezierPath *)path {
    UIBezierPath *path  = [UIBezierPath new];
    [path moveToPoint:self.topLeft];
    [path addLineToPoint:self.topRight];
    [path addLineToPoint:self.bottomRight];
    [path addLineToPoint:self.bottomLeft];
    [path closePath];
    return path;
}

/// 四边形周长
- (CGFloat)perimeter {
    CGFloat perimeter = [ZMUtils distancePoint:self.topLeft toPoint:self.topRight] + [ZMUtils distancePoint:self.topRight toPoint:self.bottomRight] + [ZMUtils distancePoint:self.bottomLeft toPoint:self.topLeft];
    return perimeter;
}

- (nonnull instancetype)applyingWithTransform:(CGAffineTransform)transForm {
    
    return [[ZMQuadrilateral alloc] initWithTopLeft:CGPointApplyAffineTransform(self.topLeft, transForm)
                                           topRight:CGPointApplyAffineTransform(self.topRight, transForm)
                                        bottomRight:CGPointApplyAffineTransform(self.bottomRight, transForm)
                                         bottomLeft:CGPointApplyAffineTransform(self.bottomLeft, transForm)];
}

- (instancetype)applyingWithTransforms:(NSArray<NSValue *> *)transforms {
    __block ZMQuadrilateral *transformableObject = self;
    [transforms enumerateObjectsUsingBlock:^(NSValue * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        CGAffineTransform transform = [obj CGAffineTransformValue];
        transformableObject = [transformableObject applyingWithTransform:transform];
    }];
    return transformableObject;
}

- (BOOL)isWithin:(CGFloat)distance rectangleFeature:(ZMQuadrilateral *)rectangleFeature {
    
    CGRect topLeftRect = [self surroundingSquare:distance point:self.topLeft];
    if (!CGRectContainsPoint(topLeftRect, rectangleFeature.topLeft)) {
        return false;
    }
    
    CGRect topRightRect = [self surroundingSquare:distance point:self.topRight];
    if (!CGRectContainsPoint(topRightRect, rectangleFeature.topRight)) {
        return false;
    }
    
    CGRect bottomLeftRect = [self surroundingSquare:distance point:self.bottomLeft];
    if (!CGRectContainsPoint(bottomLeftRect, rectangleFeature.bottomLeft)) {
        return false;
    }
    
    CGRect bottomRightRect = [self surroundingSquare:distance point:self.bottomRight];
    if (!CGRectContainsPoint(bottomRightRect, rectangleFeature.bottomRight)) {
        return false;
    }
    
    return true;
}

- (void)reorganize {
    NSArray<NSNumber *> *points = @[@(self.topLeft), @(self.topRight), @(self.bottomRight), @(self.bottomLeft)];

    NSArray *ySortedPoints = [self sortPointsByYValue:points];
    if (ySortedPoints.count != 4) return;


    NSArray *topMostPoints = [ySortedPoints subarrayWithRange:NSMakeRange(0, 2)];
    NSArray *bottomMostPoints = [ySortedPoints subarrayWithRange:NSMakeRange(2, 2)];
    NSArray *xSortedTopMostPoints = [self sortPointsByXValue:topMostPoints];
    NSArray *xSortedBottomMostPoints = [self sortPointsByXValue:bottomMostPoints];

    if (xSortedTopMostPoints.count <= 1 || xSortedBottomMostPoints.count <= 1){
        return;
    }

    _topLeft = [xSortedTopMostPoints[0] CGPointValue];
    _topRight = [xSortedTopMostPoints[1] CGPointValue];
    _bottomRight = [xSortedBottomMostPoints[1] CGPointValue];
    _bottomLeft = [xSortedBottomMostPoints[0] CGPointValue];
}

- (ZMQuadrilateral *)scale:(CGSize)fromSize toSize:(CGSize)toSize rotationAngle:(CGFloat)rotationAngle {

    CGSize invertedfromSize = fromSize;
    CGFloat rotated = rotationAngle != 0.0;

    if (rotated && rotationAngle != M_PI){
        invertedfromSize = CGSizeMake(fromSize.height, fromSize.width);
    }

    CGFloat invertedFromSizeWidth = invertedfromSize.width == 0 ? 0.0 : invertedfromSize.width;
    CGFloat invertedFromSizeHeight = invertedfromSize.height == 0 ? 0.0 : invertedfromSize.height;

    CGFloat scaleWidth = toSize.width / invertedFromSizeWidth;
    CGFloat scaleHeight = toSize.height / invertedFromSizeHeight;

    ZMQuadrilateral *transformedQuad = self;
    CGAffineTransform scaledTransform = CGAffineTransformMakeScale(scaleWidth, scaleHeight);
    transformedQuad = [transformedQuad applyingWithTransform:scaledTransform];

    if (rotated) {
        CGAffineTransform rotationTransform = CGAffineTransformRotate(CGAffineTransformIdentity, rotationAngle);
        
        CGRect fromImageBounds = CGRectApplyAffineTransform(CGRectMake(0, 0, fromSize.width, fromSize.height), scaledTransform);
        
        CGRect toImageBounds = CGRectMake(0, 0, toSize.width, toSize.height);
        
        CGAffineTransform translationTransform = translationTransform = [self translateTransform:fromImageBounds toRect:toImageBounds];
        
        
        NSValue *rotationTransformValue = [NSValue valueWithCGAffineTransform:rotationTransform];
        NSValue *translationTransformValue = [NSValue valueWithCGAffineTransform:translationTransform];
        
        transformedQuad = [transformedQuad applyingWithTransforms:@[rotationTransformValue,translationTransformValue]];
    }
    return transformedQuad;
}

- (CGAffineTransform)translateTransform:(CGRect)fromRect toRect:(CGRect)toRect {
    CGFloat pointX = CGRectGetMidX(toRect) - CGRectGetMidX(fromRect);
    CGFloat pointY = CGRectGetMidY(toRect) - CGRectGetMidY(fromRect);
    return CGAffineTransformMakeTranslation(pointX, pointY);
}

- (NSArray *)sortPointsByYValue:(NSArray<NSNumber *> *)points {
    return [points sortedArrayUsingComparator:^NSComparisonResult(NSNumber * _Nonnull obj1, NSNumber * _Nonnull obj2) {
        CGPoint point1 = [obj1 CGPointValue];
        CGPoint point2 = [obj2 CGPointValue];
        
        return [@(point1.y) compare:@(point2.y)];
    }];
}
- (NSArray *)sortPointsByXValue:(NSArray *)points {
    return [points sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        CGPoint point1 = [obj1 CGPointValue];
        CGPoint point2 = [obj2 CGPointValue];
        
        return [@(point1.x) compare:@(point2.x)];
    }];
}

- (CGRect)surroundingSquare:(CGFloat)size point:(CGPoint)point{
    return CGRectMake(point.x - size / 2.0, point.y - size / 2.0, size, size);
}
- (CGPoint)cartesian:(CGFloat)height point:(CGPoint)point {
    return CGPointMake(point.x, height - point.y);
}

- (instancetype)toCartesian:(CGFloat)height {
    CGPoint topLeft = [self cartesian:height point:self.topLeft];
    CGPoint topRight = [self cartesian:height point:self.topRight];
    CGPoint bottomRight = [self cartesian:height point:self.bottomRight];
    CGPoint bottomLeft = [self cartesian:height point:self.bottomLeft];
    
    return [[ZMQuadrilateral alloc] initWithTopLeft:topLeft topRight:topRight bottomRight:bottomRight bottomLeft:bottomLeft];
}

@end
