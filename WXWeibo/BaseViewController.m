//
//  BaseViewController.m
//  WXWeibo
//
//  Created by wei.chen on 13-1-21.
//  Copyright (c) 2013年 www.iphonetrain.com 无限互联3G学院. All rights reserved.
//

#import "BaseViewController.h"
#import "UIFactory.h"

@interface BaseViewController ()

@end

@implementation BaseViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // 两者只能开启一个
        self.isBackButton = YES;
        self.isCancelButton = NO;
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    NSArray *viewControllers = self.navigationController.viewControllers;
    
    // 创建返回按钮
    if (viewControllers.count > 1 && self.isBackButton) {
        UIButton *button = [UIFactory createButton:@"navigationbar_back.png" highlighted:@"navigationbar_back_highlighted.png"];
        button.showsTouchWhenHighlighted = YES;
        button.frame = CGRectMake(0, 0, 24, 24);
        [button addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:button];
        self.navigationItem.leftBarButtonItem = [backItem autorelease];
    }
    
    if (self.isCancelButton) {
        // 创建取消按钮
        UIButton *button = [UIFactory createNavigationButton:CGRectMake(0, 0, 45, 30) title:@"取消" target:self action:@selector(cancleAction)];
        UIBarButtonItem *canle = [[UIBarButtonItem alloc] initWithCustomView:button];
        self.navigationItem.leftBarButtonItem = [canle autorelease];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    if (WXHLOSVersion() >= 6.0) {
        // 判断当前控制器的视图显示，window ！=nil是显示，
        if (self.view.window == nil) {
            self.view = nil;
            // 兼容6.0之后内存
            [self viewDidUnload];
        }
    }
}

// 6.0之前，内存不足时候调用
- (void)viewDidUnload {
    [super viewDidUnload];
}
#pragma mark - actions

- (void)backAction {
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)cancleAction {

    [self dismissViewControllerAnimated:YES completion:NULL];
//    [self dismissModalViewControllerAnimated:YES];
}

//override
//设置导航栏上的标题
- (void)setTitle:(NSString *)title {
    [super setTitle:title];
    
//    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
//    titleLabel.textColor = [UIColor blackColor];
    UILabel *titleLabel = [UIFactory createLabel:kNavigationBarTitleLabel];
    titleLabel.font = [UIFont boldSystemFontOfSize:18.0f];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.text = title;
    [titleLabel sizeToFit];
    
    self.navigationItem.titleView = titleLabel;
}

- (SinaWeibo *)sinaweibo {
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    SinaWeibo *sinaweibo = appDelegate.sinaweibo;
    return sinaweibo;
}
- (AppDelegate *)appdelegate {
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    return appDelegate;
}

#pragma mark - loading
// 显示load字样
- (void)showLoading:(BOOL)show{
    if(_loadView == nil){
        _loadView = [[UIView alloc] initWithFrame:CGRectMake(0,ScreenHeight/2-80,ScreenWidth,20)];
        
        // loading View
        UIActivityIndicatorView *activityView = [[UIActivityIndicatorView alloc]
                                                 initWithActivityIndicatorStyle:
                                                 UIActivityIndicatorViewStyleGray];
        [activityView startAnimating];
        
        // loading Label
        UILabel *loadLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        loadLabel.backgroundColor = [UIColor clearColor];
        loadLabel.text = @"正在加载...";
        loadLabel.font = [UIFont boldSystemFontOfSize:16.0];
        loadLabel.textColor = [UIColor blackColor];
        [loadLabel sizeToFit];
        
        loadLabel.left = (320-loadLabel.width)/2;
        activityView.right = loadLabel.left-5;
        
        [_loadView addSubview:loadLabel];
        [_loadView addSubview:activityView];
        [activityView release];
        [loadLabel release];
    }
    
    if(show) {
        if(![_loadView superview]) {
            [self.view addSubview:_loadView];
        }
    }else{
            [_loadView removeFromSuperview];
        }
}

- (void)showHUD:(NSString *)title isDim:(BOOL)isDim{
    
    self.hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    // 是否灰色背景
    self.hud.dimBackground = isDim;
    self.hud.labelText = title;
}

- (void)showHUDComplete:(NSString *)title{
    self.hud.customView = [[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"37x-Checkmark.png"]]autorelease];
    self.hud.mode = MBProgressHUDModeCustomView;
    if(title.length > 0){
        self.hud.labelText = title;
    }
    // 延迟1s隐藏
    [self.hud hide:YES afterDelay:1];
}

- (void)hideHUD{
    [self.hud hide:YES];
}

// 状态栏上的提示
- (void)showStatuseTip:(BOOL)show title:(NSString *)title {
    if (_tipWindow == nil) {
        _tipWindow = [[UIWindow alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 20)];
        _tipWindow.windowLevel = UIWindowLevelStatusBar;
        _tipWindow.backgroundColor = [UIColor blackColor];
        
        UILabel *tipLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 20)];
        tipLabel.textAlignment = NSTextAlignmentCenter;
        tipLabel.font = [UIFont systemFontOfSize:13.0f];
        tipLabel.textColor = [UIColor whiteColor];
        tipLabel.backgroundColor = [UIColor clearColor];
        tipLabel.tag = 1;
        [_tipWindow addSubview:tipLabel];
        
        UIImageView *progress = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"queue_statusbar_progress.png"]];
        progress.frame = CGRectMake(0, 20-6, 100, 6);
        progress.tag = 12;
        [_tipWindow addSubview:progress];
        
    
    
    }
    
    
    UILabel *tipLabel = (UILabel *)[_tipWindow viewWithTag:1];
    UIImageView *progress = (UIImageView *)[_tipWindow viewWithTag:2];
    if (show) {
        tipLabel.text = title;
        _tipWindow.hidden = NO;
        
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:1];
        [UIView setAnimationRepeatCount:1000];
        [UIView setAnimationCurve:UIViewAnimationCurveLinear];// 匀速移动

        progress.left = ScreenWidth;
        [UIView commitAnimations];
        
        
    }else {
        progress.hidden = YES;
        tipLabel.text = title;
        [self performSelector:@selector(removeTipWindow) withObject:nil afterDelay:1.5];
    }
}


- (void)removeTipWindow {
    _tipWindow.hidden = YES;
    [_tipWindow release];
    _tipWindow = nil;
}

@end
