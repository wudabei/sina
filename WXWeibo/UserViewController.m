//
//  UserViewController.m
//  WXWeibo
//
//  Created by cannaan on 13-7-25.
//  Copyright (c) 2013年 www.iphonetrain.com 无限互联3G学院. All rights reserved.
//

#import "UserViewController.h"
#import "UserInfoView.h"
#import "UIFactory.h"
#import "UserModel.h"
#import "WeiboModel.h"
#import "WeiboModel.h"

@interface UserViewController ()

@end

@implementation UserViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {

    }
    return self;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
//    UserInfoView *userInfo = [[UserInfoView alloc] initWithFrame:CGRectMake(0, 0, 320, 200)];
    
    _request = [[NSMutableArray alloc] init];
    self.title = @"个人资料";
    self.userInfo = [[UserInfoView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 200)];// 自动释放???自动释放
    // 需要放到后面得等到数据请求完成后再赋值。
//       self.tableView.tableHeaderView = _userInfo;
    
    UIButton *homeButton = [UIFactory createButtonWithBackground:@"tabbar_home.png" backgroundHighlighted:@"tabbar_home_highlighted.png"];
    homeButton.frame = CGRectMake(0,0,34,27);
    [homeButton addTarget:self action:@selector(goHome) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *homeItem = [[UIBarButtonItem alloc] initWithCustomView:homeButton];
    self.navigationItem.rightBarButtonItem = [homeItem autorelease];
    
    
    self.tableView.hidden = YES;
    self.tableView.eventDelegate = self;
    [super showLoading:YES];
    [self loadUserData];
    [self loadWeiboData];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    // 当该控制器界面取消时候，取消请求。
    for (SinaWeiboRequest * requset in _request) {
        [requset disconnect];
    }
}


#pragma  mark - data
// 加载用户资料
- (void)loadUserData {
    if (self.userName.length == 0) {
        NSLog(@"user error");
        return;
    }
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObject:self.userName forKey:@"screen_name"];
    
   SinaWeiboRequest *request = [self.sinaweibo requestWithURL:@"users/show.json" httpMethod:@"GET" params:params block:^(id result) {
        [self loadUserDataFinish:result];
    }];
    [_request addObject:request];
}

- (void)loadUserDataFinish:(NSDictionary *)result {
    UserModel *userModel = [[UserModel alloc] initWithDataDic:result];
    self.userInfo.user = userModel;
    [self refreshUI];
//    self.tableView.tableHeaderView = self.userInfo;
}

// 加载用户微博数据
- (void)loadWeiboData {
    if (self.userName.length == 0) {
        NSLog(@"errror");
        return;
    }
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObject:self.userName forKey:@"screen_name"];
    
    SinaWeiboRequest *request2 = [self.sinaweibo requestWithURL:@"statuses/user_timeline.json" httpMethod:@"GET" params:params block:^(id result) {
        [self loadWeiboDataFinish:result];
    }];
    [_request addObject:request2];
}

- (void)loadWeiboDataFinish:(NSDictionary *)result {
    NSArray *statuses = [result objectForKey:@"statuses"];
    NSMutableArray *weibos = [NSMutableArray arrayWithCapacity:statuses.count];    
    for (NSDictionary *dic in statuses) {
        WeiboModel *weiboModel = [[WeiboModel alloc] initWithDataDic:dic];
        [weibos addObject:weiboModel];
        [weiboModel release];
    }
    self.tableView.data = weibos;
    if (weibos.count >=20) {
        self.tableView.isMore = YES;
    }else {
        self.tableView.isMore = NO;
    }
     self.tableView.hidden = NO;
    [self.tableView reloadData];
}

#pragma mark - BaseTableView delegate
// 下拉
- (void)pullDown:(BaseTableView *)tableView {
    //模拟
    [tableView performSelector:@selector(doneLoadingTableViewData) withObject:nil afterDelay:1];
}
// 上拉
- (void)pullUp:  (BaseTableView *)tableView {
    [tableView performSelector:@selector(reloadData) withObject:nil afterDelay:1];
}
// 选中一个cell
- (void)tableView:(BaseTableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
 // weibotableView实现
}

#pragma mark - UI
- (void)refreshUI {
    [super showLoading:NO];// ?????????
    self.tableView.hidden = NO;
    self.tableView.tableHeaderView = _userInfo;
}

#pragma mark - actions
- (void)goHome {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [_tableView release];
    [super dealloc];
}

- (void)viewDidUnload {
    [self setTableView:nil];
    [super viewDidUnload];
}
@end
