//
//  StatusPhotosView.m
//  Weibo
//
//  Created by ZHANGMIA on 7/30/16.
//  Copyright © 2016 ZHANGMIA. All rights reserved.
//

#import "StatusPhotosView.h"
#import "Photo.h"
#import "StatusPhotoView.h"

#import "MJPhotoBrowser.h"
#import "MJPhoto.h"

// 配图的宽高
#define StatusPhotoWH 70
// 配图的间距
#define StatusPhotoMargin 10
// 微博图片最大列数
#define StatusPhotoMaxCol(count) ((count==4)?2:3)

@interface StatusPhotosView ()

@property (nonatomic, weak) UIImageView *imageView;
@property (nonatomic, assign) CGRect lastFrame;

@end

@implementation StatusPhotosView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.userInteractionEnabled = YES;
    }
    return self;
}

- (void)setPhotos:(NSArray *)photos
{
    _photos = photos;
    
    int photosCount = (int)photos.count;
    
    // 创建足够数量的图片控件
    while(self.subviews.count < photosCount) {
        self.userInteractionEnabled = YES;
        StatusPhotoView *photoView = [[StatusPhotoView alloc] init];
        [self addSubview:photoView];
    }
    // 遍历所有的图片控件, 设置图片
    for (int i = 0; i < self.subviews.count; i++) {
        StatusPhotoView *photoView = self.subviews[i];
        photoView.tag = i;
        // 添加手势
        UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] init];
        [recognizer addTarget:self action:@selector(tapPhoto:)];
        [photoView addGestureRecognizer:recognizer];
        
        if (i < photosCount) { // 显示配图
            photoView.photo = photos[i];
            photoView.hidden = NO;
            
        } else { // 隐藏
            photoView.hidden = YES;
        }
    }
}
/**
 *  监听图片的点击
 */
- (void)tapPhoto:(UITapGestureRecognizer *)recognizer
{
    // 1.创建图片浏览器
    MJPhotoBrowser *browser = [[MJPhotoBrowser alloc] init];
    
    // 2. 设置图片浏览器显示的所有图片
    NSMutableArray *photos = [NSMutableArray array];
    int count = (int)self.photos.count;
    for (int i = 0; i < count; i++) {
        Photo *pic = self.photos[i];
        MJPhoto *photo = [[MJPhoto alloc] init];
        // 设置图片的路径
        photo.url = [NSURL URLWithString:pic.bmiddle_pic];
        // 设置来源于哪一个UIImageView
        photo.srcImageView = self.subviews[i];
        [photos addObject:photo];
    }
    browser.photos = photos;
    
    // 3. 设置默认显示的图片索引
    browser.currentPhotoIndex = recognizer.view.tag;
    
    // 4. 显示浏览器
    [browser show];
    
}

- (void)tapCover:(UITapGestureRecognizer *)recognizer
{
    [UIView animateWithDuration:0.25 animations:^{
        recognizer.view.backgroundColor = [UIColor clearColor];
        self.imageView.frame = self.lastFrame;
    } completion:^(BOOL finished) {
        [recognizer.view removeFromSuperview];
        self.imageView = nil;
    }];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    // 设置图片尺寸和位置
    int photosCount = (int)self.photos.count;
    int maxCol = StatusPhotoMaxCol(photosCount);
    for (int i = 0; i < photosCount; i++) {
        StatusPhotosView *photoView = self.subviews[i];
        int col = i % maxCol;
        photoView.x = col *(StatusPhotoWH + StatusPhotoMargin);
        int row = i / maxCol;
        photoView.y = row * (StatusPhotoWH + StatusPhotoMargin);
        photoView.width = StatusPhotoWH;
        photoView.height = StatusPhotoWH;
    }
}


+ (CGSize)sizeWithCount:(NSUInteger)count
{
    // 一行最多有多少列(最大列数)
    int maxCols = StatusPhotoMaxCol(count);
    int cols = (count >= maxCols)?maxCols:(int)count;
    CGFloat photosW = cols*StatusPhotoWH + (cols-1)*StatusPhotoMargin;
    
    // 行数
    int rows = (int)(count + maxCols - 1) / maxCols;
    CGFloat photosH = rows*StatusPhotoWH + (rows-1)*StatusPhotoMargin;
    
    return CGSizeMake(photosW, photosH);
}

//    // 1. 添加一个遮盖
//    UIView *cover = [[UIView alloc] init];
//    cover.frame = [UIScreen mainScreen].bounds;
//    cover.backgroundColor = [UIColor blackColor];
//    // 给遮盖添加手势
//    [cover addGestureRecognizer: [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapCover:)]];
//    // 将遮盖添加到窗口
//    [[UIApplication sharedApplication].keyWindow addSubview:cover];
//
//    // 2. 添加图片到遮盖上
//    StatusPhotoView *photoView = (StatusPhotoView *)recognizer.view;
//    UIImageView *imageView = [[UIImageView alloc] init];
//    [imageView sd_setImageWithURL:[NSURL URLWithString:photoView.photo.bmiddle_pic] placeholderImage:photoView.image];
//    // 将photoView.frame从self坐标系转为cover坐标系
//    imageView.frame = [cover convertRect:photoView.frame fromView:self];
//    self.lastFrame = imageView.frame;
//    [cover addSubview:imageView];
//    self.imageView = imageView;
//
//    // 3. 放大
//    [UIView animateWithDuration:0.25 animations:^{
//        CGRect frame = imageView.frame;
//        frame.size.width = cover.width; // 占据整个屏幕
//        frame.size.height = frame.size.width * (imageView.image.size.height / imageView.image.size.width);
//        frame.origin.x = 0;
//        frame.origin.y = (cover.height - frame.size.height) * 0.5;
//        imageView.frame = frame;
//    }];

@end
