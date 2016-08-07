//
//  ComposeToolbar.h
//  Weibo
//
//  Created by ZHANGMIA on 7/31/16.
//  Copyright © 2016 ZHANGMIA. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ComposeToolbar;

typedef enum {
    ComposeToolbarButtonTypeCamera,  // 拍照
    ComposeToolbarButtonTypePicture, // 相册
    ComposeToolbarButtonTypeMention, // @提到
    ComposeToolbarButtonTypeTrend,   // #
    ComposeToolbarButtonTypeEmotion  // 表情
}ComposeToolbarButtonType;
/** 自定义Toolbar的代理协议 */
@protocol ComposeToolbarDelegate <NSObject>
@optional

- (void)composeToolbar:(ComposeToolbar *)toolbar didClickButton:(ComposeToolbarButtonType)buttonType;

@end

@interface ComposeToolbar : UIView

@property (nonatomic,weak)id<ComposeToolbarDelegate> delegate;
/** 是否要显示键盘按钮 */
@property (nonatomic,assign)BOOL showKeyboardBtn;

@end
