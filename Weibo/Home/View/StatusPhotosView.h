//
//  StatusPhotosView.h
//  Weibo
//
//  Created by ZHANGMIA on 7/30/16.
//  Copyright © 2016 ZHANGMIA. All rights reserved.
//  cell上面的配图相册（里面会显示1～9张图片,里面都是photoView）

#import <UIKit/UIKit.h>

@interface StatusPhotosView : UIView
/**
 *  图片数据（里面都是Photo模型）
 */
@property (nonatomic,strong)NSArray *photos;
/**
 根据图片个数计算相册尺寸
 */
+ (CGSize)sizeWithCount:(NSUInteger)count;

@end
