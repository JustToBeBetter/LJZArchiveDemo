//
//  WebViewController.m
//  LJZArchiveDemo
//
//  Created by DBOX on 2017/1/16.
//  Copyright © 2017年 DBOX. All rights reserved.
//

#import "WebViewController.h"
#import <WebKit/WebKit.h>

@interface WebViewController ()
{
    WKWebView *_wkWebView;
    UIWebView *_webView;
}
@end

@implementation WebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _wkWebView = [[WKWebView alloc]initWithFrame:CGRectMake(0, 64,kScreenWidth , kScreenHeight-64)];
    
    NSURL *url = [NSURL fileURLWithPath:self.path];
    [_wkWebView loadRequest:[NSURLRequest requestWithURL:url]];
    [self.view addSubview:_wkWebView];
    _webView = [[UIWebView alloc]initWithFrame:self.view.frame];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
