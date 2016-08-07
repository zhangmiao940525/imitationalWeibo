//
//  ComposeViewController.m
//  Weibo
//
//  Created by ZHANGMIA on 7/31/16.
//  Copyright © 2016 ZHANGMIA. All rights reserved.
//

#import "ComposeViewController.h"
#import "AccountTool.h"
#import "ComposeToolbar.h"
#import "ComposePhotosView.h"
#import "EmotionKeyboard.h"
#import "Emotion.h"
#import "EmotionTextView.h"
#import "HttpTool.h"
#import "AFNetworking.h"

@interface ComposeViewController ()<UITextViewDelegate,ComposeToolbarDelegate,UINavigationControllerDelegate, UIImagePickerControllerDelegate>

/** 输入控件 */
@property (nonatomic,weak)EmotionTextView *textView;
/** 键盘顶部工具条 */
@property (nonatomic,weak)ComposeToolbar *toolbar;
/** 相册（存放拍照或者相册中选择的图片）*/
@property (nonatomic,weak)ComposePhotosView *photosView;
/** 表情键盘*/
@property (nonatomic,strong)EmotionKeyboard *emotionKeyboard;
/** 是否正在切换键盘*/
@property (nonatomic,assign)BOOL switchingKeyboard;


@end

@implementation ComposeViewController

#pragma mark - 懒加载
- (EmotionKeyboard *)emotionKeyboard
{
    if (!_emotionKeyboard) {
        self.emotionKeyboard = [[EmotionKeyboard alloc] init];
        self.emotionKeyboard.width = self.view.width;
        self.emotionKeyboard.height = 216;
    }
    return _emotionKeyboard;
}

#pragma mark - 系统方法

- (void)viewDidLoad {
    [super viewDidLoad];
    //
    self.view.backgroundColor = [UIColor whiteColor];
    
    // 设置导航拦内容
    [self setupNav];
    
    // 添加输入控件
    [self setupTextView];
    
    // 添加工具条
    [self setupToolbar];
    
    // 添加相册
    [self setupPhotosView];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    //
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"取消" style:UIBarButtonItemStyleDone target:self action:@selector(cancel)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"发送" style:UIBarButtonItemStyleDone target:self action:@selector(send)];
    self.navigationItem.rightBarButtonItem.enabled = NO;
    
    // 成为第一响应者（能输入文本的控件一旦成为第一响应者，就会调出相应的键盘）
    [self.textView becomeFirstResponder];
}

- (void)dealloc
{
    [NotificationCenter removeObserver:self];
}

#pragma mark - 初始化方法
/**
 添加相册
 */
- (void)setupPhotosView
{
    ComposePhotosView *photosView = [[ComposePhotosView alloc]init];
    photosView.width = self.view.width;
    photosView.height = self.view.height; //高度随便写
    photosView.y = 100;
    [self.textView addSubview:photosView];
    self.photosView = photosView;
}

/**
 添加工具条
 */
- (void)setupToolbar
{
    ComposeToolbar *toolbar = [[ComposeToolbar alloc] init];
    toolbar.width = self.view.width;
    toolbar.height = 44;
    toolbar.y = self.view.height - toolbar.height;
    toolbar.delegate = self;
    [self.view addSubview:toolbar];
    self.toolbar = toolbar;
    
    // inputAccessoryView设置显示在键盘顶部的内容
    // self.textView.inputAccessoryView = toolbar;
    
}

/**
 设置导航拦内容
 */
- (void)setupNav
{
    NSString *name = [AccountTool account].name;
    NSString *prefix = @"发微博";
    
    if (name) {
        
        UILabel *titleView = [[UILabel alloc] init];
        titleView.width = 220;
        titleView.height = 44;
        titleView.textAlignment = NSTextAlignmentCenter;
        // 自动换行
        titleView.numberOfLines = 0;
        
        NSString *str = [NSString stringWithFormat:@"%@\n%@",prefix,name];
        
        // 创建一个带有属性的字符串（比如颜色书写，字体属性等文字属性）
        NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:str];
        // 添加属性
        [attrStr addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:15] range:[str rangeOfString:prefix]];
        
        [attrStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:12] range:[str rangeOfString:name]];
        
        [attrStr addAttribute:NSForegroundColorAttributeName value:[UIColor grayColor] range:[str rangeOfString:name]];
        
        titleView.attributedText = attrStr;
        self.navigationItem.titleView = titleView;
        
    } else {
        self.title = prefix;
    }
    
}

