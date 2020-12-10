//
//  ZMQuadrilateralView.h
//  ZMScan_Example
//
//  Created by Sper on 2020/12/8.
//  Copyright © 2020 wmelon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "ZMQuadrilateral.h"
#import "ZMEditScanCornerView.h"

NS_ASSUME_NONNULL_BEGIN

@interface ZMQuadrilateralView : UIView

/// 边框和顶点的颜色
@property (nonatomic, assign) CGColorRef strokeColor;
/// 四边形四个顶点是否可以编辑
@property (nonatomic, assign) BOOL editable;
/// 四边形顶点数据
@property (nonatomic, strong, readonly) ZMQuadrilateral *quad;

/// 绘制四边形
/// @param quad 四边形需要的四个顶点数据
/// @param animated 是否需要动画
- (void)drawQuadrilateral:(ZMQuadrilateral *)quad animated:(BOOL)animated;

/// 重置四个顶点不放大拖拽
- (void)resetHighlightedCornerViews;

/// 根据点获取顶点视图
/// @param position
- (ZMEditScanCornerView *)cornerViewForCornerPosition:(ZMCornerPosition)position;

/// 移动指定的顶点到某个位置
/// @param cornerView 顶点视图
/// @param point 移动到的位置
- (void)moveCorner:(ZMEditScanCornerView *)cornerView point:(CGPoint)point;

/// 指定顶点高亮状态（高亮状态代表可以拖拽）
/// @param position 某个点
/// @param image 高亮的点显示放大的图片
- (void)highlightCornerAtPosition:(ZMCornerPosition)position image:(UIImage *)image;

@end

NS_ASSUME_NONNULL_END
