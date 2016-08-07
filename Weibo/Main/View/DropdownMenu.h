//
//  DropdownMenu.h
//  Weibo
//
//  Created by ZHANGMIA on 7/12/16.
//  Copyright © 2016 ZHANGMIA. All rights reserved.
//

#import <UIKit/UIKit.h>
@class DropdownMenu;

@protocol DropdownMenuDelegate <NSObject>
@optional
- (void)dropdownMenuDidDismiss:(DropdownMenu *)menu;
- (void)dropdownMenuDidShow:(DropdownMenu *)menu;

@end

@interface DropdownMenu : UIView

@property (nonatomic,weak) id <DropdownMenuDelegate> delegate;

+ (instancetype)menu;

/* 显示 */
- (void)showFrom:(UIView *)from;
/* 销毁 */
- (void)dismiss;

/* 内容 */
@property (nonatomic,strong) UIView *content;
/* 内容管理器 */
@property (nonatomic,strong) UIViewController *contentController;

@end
