//
//  WebViewController.m
//  LJZArchiveDemo
//
//  Created by DBOX on 2017/1/16.
//  Copyright © 2017年 DBOX. All rights reserved.
//

#import "WebViewController.h"
#import <WebKit/WebKit.h>

@interface WebViewController ()<UIWebViewDelegate,WKNavigationDelegate>
{
    WKWebView *_wkWebView;
    UIWebView *_webView;
}
@end

@implementation WebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _wkWebView = [[WKWebView alloc]initWithFrame:self.view.frame];
    _wkWebView.navigationDelegate = self;
    NSURL *url = [NSURL fileURLWithPath:self.path];
//    [_wkWebView loadRequest:[NSURLRequest requestWithURL:url]];//测试iOS 13读取本地文件
    [_wkWebView loadFileURL:url allowingReadAccessToURL:url];//读取本地文件 iOS 9 之后
    
    [self.view addSubview:_wkWebView];
//    _webView = [[UIWebView alloc]initWithFrame:self.view.frame];
//    _webView.delegate = self;
//    [_webView loadRequest:[NSURLRequest requestWithURL:url]];
//    [self.view addSubview:_webView];
//    [self getMimeType:self.path];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)getMimeType:(NSString *)path{
    // 创建URL
    NSURL *url = [NSURL fileURLWithPath:path];
    // 创建请求对象
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    // 发送异步请求 在请求的
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse * _Nullable response, NSData * _Nullable data, NSError * _Nullable connectionError) {
        NSLog(@"%@",response.MIMEType);
    }];
}
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    NSString *pageUrl = request.URL.absoluteString;
    NSString *lastName =[[pageUrl lastPathComponent] lowercaseString];
    
    if ([lastName containsString:@".pdf"])
    {
        NSData *data = [NSData dataWithContentsOfURL:request.URL];
        [_webView loadData:data MIMEType:@"application/pdf" textEncodingName:@"GBK" baseURL:nil];
    }
    return YES;

}


- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler
{
    NSString *_webUrlStr = navigationAction.request.URL.absoluteString;
    NSString *lastName =[[_webUrlStr lastPathComponent] lowercaseString];
    
    if ([lastName containsString:@".pdf"])
    {
        NSData *data = [NSData dataWithContentsOfURL:navigationAction.request.URL];
        [_wkWebView loadData:data MIMEType:@"application/pdf" characterEncodingName:@"GBK" baseURL:nil];
    }
    decisionHandler(WKNavigationActionPolicyAllow);
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
