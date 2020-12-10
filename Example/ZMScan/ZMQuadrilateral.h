//
//  ZMQuadrilateral.h
//  ZMScan_Example
//
//  Created by Sper on 2020/12/7.
//  Copyright © 2020 wmelon. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Vision/Vision.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZMQuadrilateral : NSObject

/// 四边形的周长
@property (nonatomic, assign, readonly) CGFloat perimeter;

/// 四边形边框的路径
@property (nonatomic, strong, readonly) UIBezierPath *path;
@property (nonatomic, assign) CGPoint topLeft;
@property (nonatomic, assign) CGPoint topRight;
@property (nonatomic, assign) CGPoint bottomRight;
@property (nonatomic, assign) CGPoint bottomLeft;

/// 初始化四边形数据对象
/// @param rectangleFeature 识别的矩形区域
- (instancetype)initWithRectangleFeature:(CIRectangleFeature * _Nonnull)rectangleFeature;

/// 初始化四边形数据对象
/// @param rectangleObservation iOS 11以上版本识别矩形区域
- (instancetype)initWithRectangleObservation:(VNRectangleObservation *)rectangleObservation API_AVAILABLE(ios(11.0));

/// 四边形四个点坐标进行转换
/// @param transForm 矩阵转换
- (instancetype)applyingWithTransform:(CGAffineTransform)transForm;

/// NSValue 必须是 CGAffineTransform类型
- (instancetype)applyingWithTransforms:(NSArray<NSValue *> *)transforms;

/// 初始化
/// @param topLeft
/// @param topRight
/// @param bottomRight
/// @param bottomLeft
- (instancetype)initWithTopLeft:(CGPoint)topLeft
                       topRight:(CGPoint)topRight
                    bottomRight:(CGPoint)bottomRight
                     bottomLeft:(CGPoint)bottomLeft;

/// 根据高度 笛卡儿 四个点的坐标
/// @param height
- (instancetype)toCartesian:(CGFloat)height;

/// 旋转缩放
/// @param fromSize 原始大小
/// @param toSize 指定大小
/// @param rotationAngle 旋转角度
- (ZMQuadrilateral *)scale:(CGSize)fromSize
                    toSize:(CGSize)toSize
             rotationAngle:(CGFloat)rotationAngle;


/// 根据point 的 （x，y）值大小重新组合四个点
- (void)reorganize;

@end

NS_ASSUME_NONNULL_END
