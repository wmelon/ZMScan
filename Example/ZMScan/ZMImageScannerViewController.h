//
//  ZMImageScannerViewController.h
//  ZMScan_Example
//
//  Created by Sper on 2020/12/7.
//  Copyright © 2020 wmelon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZMImageScannerResults.h"

NS_ASSUME_NONNULL_BEGIN
@class ZMImageScannerViewController;

@protocol ZMScannerControllerDelegate <NSObject>

- (void)imageScannerController:(ZMImageScannerViewController *)scanner didFinishScanningWithResults:(ZMImageScannerResults *)results;

- (void)imageScannerControllerDidCancel:(ZMImageScannerViewController *)scanner;

- (void)imageScannerController:(ZMImageScannerViewController *)scanner didFailWithError:(NSError *)error;

@end

@interface ZMImageScannerViewController : UINavigationController

- (instancetype)initWithImage:(UIImage *)image delegate:(id<ZMScannerControllerDelegate>)delegate;

@end

NS_ASSUME_NONNULL_END