/**
 添加输入控件
 */
- (void)setupTextView
{
    // 在这个控制器中，textView的contentInset.top默认等于设置scrollview的contentInset
    EmotionTextView *textView = [[EmotionTextView alloc] init];
    // 意味着垂直方向上永远可以拖拽（弹簧效果）
    textView.alwaysBounceVertical = YES;
    // 设置代理
    textView.delegate = self;
    textView.frame = self.view.bounds;
    textView.font = [UIFont systemFontOfSize:15];
    textView.placeholder = @"分享新鲜事...";
    [self.view addSubview:textView];
    self.textView = textView;
    
    //self.automaticallyAdjustsScrollViewInsets
    
    // 监听文字改变通知
    [NotificationCenter addObserver:self selector:@selector(textDidChange) name:UITextViewTextDidChangeNotification object:textView];
    
    // 键盘通知
    // 键盘的frame发生改变时发出通知
    [NotificationCenter addObserver:self selector:@selector(keyboardWillChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
    
    // 表情选中的通知
    [NotificationCenter addObserver:self selector:@selector(emotionDidSelected:) name:EmotionDidSelectedNotification object:nil];
    
    // 删除文字时发出
    [NotificationCenter addObserver:self selector:@selector(emotionDidDeleted) name:EmotionDidDeletedNotification object:nil];
}

#pragma mark - 监听方法
/**
 *  删除文字
 */
- (void)emotionDidDeleted
{
    [self.textView deleteBackward];
}

/**
 *   表情被选中了
 */
- (void)emotionDidSelected:(NSNotification *)notification
{
    Emotion *emotion = notification.userInfo[SelectedEmotionKey];
    [self.textView insertEmotion:emotion];
    /**
     selectedRange: 
     1. 本来是控制textView的文字选中范围的
     2. 如果selectedRange的length为0，selectedRange.location就是textview的光标位置
     
     关于textview的文字的字体
     1. 如果是普通文字（text），文字大小由textview.font控制
     2. 如果是属性文字（attributedText），文字大小不受textview.font控制，应该利用NSMutableAttributedstring的
     -(void)addAttribute:(NSString *)name value:(id)value range:(NSRange)range; 
     方法设置字体
     */
}

- (void)cancel
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
/**
 URL: @"https://api.weibo.com/2/statuses/update.json"
 access_token
 status         微博内容
 pic            微博配图
 */

- (void)send
{
    if (self.photosView.photos.count) {
        [self sendWithImage];
    } else {
        [self sendWithoutImage];
    }
    //  dismiss
    [self dismissViewControllerAnimated:YES completion:nil];
}

/**
 发布有图片的微博
 */
- (void)sendWithImage
{
// 1.创建Manager
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];

// 2. 拼接请求参数
NSMutableDictionary *params = [NSMutableDictionary dictionary];
params[@"access_token"] = [AccountTool account].access_token;
params[@"status"] = self.textView.fullText;

NSLog(@"params = %@",params);

//    // 3. 发送请求
    [manager POST:@"https://upload.api.weibo.com/2/statuses/upload.json" parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        // 拼接文件数据
        UIImage *image = [self.photosView.photos firstObject];
        // 将图片转成二进制数
        NSData *data = UIImageJPEGRepresentation(image, 1.0);// 5M以内的图片
        
        [formData appendPartWithFileData:data name:@"pic" fileName:@"test.jpg" mimeType:@"image/jpeg"];
        
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [MBProgressHUD showSuccess:@"发送成功"];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [MBProgressHUD showError:@"发送失败"];
    }];
}

/**
 发布没有图片的微博
 */
- (void)sendWithoutImage
{
    // 1.拼接请求参数
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"access_token"] = [AccountTool account].access_token;
    params[@"status"] = self.textView.fullText;
     NSLog(@"params = %@",params);
    
    // 2. 发送请求
    [HttpTool post:@"https://api.weibo.com/2/statuses/update.json" params:params success:^(id json) {
        [MBProgressHUD showSuccess:@"发送成功"];
    } failure:^(NSError *error) {
        [MBProgressHUD showError:@"发送失败"];
    }];
}

/**
 监听文本改变
 */
