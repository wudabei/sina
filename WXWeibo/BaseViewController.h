//
//  BaseViewController.h
//  WXWeibo
//
//  Created by wei.chen on 13-1-21.
//  Copyright (c) 2013年 www.iphonetrain.com 无限互联3G学院. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SinaWeibo.h"
#import "MBProgressHUD.h"
#import "AppDelegate.h"
@interface BaseViewController : UIViewController
{
    UIView *_loadView;
    UIWindow *_tipWindow;
}
@property(nonatomic,assign)BOOL isBackButton;
@property (nonatomic,assign)BOOL isCancelButton;// model视图 q取消
@property (nonatomic,retain)MBProgressHUD *hud;
- (SinaWeibo *)sinaweibo;
- (AppDelegate *)appdelegate;
// 提示
- (void)showLoading:(BOOL)show;
- (void)showHUD:(NSString *)title isDim:(BOOL)isDim;
- (void)hideHUD;
- (void)showHUDComplete:(NSString *)title;

// 状态栏提示
- (void)showStatuseTip:(BOOL)show title:(NSString *)title;
- (void)cancleAction;

@end
