//
//  StatusCell.m
//  Weibo
//
//  Created by ZHANGMIA on 7/20/16.
//  Copyright © 2016 ZHANGMIA. All rights reserved.
//

#import "StatusCell.h"
#import "Status.h"
#import "StatusFrame.h"
#import "User.h"
#import "Photo.h"
#import "StatusToolbar.h"
#import "NSString+Extension.h"
#import "StatusPhotosView.h"
#import "IconView.h"

@interface StatusCell()

/* 原创微博 */

/* 原创微博整体 */
@property (nonatomic,weak)UIView *originalView;
/* 头像 */
@property (nonatomic,weak)IconView *iconView;
/* 会员图标 */
@property (nonatomic,weak)UIImageView *vipView;
/* 配图 */
@property (nonatomic,weak)StatusPhotosView *photosView;
/* 昵称 */
@property (nonatomic,weak)UILabel *nameLabel;
/* 时间 */
@property (nonatomic,weak)UILabel *timeLabel;
/* 来源 */
@property (nonatomic,weak)UILabel *sourceLabel;
/* 正文 */
@property (nonatomic,weak)UILabel *contentLabel;

/* 转发微博 */

/** 转发微博整体 */
@property (nonatomic,weak)UIView *retweetView; // repost
/** 转发微博正文 */
@property (nonatomic,weak)UILabel *retweetContentLabel;
/** 转发微博配图 */
@property (nonatomic,weak)StatusPhotosView *retweetPhotosView;

/** 工具条 */
@property (nonatomic,weak)StatusToolbar *toolbar;

@end

@implementation StatusCell

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"status";
    StatusCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[StatusCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
    }
    
    return cell;
}

/**
 *   cell的初始化方法，一个cell只会调用一次
 *   一般在这里添加所有可能显示的子控件，以及子控件的一次性设置
 */

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        // 点击cell的时候不会变色
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        //        UIView *bg = [[UIView alloc] init];
        //        bg.backgroundColor = [UIColor blueColor];
        //        self.selectedBackgroundView = bg;
        
        // 初始化原创微博
        [self setupOriginal];
        // 初始化转发微博
        [self setupRetweet];
        // 初始化工具条
        [self setupToolbar];
    }
    return self;
}

//- (void)setFrame:(CGRect)frame
//{
//    frame.origin.y += StatusCellMargin;
//    [super setFrame:frame];
//}

/**
 *   初始化工具条
 */
- (void)setupToolbar
{
    StatusToolbar *toolbar = [StatusToolbar toolbar];
    [self.contentView addSubview:toolbar];
    self.toolbar = toolbar;
}

/**
 *   初始化转发微博
 */
- (void)setupRetweet
{
    /** 转发微博整体 */
    UIView *retweetView = [[UIView alloc] init];
    retweetView.backgroundColor = HWColor(247, 247, 247);
    [self.contentView addSubview:retweetView];
    self.retweetView = retweetView;
    
    /** 转发微博正文 + 昵称 */
    UILabel *retweetContentLabel = [[UILabel alloc] init];
    retweetContentLabel.font = StatusCellRetweetContentFont;
    retweetContentLabel.numberOfLines = 0; // 自动换行
    [retweetView addSubview:retweetContentLabel];
    self.retweetContentLabel = retweetContentLabel;
    
    /** 转发微博配图 */
    StatusPhotosView *retweetPhotosView = [[StatusPhotosView alloc] init];
    [retweetView addSubview:retweetPhotosView];
    self.retweetPhotosView = retweetPhotosView;
    
}


/**
 *   初始化原创微博
 */
- (void)setupOriginal
{
    /* 原创微博整体 */
    UIView *originalView = [[UIView alloc] init];
    originalView.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:originalView];
    self.originalView = originalView;
    
    /* 头像 */
    IconView *iconView = [[IconView alloc] init];
    [originalView addSubview:iconView];
    self.iconView = iconView;
    
    /* 会员图标 */
    UIImageView *vipView = [[UIImageView alloc] init];
    [originalView addSubview:vipView];
    self.vipView = vipView;
    
    /* 配图 */
    StatusPhotosView *photosView = [[StatusPhotosView alloc] init];
    vipView.contentMode = UIViewContentModeCenter;
    [originalView addSubview:photosView];
    self.photosView = photosView;
    
    /* 昵称 */
    UILabel *nameLabel = [[UILabel alloc] init];
    nameLabel.font = StatusCellNameFont;
    [originalView addSubview:nameLabel];
    self.nameLabel = nameLabel;
    
    /* 时间 */
    UILabel *timeLabel = [[UILabel alloc] init];
    timeLabel.font = StatusCellTimeFont;
    timeLabel.textColor = [UIColor orangeColor];
    [originalView addSubview:timeLabel];
    self.timeLabel = timeLabel;
    
    /* 来源 */
    UILabel *sourceLabel = [[UILabel alloc] init];
    sourceLabel.font = StatusCellSourceFont;
    [originalView addSubview:sourceLabel];
    self.sourceLabel = sourceLabel;
    
    /* 正文 */
    UILabel *contentLabel = [[UILabel alloc] init];
    contentLabel.font = StatusCellContentFont;
    contentLabel.numberOfLines = 0; // 自动换行
    [originalView addSubview:contentLabel];
    self.contentLabel = contentLabel;
}

