//
//  ZMReviewViewController.h
//  ZMScan_Example
//
//  Created by Sper on 2020/12/9.
//  Copyright © 2020 wmelon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZMImageScannerResults.h"

NS_ASSUME_NONNULL_BEGIN

@interface ZMReviewViewController : UIViewController
- (instancetype)initWithResults:(ZMImageScannerResults *)results;
@end

NS_ASSUME_NONNULL_END
