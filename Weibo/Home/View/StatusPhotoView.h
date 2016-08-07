//
//  StatusPhotoView.h
//  Weibo
//
//  Created by ZHANGMIA on 7/31/16.
//  Copyright © 2016 ZHANGMIA. All rights reserved.
//  一张配图

#import <UIKit/UIKit.h>
@class Photo;
@interface StatusPhotoView : UIImageView
/** 一张配图 */
@property (nonatomic,strong) Photo *photo;

@end
