//
//  OAuthViewController.m
//  Weibo
//
//  Created by ZHANGMIA on 7/18/16.
//  Copyright © 2016 ZHANGMIA. All rights reserved.
//

#import "OAuthViewController.h"
#import "Account.h"
#import "AccountTool.h"
#import "HttpTool.h"

@interface OAuthViewController ()<UIWebViewDelegate>

@end

@implementation OAuthViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // 1. 创建一个webView
    UIWebView *webView = [[UIWebView alloc] init];
    webView.frame = self.view.bounds;
    webView.delegate = self;
    [self.view addSubview:webView];
    // 2. 用webView加载登录页面（新浪提供的）
    /*
     请求参数:
     cliend_id: 963975878 (申请应用时分配的AppKey)
     redirect_uri: (授权回调地址:授权成功后调用)
     请求地址: https://api.weibo.com/oauth2/authorize
     */
    NSString *urlStr = [NSString stringWithFormat:@"https://api.weibo.com/oauth2/authorize?client_id=%@&redirect_uri=%@", AppKey, RedirectURI];
    NSURL *url = [NSURL URLWithString:urlStr];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [webView loadRequest:request];
}

#pragma mark webView的代理方法
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [MBProgressHUD hideHUD];
}

-(void)webViewDidStartLoad:(UIWebView *)webView
{
    [MBProgressHUD showMessage:@"正在加载..."];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [MBProgressHUD hideHUD];
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    // 1. 获取url
    NSString *url = request.URL.absoluteString;
    // 2. 判断是否为回调地址
    NSRange range = [url rangeOfString:@"code="];
    if (range.length != 0) { // 意味着有回调地址
        // 截取code= 后面的参数值
        int fromIndex = (int)(range.location + range.length);
        NSString *code = [url substringFromIndex:fromIndex];
        
        // 利用code (授权成功后的request_token) 换取accessToken
        [self accessTokenWithCode:code];
        
        // 禁止加载回调地址
        return NO;
    }
    return YES;
}

/*
 URL: https://api.weibo.com/oauth2/access_token
 请求参数:
 client_id:963975878
 client_secret: d3ef0dc4c36ba46ef1518be47486b373
 grant_type: (请求的类型，填写authorization_code)
 code: (授权成功后返回的code)
 redirect_uri: 授权成功后返回的回调地址
 */
- (void)accessTokenWithCode:(NSString *)code
{
    // 1. 拼接请求参数
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"client_id"] = AppKey;
    params[@"client_secret"] = AppSecret;
    params[@"grant_type"] = @"authorization_code";
    params[@"code"] = code;
    params[@"redirect_uri"] = RedirectURI;

    // 2. 发送请求参数
    [HttpTool post:@"https://api.weibo.com/oauth2/access_token" params:params success:^(id json) {
        //
        [MBProgressHUD hideHUD];

        // 将返回的字典数据 --> 模型，存进沙盒
        Account *account = [Account accountWithDic:json];
        /* 存储帐号信息*/
        [AccountTool saveAccount:account];
        /* 切换窗口的根控制器 */
        UIWindow *window = [[UIApplication sharedApplication] keyWindow];
        [window switchRootViewController];

    } failure:^(NSError *error) {
        [MBProgressHUD hideHUD];
        NSLog(@"请求失败 = %@",error);
    }];
    
}

/*
 access_token=2.00BSyX4DCKkODB89aa7be99dAfyk8C
 "expires_in" = 157679999; // 过期时间
 "remind_in" = 157679999;
 uid = 3096350805;
 */

@end
