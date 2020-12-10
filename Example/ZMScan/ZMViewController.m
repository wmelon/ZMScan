//
//  ZMViewController.m
//  ZMScan
//
//  Created by wmelon on 12/07/2020.
//  Copyright (c) 2020 wmelon. All rights reserved.
//

#import "ZMViewController.h"
//#import <WeScan/WeScan.h>
//#import <WeScan-Swift.h>
#import "ZMImageScannerViewController.h"

@interface ZMViewController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate,ZMScannerControllerDelegate>
@property (nonatomic, strong) UIButton *btn;
@end

@implementation ZMViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.

    [self.view addSubview:self.btn];
}
- (void)butClick:(UIButton *)button {
    [self selectImage];
}
- (void)selectImage {
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.delegate = self;
    imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    [self presentViewController:imagePicker animated:YES completion:nil];
}

#pragma mark -- ZMScannerControllerDelegate

- (void)imageScannerController:(ZMImageScannerViewController *)scanner didFinishScanningWithResults:(ZMImageScannerResults *)results {
    NSLog(@"%@",results);
}

- (void)imageScannerControllerDidCancel:(ZMImageScannerViewController *)scanner {
    NSLog(@"取消了");
}

- (void)imageScannerController:(ZMImageScannerViewController *)scanner didFailWithError:(NSError *)error {
    NSLog(@"%@",error);
}


#pragma mark -- image picker delegate
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:nil];
}
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<UIImagePickerControllerInfoKey,id> *)info {
    [picker dismissViewControllerAnimated:YES completion:^{
        
        UIImage *editedImage, *originalImage;
        
        editedImage = [info objectForKey:UIImagePickerControllerEditedImage];
        originalImage = [info objectForKey:UIImagePickerControllerOriginalImage];
    
        ZMImageScannerViewController *scannerViewController = [[ZMImageScannerViewController alloc] initWithImage:originalImage delegate:self];
        [self presentViewController:scannerViewController animated:YES completion:nil];
    }];
}

- (UIButton *)btn {
    if (!_btn) {
        _btn = [[UIButton alloc] initWithFrame:CGRectMake(10, 30, 100, 100)];
        _btn.backgroundColor = [UIColor redColor];
        [_btn setTitle:@"选择照片" forState:(UIControlStateNormal)];
        [_btn addTarget:self action:@selector(butClick:) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _btn;
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
