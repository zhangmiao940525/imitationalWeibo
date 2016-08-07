//
//  ComposePhotosView.m
//  Weibo
//
//  Created by ZHANGMIA on 8/1/16.
//  Copyright © 2016 ZHANGMIA. All rights reserved.
//

#import "ComposePhotosView.h"

@interface ComposePhotosView ()

@end

@implementation ComposePhotosView

//- (NSMutableArray *)addedPhotos
//{
//    if (!_addedPhotos) {
//        self.addedPhotos = [NSMutableArray array];
//    }
//    return _addedPhotos;
//    
//}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _photos = [NSMutableArray array];
    }
    return self;
}

- (void)addPhoto:(UIImage *)photo
{
    UIImageView *photoView = [[UIImageView alloc] init];
    photoView.image = photo;
    [self addSubview:photoView];
    // 存储照片
    [self.photos addObject:photo];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    // 设置图片尺寸和位置
    NSUInteger count = self.subviews.count;
    int maxCol = 4;
    CGFloat PhotoWH = 70;
    CGFloat PhotoMargin = 10;

    for (int i = 0; i < count; i++) {
        UIImageView *photoView = self.subviews[i];
        // 列
        int col = i % maxCol;
        photoView.x = col *(PhotoWH + PhotoMargin);
        // 行
        int row = i / maxCol;
        photoView.y = row * (PhotoWH + PhotoMargin);
        
        photoView.width = PhotoWH;
        photoView.height = PhotoWH;
    }
}

//- (NSArray *)photos
//{
//    NSMutableArray *photos = [NSMutableArray array];
//    for (UIImageView *imageView in self.subviews) {
//        [photos addObject:imageView.image];
//    }
//    return photos;
//}



@end
