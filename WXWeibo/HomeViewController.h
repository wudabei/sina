//
//  HomeViewController.h
//  WXWeibo
//  首页控制器
//  Created by wei.chen on 13-1-21.
//  Copyright (c) 2013年 www.iphonetrain.com 无限互联3G学院. All rights reserved.

#import "BaseViewController.h"
#import "WeiboTableView.h"
@class WeiboTableView;
@class ThemeImageView;
@interface HomeViewController : BaseViewController<SinaWeiboRequestDelegate,UITableViewEventDelegate>{
    ThemeImageView *barView;
    

}


@property (retain, nonatomic)  WeiboTableView *tableView;

// 最上面的ID
@property (nonatomic,copy)NSString *topWeiboId;
@property (nonatomic,copy)NSString *lastWeiboId;
@property (nonatomic,retain)NSMutableArray *weibos;

- (void)refreshWeibo;
- (void)loadWeiboData;
@end
