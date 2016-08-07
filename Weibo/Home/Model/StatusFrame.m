//
//  StatusFrame.m
//  Weibo
//
//  Created by ZHANGMIA on 7/20/16.
//  Copyright © 2016 ZHANGMIA. All rights reserved.
//  一个StatusFrame模型里面包含的信息
//  1. 存放着一个cell内部的子控件的frame数据
//  2. 存放一个cell的高度
//  3. 存放着一个数据模型的Status

#import "StatusFrame.h"
#import "Status.h"
#import "User.h"
#import "NSString+Extension.h"
#import "StatusPhotosView.h"

// 配图的宽高
#define StatusPhotoWH 70
// 配图的间距
#define StatusPhotoMargin 10

@implementation StatusFrame

- (void)setStatus:(Status *)status
{
    _status = status;
    User *user = status.user;
    
    CGFloat cellW = [UIScreen mainScreen].bounds.size.width;
    /* 原创微博 */
    
    /* 头像 */
    CGFloat iconWH = 35;
    CGFloat iconX = StatusCellBorderW;
    CGFloat iconY = StatusCellBorderW;
    self.iconViewFrm = CGRectMake(iconX, iconY, iconWH, iconWH);
    
    /* 昵称 */
    CGFloat nameX = CGRectGetMaxX(self.iconViewFrm) + StatusCellBorderW;
    CGFloat nameY = iconY;
    CGSize nameSize = [user.name sizeWithFont:StatusCellNameFont];
    self.nameLabelFrm = (CGRect){{nameX,nameY}, nameSize};
    
    /* 会员图标 */
    if (status.user.isVip) {
        CGFloat vipX = CGRectGetMaxX(self.nameLabelFrm) + StatusCellBorderW;
        CGFloat vipY = nameY;
        CGFloat vipH = nameSize.height;
        CGFloat vipW = 14;
        self.vipViewFrm = CGRectMake(vipX, vipY, vipW, vipH);
    }
    
    /* 时间 */
    CGFloat timeX = nameX;
    CGFloat timeY = CGRectGetMaxY(self.nameLabelFrm) + StatusCellBorderW;
    CGSize timeSize = [status.created_at sizeWithFont:StatusCellTimeFont];
    self.timeLabelFrm = (CGRect){{timeX,timeY}, timeSize};
    
    /* 来源 */
    CGFloat sourceX = CGRectGetMaxX(self.timeLabelFrm) + StatusCellBorderW;
    CGFloat sourceY = timeY;
    CGSize sourceSize = [status.source sizeWithFont:StatusCellSourceFont];
    self.sourceLabelFrm = (CGRect){{sourceX,sourceY}, sourceSize};
    
    /* 正文 */
    CGFloat contentX = iconX;
    CGFloat contentY = MAX(CGRectGetMaxY(self.iconViewFrm), CGRectGetMaxY(self.timeLabelFrm)) + StatusCellBorderW;
    CGFloat maxW = cellW - 2 * contentX;
    CGSize contentSize = [status.text sizeWithFont:StatusCellContentFont maxW:maxW];
    self.contentLabelFrm = (CGRect){{contentX,contentY}, contentSize};
    
    /* 配图 */
    CGFloat originalH = 0;
    if (status.pic_urls.count) { // 有配图
        CGFloat photoX = contentX;
        CGFloat photoY = CGRectGetMaxY(self.contentLabelFrm) + StatusCellBorderW;
        CGSize photosSize = [StatusPhotosView sizeWithCount:status.pic_urls.count];
        self.photosViewFrm = (CGRect){{photoX, photoY}, photosSize};
        
        originalH = CGRectGetMaxY(self.photosViewFrm) + StatusCellBorderW;
    } else { // 没配图
        originalH = CGRectGetMaxY(self.contentLabelFrm) + StatusCellBorderW;
    }
    
    /* 原创微博整体 */
    CGFloat originalX = 0;
    CGFloat originalY = StatusCellMargin;
    CGFloat originalW = cellW;
    
    self.originalViewFrm = CGRectMake(originalX, originalY, originalW, originalH);
    
    
    CGFloat toolbarY = 0;
    /* 被转发微博 */
    if (status.retweeted_status) {
        // 取出转发微博
        Status *retweeted_status = status.retweeted_status;
        // 取出转发用户
        User *retweeted_status_user = retweeted_status.user;
        
        /** 被转发微博正文*/
        CGFloat retweetContentX = StatusCellBorderW;
        CGFloat retweetContentY = StatusCellBorderW;
        NSString *retweetContent = [NSString stringWithFormat:@"@%@ : %@",retweeted_status_user.name, retweeted_status.text];
        CGSize retweetContentSize = [retweetContent sizeWithFont:StatusCellRetweetContentFont maxW:maxW];
        self.retweetContentLabelFrm = (CGRect){{retweetContentX, retweetContentY}, retweetContentSize};

        /** 被转发微博配图*/
         CGFloat retweetH = 0;
        if (retweeted_status.pic_urls.count) { // 转发微博有配图
            CGFloat retweetPhotoX = retweetContentX;
            CGFloat retweetPhotoY = CGRectGetMaxY(self.retweetContentLabelFrm) + StatusCellBorderW;
            CGSize retweetPhotoSize = [StatusPhotosView sizeWithCount:retweeted_status.pic_urls.count];
            self.retweetPhotosViewFrm = (CGRect){{retweetPhotoX, retweetPhotoY}, retweetPhotoSize};
            
           retweetH = CGRectGetMaxY(self.retweetPhotosViewFrm) + StatusCellBorderW;
        } else { // 转发微博没有配图
            
            retweetH = CGRectGetMaxY(self.retweetContentLabelFrm) + StatusCellBorderW;
        }
        /** 被转发微博整体*/
        CGFloat retweetX = 0;
        CGFloat retweetY = CGRectGetMaxY(self.originalViewFrm);
        CGFloat retweetW = cellW;
        self.retweetViewFrm = CGRectMake(retweetX, retweetY, retweetW, retweetH);
    
        toolbarY = CGRectGetMaxY(self.retweetViewFrm);
   
    } else {
        
        toolbarY = CGRectGetMaxY(self.originalViewFrm);
    }
    
    /** 工具条 */
    CGFloat toolbarX = 0;
    CGFloat toolbarW = cellW;
    CGFloat toolbarH = 35;
    self.toolbarFrm = CGRectMake(toolbarX, toolbarY, toolbarW, toolbarH);
    
    /** cell 高度 */
    self.cellHeight = CGRectGetMaxY(self.toolbarFrm);
}


@end
