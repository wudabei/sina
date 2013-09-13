//
//  WebViewController.m
//  WXWeibo
//
//  Created by cannaan on 13-7-26.
//  Copyright (c) 2013年 www.iphonetrain.com 无限互联3G学院. All rights reserved.
//

#import "WebViewController.h"

@interface WebViewController ()

@end

@implementation WebViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

- (id)initWithUrl:(NSString *)url {
    self = [super init];
    if (self != nil) {
        _url = [url copy];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSURL *url = [NSURL URLWithString:_url];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [_weiView loadRequest:request];
    
    self.title = @"载入中...";
    // 状态栏loading转动
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)goBack:(UIButton *)sender {
    if ([_weiView canGoBack]) {
        [_weiView goBack];
    }
}

- (IBAction)goForward:(UIButton *)sender {
    if ([_weiView canGoForward]) {
        [_weiView goForward];
    }
}

- (IBAction)reload:(UIButton *)sender {
    [_weiView reload];
}

#pragma mark - UIWebView delegate
- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    
    //js代码的执行
    NSString *title = [webView stringByEvaluatingJavaScriptFromString:@"document.title"];
    self.title = title;

}
- (void)dealloc {
    [_weiView release];
    [super dealloc];
}

- (void)viewDidUnload {
    [self setWeiView:nil];
    [super viewDidUnload];
}
@end
