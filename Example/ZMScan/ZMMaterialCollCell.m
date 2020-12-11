//
//  ZMMaterialCollCell.m
//  ZMScan_Example
//
//  Created by Sper on 2020/12/10.
//  Copyright © 2020 wmelon. All rights reserved.
//

#import "ZMMaterialCollCell.h"

@interface ZMMaterialCollCell()
@property (nonatomic, strong) UIImageView *imageV;
@property (nonatomic, strong) UIImage *image;
@property (nonatomic, copy  ) ZMCollCellSelectHandle handle;
@end

@implementation ZMMaterialCollCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self.contentView addSubview:self.imageV];
    }
    return self;
}

- (void)showImage:(UIImage *)image selectHandle:(ZMCollCellSelectHandle)handle {
    self.image = image;
    self.handle = handle;
    
    self.imageV.image = image;
}

- (UIImageView *)imageV {
    if (!_imageV) {
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        imageView.clipsToBounds = true;
        imageView.opaque = true;
        _imageV = imageView;
    }
    return _imageV;
}
- (void)layoutSubviews {
    [super layoutSubviews];
    self.imageV.frame = self.bounds;
}

@end
