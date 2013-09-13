//
//  MainViewController.m
//  WXWeibo
//
//  Created by wei.chen on 13-1-21.
//  Copyright (c) 2013年 www.iphonetrain.com 无限互联3G学院. All rights reserved.
//

#import "MainViewController.h"
#import "MessageViewController.h"
#import "ProfileViewController.h"
#import "DiscoverViewController.h"
#import "MoreViewController.h"
#import "BaseNavigationController.h"
#import "UIFactory.h"
#import "ThemeButton.h"
#import "AppDelegate.h"


@interface MainViewController ()

@end

@implementation MainViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [self.tabBar setHidden:YES];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self _initViewController];
    [self _initTabbarView];
    // 每隔60s请求未读数接口
    [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(timerAction:) userInfo:nil repeats:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)showbadge:(BOOL)show{
    
    _badgeView.hidden = !show;//>???????????直接YES？
}

- (void)showTabbar:(BOOL)show{
    [UIView animateWithDuration:0.35 animations:^{
        if (show) {
            _tabbarView.left = 0;
        }else{
            _tabbarView.left = -ScreenWidth;
        }
    }];
    [self _resizeView:show];
}


#pragma mark - UI

- (void)_resizeView:(BOOL)showTabbar {

    for (UIView *subView in self.view.subviews) {
      
        if ([subView isKindOfClass:NSClassFromString(@"UITransitionView")]) {
            if (showTabbar) {
                subView.height = ScreenHeight-49-20;
            }else {
            subView.height = ScreenHeight-20;
            
            }
        }
    }
}
//初始化子控制器
- (void)_initViewController {
    _home = [[HomeViewController alloc] init] ;
    MessageViewController *message = [[[MessageViewController alloc] init] autorelease];
    ProfileViewController *profile = [[[ProfileViewController alloc] init] autorelease];
    DiscoverViewController *discover = [[[DiscoverViewController alloc] init] autorelease];
    MoreViewController *more = [[[MoreViewController alloc] init] autorelease];
    
    NSArray *views = @[_home,message,profile,discover,more];
    NSMutableArray *viewControllers = [NSMutableArray arrayWithCapacity:5];
    for (UIViewController *viewController in views) {
        BaseNavigationController *nav = [[BaseNavigationController alloc] initWithRootViewController:viewController];
        [viewControllers addObject:nav];
        [nav release];
        
        nav.delegate = self;
    }
    
    self.viewControllers = viewControllers;
}

//创建自定义tabBar
- (void)_initTabbarView {
    _tabbarView = [[UIView alloc] initWithFrame:CGRectMake(0, ScreenHeight-49-20, ScreenWidth, 49)];
//    _tabbarView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"tabbar_background.png"]];
    [self.view addSubview:_tabbarView];
    
    UIImageView *tabbarGroundImage = [UIFactory createImageView:@"tabbar_background.png"];
    tabbarGroundImage.frame = _tabbarView.bounds;
    [_tabbarView addSubview:tabbarGroundImage];
    
    NSArray *backgroud = @[@"tabbar_home.png",@"tabbar_message_center.png",@"tabbar_profile.png",@"tabbar_discover.png",@"tabbar_more.png"];
    
    NSArray *heightBackground = @[@"tabbar_home_highlighted.png",@"tabbar_message_center_highlighted.png",@"tabbar_profile_highlighted.png",@"tabbar_discover_highlighted.png",@"tabbar_more_highlighted.png"];
    
    for (int i=0; i<backgroud.count; i++) {
        NSString *backImage = backgroud[i];
        NSString *heightImage = heightBackground[i];
        
//        ThemeButton *button = [[ThemeButton alloc] initWithImage:backImage highlighted:heightImage];
        UIButton *button = [UIFactory createButton:backImage highlighted:heightImage];
        button.frame = CGRectMake((64-30)/2+(i*64), (49-30)/2, 30, 30);
        button.tag = i;
        // 点击高亮
        button.showsTouchWhenHighlighted = YES;
        [button addTarget:self action:@selector(selectedTab:) forControlEvents:UIControlEventTouchUpInside];
        [_tabbarView addSubview:button];
    }
    
    _sliderView = [[UIFactory createImageView:@"tabbar_slider.png"] retain];
    _sliderView.backgroundColor = [UIColor clearColor];
    _sliderView.frame = CGRectMake((64-15)/2, 5, 15, 44);
    [_tabbarView addSubview:_sliderView];
}