// 微博frame模型的set方法
- (void)setStatusFrame:(StatusFrame *)statusFrame
{
    _statusFrame = statusFrame;
    
    Status *status = statusFrame.status;
    User *user = status.user;
    
    /* 原创微博整体 */
    self.originalView.frame = statusFrame.originalViewFrm;
    
    /* 头像 */
    self.iconView.frame = statusFrame.iconViewFrm;
    // 在setUser方法中下载头像
    self.iconView.user = user;
    
    /* 会员图标 */
    if (user.isVip) {
        self.vipView.hidden = NO;
        self.vipView.frame = statusFrame.vipViewFrm;
        NSString *vipName = [NSString stringWithFormat:@"common_icon_membership_level%d",user.mbrank];
        self.vipView.image = [UIImage imageNamed:vipName];
        self.nameLabel.textColor = [UIColor orangeColor];
        
    } else {
        self.nameLabel.textColor = [UIColor blackColor];
        self.vipView.hidden = YES;
    }
    
    /* 配图 */
    if (status.pic_urls.count) {
      self.photosView.hidden = NO;
        self.photosView.frame = statusFrame.photosViewFrm;
        self.photosView.photos = status.pic_urls;
  
    } else {
        self.photosView.hidden = YES;
    }
    
    /* 昵称 */
    self.nameLabel.frame = statusFrame.nameLabelFrm;
    self.nameLabel.text = user.name;
    
    /* 时间 */
    NSString *time = status.created_at;
    CGFloat timeX = self.nameLabel.frame.origin.x;
    CGFloat timeY = CGRectGetMaxY(self.nameLabel.frame) + StatusCellBorderW;
    CGSize timeSize = [time sizeWithFont:StatusCellTimeFont];
    self.timeLabel.frame = (CGRect){{timeX,timeY},timeSize};
    self.timeLabel.text = time;
    
    /* 来源 */
    CGFloat sourceX = CGRectGetMaxX(self.timeLabel.frame) + StatusCellBorderW;
    CGFloat sourceY = timeY;
    CGSize sourceSize = [status.source sizeWithFont:StatusCellSourceFont];
    self.sourceLabel.frame = (CGRect){{sourceX,sourceY},sourceSize};
    self.sourceLabel.text = status.source;
    
    /* 正文 */
    self.contentLabel.frame = statusFrame.contentLabelFrm;
    self.contentLabel.text = status.text;
    
    /** 被转发的微博 **/
    
    if (status.retweeted_status) {
        // 微博模型中被转发的微博
        Status *retweeted_status = status.retweeted_status;
        User *retweeted_status_user = retweeted_status.user;
        
        self.retweetView.hidden = NO;
        
        /** 被转发的微博整体 **/
        self.retweetView.frame = statusFrame.retweetViewFrm;
        
        /** 被转发的微博正文 */
        NSString *retweetContent = [NSString stringWithFormat:@"@%@: %@",retweeted_status_user.name,retweeted_status.text];
        
        self.retweetContentLabel.frame = statusFrame.retweetContentLabelFrm;
        self.retweetContentLabel.text = retweetContent;
        
        /* 被转发的微博配图 */
        if (retweeted_status.pic_urls.count) {
            // 设置转发微博的配图的frame
            self.retweetPhotosView.frame = statusFrame.retweetPhotosViewFrm;
            self.retweetPhotosView.photos = retweeted_status.pic_urls;
            self.retweetPhotosView.hidden = NO;
        } else {
            
            self.retweetPhotosView.hidden = YES;
        }
        
    } else {
        
        self.retweetView.hidden = YES;
    }
    
    /** 工具条 */
    
    self.toolbar.frame = statusFrame.toolbarFrm;
    self.toolbar.status = status;
    
}

@end
