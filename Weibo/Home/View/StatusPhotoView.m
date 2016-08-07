//
//  StatusPhotoView.m
//  Weibo
//
//  Created by ZHANGMIA on 7/31/16.
//  Copyright © 2016 ZHANGMIA. All rights reserved.
//

#import "StatusPhotoView.h"
#import "Photo.h"

@interface StatusPhotoView()

@property (nonatomic,weak)UIImageView *gifView;

@end

@implementation StatusPhotoView
- (UIImageView *)gifView
{
    if (!_gifView) {
        UIImage *image = [UIImage imageNamed:@"timeline_image_gif"];
        UIImageView *gifView = [[UIImageView alloc] initWithImage:image];
        [self addSubview:gifView];
        self.gifView = gifView;
    }
    return _gifView;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.userInteractionEnabled = YES;
        // 内容模式 按图片比例拉伸
        self.contentMode = UIViewContentModeScaleAspectFill;
        // 超出边框的内容都剪掉
        self.clipsToBounds = YES;
    }
    return self;
}

- (void)setPhoto:(Photo *)photo
{
    _photo = photo;
    // 设置图片
     [self sd_setImageWithURL:[NSURL URLWithString:photo.thumbnail_pic] placeholderImage:[UIImage imageNamed:@"timeline_image_placeholder"]];
    //判断是否以gif或GIF结尾
    self.gifView.hidden = ![photo.thumbnail_pic.lowercaseString hasSuffix:@"gif"];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    // 设置子控件尺寸
    self.gifView.x = self.width - self.gifView.width;
    self.gifView.y = self.height - self.gifView.height;
}

/**
 UIViewContentModeScaleToFill : 图片拉伸至填充整个UIImageView（图片可能会变形）
 
 UIViewContentModeScaleAspectFit : 图片拉伸至完全显示在UIImageView里面为止（图片不会变形）
 
 UIViewContentModeScaleAspectFill :
 图片拉伸至 图片的宽度等于UIImageView的宽度 或者 图片的高度等于UIImageView的高度 为止
 
 经验规律：
 1.凡是带有Scale单词的，图片都会拉伸
 2.凡是带有Aspect单词的，图片都会保持原来的宽高比，图片不会变形
 */
@end
