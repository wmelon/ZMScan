//
//  ZMZoomGestureController.m
//  ZMScan_Example
//
//  Created by Sper on 2020/12/9.
//  Copyright © 2020 wmelon. All rights reserved.
//

#import "ZMZoomGestureController.h"
#import "UIImage+ZMOrientation.h"
#import "ZMUtils.h"

@interface ZMZoomGestureController ()
@property (nonatomic, strong) UIImage *image;
@property (nonatomic, strong) ZMQuadrilateralView *quadView;

@property (nonatomic, assign) CGPoint previousPanPosition;
@property (nonatomic, assign) ZMCornerPosition closestCorner;

/// 获取到最近的点
@property (nonatomic, assign) BOOL hasGetClosest;
@end

@implementation ZMZoomGestureController

- (instancetype)initWithImage:(UIImage *)image quadView:(ZMQuadrilateralView *)quadView {
    if (self = [super init]) {
        _image = image;
        _quadView = quadView;
        
        _touchDown = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanGesture:)];
        _touchDown.minimumPressDuration = 0;
    }
    return self;
}

#pragma mark -- 监听手势
- (void)handlePanGesture:(UIGestureRecognizer *)pan {
    ZMQuadrilateral *drawnQuad = self.quadView.quad;
    if (!drawnQuad) return;
    
    /// 停止手势重置数据
    if (pan.state == UIGestureRecognizerStateEnded) {
        self.previousPanPosition = CGPointZero;
        self.hasGetClosest = false;
        [self.quadView resetHighlightedCornerViews];
        return;
    }
    
    CGPoint position = [pan locationInView:self.quadView];
    
    /// 最近移动的顶点，防止移动过程中重复计算获取影响效率
    if (self.hasGetClosest == false) {
        self.closestCorner = [self closestCornerFromQuad:drawnQuad point:position];
        self.hasGetClosest = true;
    }
    
    /// 获取需要移动的顶点视图
    ZMEditScanCornerView *cornerView = [self.quadView cornerViewForCornerPosition:self.closestCorner];
    
    if (self.previousPanPosition.x > 0 || self.previousPanPosition.y > 0) { /// 有真实值才可以开始移动
        CGAffineTransform offset = CGAffineTransformMakeTranslation(position.x - self.previousPanPosition.x, position.y - self.previousPanPosition.y);
        
        /// 开始移动顶点
        CGPoint draggedCornerViewCenter = CGPointApplyAffineTransform(cornerView.center, offset);
        [self.quadView moveCorner:cornerView point:draggedCornerViewCenter];
        
        /// 根据当前的顶点坐标中心放大图片
        CGFloat scale = self.image.size.width / self.quadView.bounds.size.width;
        CGPoint scaledDraggedCornerViewCenter = CGPointMake(draggedCornerViewCenter.x * scale, draggedCornerViewCenter.y * scale);
        
        UIImage *zoomedImage = [self.image scaledImage:scaledDraggedCornerViewCenter scaleFactor:2.5 targetSize:self.quadView.bounds.size];
        if (!zoomedImage) {
            return;
        }
        
        /// 移动过程中高亮并且放大图片
        [self.quadView highlightCornerAtPosition:self.closestCorner image:zoomedImage];
        
    }
    self.previousPanPosition = position;
}


/// 获取当前正在移动的点
/// @param quad 四个点的对象
/// @param point 手势触摸的点
- (ZMCornerPosition)closestCornerFromQuad:(ZMQuadrilateral *)quad point:(CGPoint)point{
    
    CGFloat smallestDistance = [ZMUtils distancePoint:point toPoint:quad.topLeft];
    
    ZMCornerPosition closestCorner = ZMCornerPosition_topLeft;
    
    if ([ZMUtils distancePoint:point toPoint:quad.topRight] < smallestDistance){
        smallestDistance = [ZMUtils distancePoint:point toPoint:quad.topRight];
        closestCorner = ZMCornerPosition_topRight;
    }
    
    if ([ZMUtils distancePoint:point toPoint:quad.bottomRight] < smallestDistance){
        smallestDistance = [ZMUtils distancePoint:point toPoint:quad.bottomRight];
        closestCorner = ZMCornerPosition_bottomRight;
    }
    
    if ([ZMUtils distancePoint:point toPoint:quad.bottomLeft] < smallestDistance){
        smallestDistance = [ZMUtils distancePoint:point toPoint:quad.bottomLeft];
        closestCorner = ZMCornerPosition_bottomLeft;
    }
    
    return closestCorner;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
- (void)dealloc {
    NSLog(@"dealloc ---- %@",self);
}

@end
