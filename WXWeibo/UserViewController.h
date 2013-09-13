//
//  UserViewController.h
//  WXWeibo
//
//  Created by cannaan on 13-7-25.
//  Copyright (c) 2013年 www.iphonetrain.com 无限互联3G学院. All rights reserved.
//

#import "BaseViewController.h"
#import "WeiboTableView.h"
@class UserInfoView;
@interface UserViewController : BaseViewController<UITableViewEventDelegate>
{
    NSMutableArray *_request;// 当前控制器的请求对象。
}
@property (nonatomic,copy)NSString *userName;
@property (nonatomic,retain)UserInfoView *userInfo;
//@property (nonatomic,retain)SinaWeibo *sinaweibo;

@property (retain, nonatomic) IBOutlet WeiboTableView *tableView;

@end
