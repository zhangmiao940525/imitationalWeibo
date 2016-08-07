//
//  IconView.m
//  Weibo
//
//  Created by ZHANGMIA on 7/31/16.
//  Copyright © 2016 ZHANGMIA. All rights reserved.
//

#import "IconView.h"
#import "User.h"

@interface IconView ()

@property (nonatomic,weak)UIImageView *verifiedView;

@end

@implementation IconView

- (UIImageView *)verifiedView
{
    if (!_verifiedView) {
        UIImageView *verifiedView = [[UIImageView alloc] init];
        [self addSubview:verifiedView];
        self.verifiedView = verifiedView;
    }
    return _verifiedView;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}

- (void)setUser:(User *)user
{
    _user = user;
    
    // 1. 下载图片
    [self sd_setImageWithURL:[NSURL URLWithString:user.profile_image_url] placeholderImage:[UIImage imageNamed:@"avatar_default_small"]];
    
    // 2. 设置加V图片
    switch (user.verified_type) {
        case UserVerifiedPersonal: // 个人认证
            self.verifiedView.hidden = NO;
            self.verifiedView.image = [UIImage imageNamed:@"avatar_vip"];
            break;
            
        case UserVerifiedOrgEnterprice: // 官方认证
        case UserVerifiedOrgMedia:
        case UserVerifiedOrgWebsite:
            self.verifiedView.hidden = NO;
            
            self.verifiedView.image = [UIImage imageNamed:@"avatar_enterprise_vip"];
            
            break;
            
        case UserVerifiedDaren: // 微博达人
            self.verifiedView.hidden = NO;
            self.verifiedView.image = [UIImage imageNamed:@"avatar_grassroot"];
            break;
            
        default:
            self.verifiedView.hidden = YES; // 没有任何认证
            break;
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.verifiedView.size = self.verifiedView.image.size;
    CGFloat scale = 0.6;
    self.verifiedView.x = self.width - self.verifiedView.width *scale;
    self.verifiedView.y = self.height - self.verifiedView.height *scale;
}


@end