- (void)refreshUnReadView:(NSDictionary *)result{
    // 新微博未读数
    NSNumber *status = [result objectForKey:@"status"];
    
    if (_badgeView == nil) {
        _badgeView = [UIFactory createImageView:@"main_badge.png"];
        _badgeView.frame = CGRectMake(64-25, 5, 20, 20);
        [_badgeView sizeToFit];
        [_tabbarView addSubview:_badgeView];
        
        
        
        UILabel *badgelabel = [[UILabel alloc]
                               initWithFrame:_badgeView.bounds];
        
        badgelabel.textAlignment = NSTextAlignmentCenter;
        badgelabel.backgroundColor = [UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:0];
        badgelabel.font = [UIFont boldSystemFontOfSize:13.0f];
        badgelabel.textColor = [UIColor purpleColor];
        badgelabel.tag = 100;
        [_badgeView addSubview:badgelabel];
        [badgelabel release];
    }
    
    int n = [status intValue];
 
    if (n > 0) {
        UILabel *badgelabel = (UILabel *)[_badgeView viewWithTag:100];
        if (n >= 100) {
            n = 99;
        }
        badgelabel.text = [NSString stringWithFormat:@"%d",n];
        _badgeView.hidden = NO;// 默认是NO，但是else把它变成了YES
       
        
    }else {
        _badgeView.hidden = YES;
      
    }


}

#pragma mark - data

- (void)loadUnReadData{
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    SinaWeibo *sinaweibo = appDelegate.sinaweibo;
    // 注意URL remind前面bu需要／
    [sinaweibo requestWithURL:@"remind/unread_count.json" httpMethod:@"GET"
        params:nil
        block:^(NSDictionary *result) {
           
            [self refreshUnReadView:result];
        }];
}


#pragma mark - actions
//tab 按钮的点击事件
- (void)selectedTab:(UIButton *)button {
    
    
    float x = button.left + (button.width-_sliderView.width)/2;
    [UIView animateWithDuration:0.2 animations:^{
        _sliderView.left = x;
    }];
    
    if (button.tag == self.selectedIndex && button.tag == 0) {
        // 在homeViewController不是全局时候取得其数值的方法
//        UINavigationController *homeNav = [self.viewControllers objectAtIndex:0];
//        HomeViewController *homeCtrl = [homeNav.viewControllers objectAtIndex:0];
        // 刷新主页，更新微博
        [_home refreshWeibo];
        
    }
    self.selectedIndex = button.tag;
    
}

- (void)timerAction:(NSTimer *)timer{

    [self loadUnReadData];

}


#pragma mark - SinaWeibo delegate
//登陆成功协议方法
- (void)sinaweiboDidLogIn:(SinaWeibo *)sinaweibo {
    //保存认证的数据到本地
    NSDictionary *authData = [NSDictionary dictionaryWithObjectsAndKeys:
                              sinaweibo.accessToken, @"AccessTokenKey",
                              sinaweibo.expirationDate, @"ExpirationDateKey",
                              sinaweibo.userID, @"UserIDKey",
                              sinaweibo.refreshToken, @"refresh_token", nil];
    [[NSUserDefaults standardUserDefaults] setObject:authData forKey:@"SinaWeiboAuthData"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [_home loadWeiboData];
//    _home.tableView.hidden = NO;
}
// 注销协议方法
- (void)sinaweiboDidLogOut:(SinaWeibo *)sinaweibo {
    //移除认证的数据
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"SinaWeiboAuthData"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)sinaweiboLogInDidCancel:(SinaWeibo *)sinaweibo {
    NSLog(@"sinaweiboLogInDidCancel");    
}

#pragma mark - navigationController delegate

// 初始的时候，只要navigationController出现就会调用这个方法。
- (void)navigationController:(UINavigationController *)navigationController
      willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    // 导航控制器子控制器的个数
    int count = navigationController.viewControllers.count;
    if (count == 2) {
        [self showTabbar:NO];
    }else if(count == 1){
        [self showTabbar:YES];
    }
}


@end
