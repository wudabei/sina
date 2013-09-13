//
//  WebViewController.h
//  WXWeibo
//
//  Created by cannaan on 13-7-26.
//  Copyright (c) 2013年 www.iphonetrain.com 无限互联3G学院. All rights reserved.
//

#import "BaseViewController.h"

@interface WebViewController : BaseViewController<UIWebViewDelegate>
{
    NSString *_url;
}
- (id)initWithUrl:(NSString *)url;

- (IBAction)goBack:(UIButton *)sender;
- (IBAction)goForward:(UIButton *)sender;
- (IBAction)reload:(UIButton *)sender;
@property (retain, nonatomic) IBOutlet UIWebView *weiView;

@end
