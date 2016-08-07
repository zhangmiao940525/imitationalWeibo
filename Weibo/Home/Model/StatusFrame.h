//
//  StatusFrm.h
//  Weibo
//
//  Created by ZHANGMIA on 7/20/16.
//  Copyright © 2016 ZHANGMIA. All rights reserved.
//  1. 存放着一个cell内部的子控件的Frame数据
//  2. 存放一个cell的高度
//  3. 存放着一个数据模型的Status

#import <Foundation/Foundation.h>
@class Status;

// 昵称字体
#define StatusCellNameFont [UIFont systemFontOfSize:15]
// 时间字体
#define StatusCellTimeFont [UIFont systemFontOfSize:12]
// 来源字体
#define StatusCellSourceFont [UIFont systemFontOfSize:12]
// 正文字体
#define StatusCellContentFont [UIFont systemFontOfSize:14]
// 被转发微博的正文字体
#define StatusCellRetweetContentFont [UIFont systemFontOfSize:13]
// cell之间的间距
#define StatusCellMargin 15
// cell的边框宽度
#define StatusCellBorderW 10

@interface StatusFrame : NSObject

// 微博模型
@property (nonatomic,strong)Status *status;

/* 原创微博整体 */
@property (nonatomic,assign)CGRect originalViewFrm;
/* 头像 */
@property (nonatomic,assign)CGRect iconViewFrm;
/* 会员图标 */
@property (nonatomic,assign)CGRect vipViewFrm;
/* 配图 */
@property (nonatomic,assign)CGRect photosViewFrm;
/* 昵称 */
@property (nonatomic,assign)CGRect nameLabelFrm;
/* 时间 */
@property (nonatomic,assign)CGRect timeLabelFrm;
/* 来源 */
@property (nonatomic,assign)CGRect sourceLabelFrm;
/* 正文 */
@property (nonatomic,assign)CGRect contentLabelFrm;

/* 转发微博 */

/** 转发微博整体 */
@property (nonatomic,assign)CGRect retweetViewFrm;
/** 转发微博正文 */
@property (nonatomic,assign)CGRect retweetContentLabelFrm;
/** 转发微博配图 */
@property (nonatomic,assign)CGRect retweetPhotosViewFrm;

/** 底部工具条 */
@property (nonatomic,assign)CGRect toolbarFrm;
/* cell 高度 */
@property (nonatomic,assign)CGFloat cellHeight;

@end