- (void)textDidChange
{
    self.navigationItem.rightBarButtonItem.enabled = self.textView.hasText;
}
/**
 键盘的frame发生改变时调用（显示／隐藏）
 */
- (void)keyboardWillChangeFrame:(NSNotification *)notification
{
    /* 
     // 键盘弹出\隐藏后的frame
     UIKeyboardFrameEndUserInfoKey = NSRect: {{0, 568}, {320, 253}},
     // 键盘弹出\隐藏所耗费的时间
     UIKeyboardAnimationDurationUserInfoKey = 0.25,
     // 键盘弹出\隐藏动画的执行节奏（匀速，先快后慢）
     UIKeyboardAnimationCurveUserInfoKey = 7,
     */
    
    // 如果正在切换键盘，就不要执行后面的代码（即不改变工具条的Y值）
    if(self.switchingKeyboard) return;
    
    //NSLog(@"keyboardWillChangeFrame");
    NSDictionary *userInfo = notification.userInfo;
    // 动画持续时间
    double duration = [userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    // 键盘frame
    CGRect keyboardFrm = [userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    // 执行动画
    [UIView animateWithDuration:duration animations:^{
        // 工具条的Y值 ＝＝ 键盘的Y值 － 工具条的高度
        
        if (keyboardFrm.origin.y > self.view.height) {
            self.toolbar.y = self.view.height - self.toolbar.height;
        } else {
            self.toolbar.y = keyboardFrm.origin.y - self.toolbar.height;
        }
        //NSLog(@"keyboardFrm = %@",NSStringFromCGRect(keyboardFrm));
    }];
}

#pragma mark - UITextView代理方法
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.view endEditing:YES];
}

#pragma mark - ComposeToolbar代理方法
- (void)composeToolbar:(ComposeToolbar *)toolbar didClickButton:(ComposeToolbarButtonType)buttonType
{
    switch (buttonType) {
        case ComposeToolbarButtonTypeCamera:  // 拍照
            [self openCamera];
            break;
        case ComposeToolbarButtonTypePicture: // 相册
            [self openAlbum];
            break;
        case ComposeToolbarButtonTypeMention: // @提到
            
            break;
        case ComposeToolbarButtonTypeTrend:   // #
            NSLog(@"#");
            break;
        case ComposeToolbarButtonTypeEmotion: // 表情\键盘
            [self switchKeyboard];
            break;
            
        default:
            break;
    }
}

#pragma mark - 其他方法
/**
 */
- (void)switchKeyboard
{
    //self.textView.inputView == nil: 说明系统使用的是自带的键盘
    if (self.textView.inputView == nil) { // 切换为自定义的表情键盘
        //EmotionKeyboard *emotionKeyboard = [[EmotionKeyboard alloc] init];
        self.textView.inputView = self.emotionKeyboard;
        // 显示键盘图标
        self.toolbar.showKeyboardBtn = YES;
    } else { // 切换为系统自带的键盘
        self.textView.inputView = nil;
        // 显示表情图标
        self.toolbar.showKeyboardBtn = NO;
    }
    
    // 开始切换键盘
    self.switchingKeyboard = YES;
    
    // 退出旧键盘
    [self.textView endEditing:YES];
    
    // 结束切换键盘
    self.switchingKeyboard = NO;
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        //弹出键盘
        [self.textView becomeFirstResponder];
        
    });
    
    
}

- (void)openCamera
{
    [self openImagePickerController:UIImagePickerControllerSourceTypeCamera];
}

- (void)openAlbum
{
    [self openImagePickerController:UIImagePickerControllerSourceTypePhotoLibrary];
}

- (void)openImagePickerController:(UIImagePickerControllerSourceType)type
{
    if (![UIImagePickerController isSourceTypeAvailable:type]) return;
    
    UIImagePickerController *ipc = [[UIImagePickerController alloc] init];
    ipc.sourceType = type;
    ipc.delegate = self;
    [self presentViewController:ipc animated:YES completion:nil];
    
}

#pragma mark - UIImagePickerController代理
/**
 从UIImagePickerController选择完图片后就调用（拍照完毕或者选择相册图片完毕）
 */
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    // info中就包含了选择的图片
    UIImage *image = info[UIImagePickerControllerOriginalImage];
    
    // 添加图片到photosView中
    [self.photosView addPhoto:image];
}
@end
