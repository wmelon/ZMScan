//
//  ZMMaterialCollCell.h
//  ZMScan_Example
//
//  Created by Sper on 2020/12/10.
//  Copyright © 2020 wmelon. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class ZMMaterialCollCell;

typedef void(^ZMCollCellSelectHandle)(ZMMaterialCollCell *cell,UIImage *image);

@interface ZMMaterialCollCell : UICollectionViewCell
- (void)showImage:(UIImage *)image selectHandle:(ZMCollCellSelectHandle)handle;
@end

NS_ASSUME_NONNULL_END
