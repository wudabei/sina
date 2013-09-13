//
//  HomeViewController.m
//  WXWeibo
//
//  Created by wei.chen on 13-1-21.
//  Copyright (c) 2013年 www.iphonetrain.com 无限互联3G学院. All rights reserved.
//

#import "HomeViewController.h"
#import "WeiboModel.h"
#import "WeiboTableView.h"
#import "UIFactory.h"
#import <AudioToolbox/AudioToolbox.h>
#import "MainViewController.h"
#import "DetailViewController.h"
#import "AppDelegate.h"
//#import "EGORefreshTableHeaderView.h"
@interface HomeViewController ()

@end
@implementation HomeViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"微博";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //绑定按钮
    UIBarButtonItem *bindItem = [[UIBarButtonItem alloc] initWithTitle:@"绑定账号" style:UIBarButtonItemStyleBordered target:self action:@selector(bindAction:)];
    self.navigationItem.rightBarButtonItem = [bindItem autorelease];
    
    //注销按钮
    UIBarButtonItem *logoutItem = [[UIBarButtonItem alloc] initWithTitle:@"注销" style:UIBarButtonItemStyleBordered target:self action:@selector(logoutAction:)];
    self.navigationItem.leftBarButtonItem = [logoutItem autorelease];
    
    _tableView =  [[WeiboTableView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight - 20 -49 -44) style:UITableViewStylePlain];
    _tableView.eventDelegate = self;
    // 初始化时候设置为隐藏
    self.tableView.hidden = YES;
    [self.view addSubview:_tableView];
    
    //判断是否认证
    if (self.sinaweibo.isAuthValid) {
        //
        
        //加载微博列表数据,第一次加载
        [self loadWeiboData];
    }else {
        //登陆
        [self.sinaweibo logIn];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    //开启左滑右滑，拿到appdelegate 中ddmenu ，将其改为全局的属性，需要在头文件中导入
    [self.appdelegate.menuCtrl setEnableGesture:YES];

}


- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    //禁用左滑右滑
    [self.appdelegate.menuCtrl setEnableGesture:NO];
}
#pragma mark - UI
// 显示新微博数量
- (void)showNewWeiboCount:(int)count{
    if (barView == nil) {
        barView = [[UIFactory createImageView:@"timeline_new_status_background.png"]retain];// 自动释放池管理
        UIEdgeInsets inset = UIEdgeInsetsMake(10, 7, 10, 7);

        UIImage *image = [barView.image resizableImageWithCapInsets:inset];
        barView.image = image;
        barView.edgeInSert = inset;
//        barView.leftCapWidth = 5;
//        barView.topCapHeight = 34;
        barView.frame = CGRectMake(5, -40, (ScreenWidth - 10), 40);
        
        [self.view addSubview:barView];

        
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectZero];
        label.tag = 2013;
        label.font = [UIFont systemFontOfSize:16.0f];
        label.textColor = [UIColor whiteColor];
        label.backgroundColor = [UIColor clearColor];
        [barView addSubview:label];
        [label release];
    }
    
       
    if (count > 0) {
        UILabel *label = (UILabel *)[barView viewWithTag:2013];
        
        label.text = [NSString stringWithFormat:@"%d条新微博",count];
//        label.textColor = [UIColor blackColor];
        [label sizeToFit];
        
        label.origin = CGPointMake((barView.width - label.width)/2, (barView.height - label.height)/2);
        
        [UIView animateWithDuration:0.6 animations:^{
            barView.top = 5;//??如何改变 实质上改变的是什么
            
        } completion:^(BOOL finished) {
            
            if (finished) {
                // 需要再加一个动画,自动没有动画
                [UIView beginAnimations:nil context:nil];
                [UIView setAnimationDelay:1];
                [UIView setAnimationDuration:0.6];
                
                barView.top = -40;
                
                [UIView commitAnimations];
            }
        }];
        
        // 播放提示声音。系统生硬
        // 1. 拿到路径
        NSString *filePath = [[NSBundle mainBundle]pathForResource:@"msgcome" ofType:@"wav"];
        NSURL *url = [NSURL fileURLWithPath:filePath];
        
        // 2.注册声音
        SystemSoundID soundID;
        AudioServicesCreateSystemSoundID((CFURLRef)url, &soundID);
        AudioServicesPlaySystemSound(soundID);
    }
    
    // 隐藏未读图标
    MainViewController *mainCtrl = (MainViewController *)self.tabBarController;
    [mainCtrl showbadge:NO];
    
}

#pragma mark - load Data

// 程序启动时，加载数据
- (void)loadWeiboData {
    // 显示加载提示
//    [super showLoading:YES];
//    [super showHUD:@"正在加载..." isDim:YES];
    
    //  count 单页返回的纪录条数  最大不超过100  默认是20
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObject:@"20" forKey:@"count"];
    [self.sinaweibo requestWithURL:@"statuses/home_timeline.json"
                            params:params
                        httpMethod:@"GET"
                          delegate:self];
    
}
// 下拉加载最新微博
- (void)pullDownData{
    if (self.topWeiboId == 0) {
        NSLog(@"微博ID为空");
        return;
    }
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"20",@"count",self.topWeiboId,@"since_id", nil];
    [self.sinaweibo requestWithURL:@"statuses/home_timeline.json"
                            httpMethod:@"GET"
                            params:params
                             block:^(id result){
                                 [self pullDownDataFinish:result];

                             }];
}

- (void)pullDownDataFinish:(id)result{
    NSArray *statues = [result objectForKey:@"statuses"];
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:statues.count];
    for (NSDictionary *statuesDic in statues) {
        WeiboModel *weibo = [[WeiboModel alloc] initWithDataDic:statuesDic];
        [array addObject:weibo];
        [weibo release];
    }
    // 更新topID
    if (array.count > 0) {
        WeiboModel *topWeibo = [array objectAtIndex:0];
        self.topWeiboId = [topWeibo.weiboId stringValue];

    }
    // 数据赋值
    [array addObjectsFromArray:self.weibos];
    self.weibos = array;
    self.tableView.data = self.weibos;
    // 刷新UI
    [self.tableView reloadData];
    // 弹回下拉
    [self.tableView doneLoadingTableViewData];
    
    // 显示更新的微博数目
    int updateCount = statues.count;
    [self showNewWeiboCount:updateCount];
}

// 双击更新
- (void)refreshWeibo{
    // 让UI处于下拉
    [self.tableView refreshData];
    self.tableView.hidden = NO;
    // 取得数据
    [self pullDownData];
}


- (void)pullUpData {

    if (self.lastWeiboId.length == 0) {
        NSLog(@"微博ID为空");
        return;
    }
    
    /*
     * count 单页返回的纪录条数  最大不超过100  默认是20
     * max_id 若指定此参数，则返回ID小于或者等于max_id的微博，默认为0
     */
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"20",@"count",self.lastWeiboId,@"max_id", nil];
    
    [self.sinaweibo requestWithURL:@"statuses/home_timeline.json"
                        httpMethod:@"GET"
                            params:params
                             block:^(id result) {
                                 
                                 [self pullUPDataFinish:result];
    }];
  
}

- (void)pullUPDataFinish:(id)result {
    NSArray *status = [result objectForKey:@"statuses" ];
   
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:status.count];
    
    for (NSDictionary *statusDic in status) {
        // 通过字典赋属性
        WeiboModel *weibo = [[WeiboModel alloc] initWithDataDic:statusDic];
        [array addObject:weibo];
        [weibo release];
    }
    
    // 更新Last ID?? 这个还需要做么？
    if (array.count > 0) {
        WeiboModel *lastWeibo = [array lastObject];
        self.lastWeiboId = [lastWeibo.weiboId stringValue];
        [array removeObjectAtIndex:0];
    }
    

    
    // 将数组追加到微博列表后面
    [self.weibos addObjectsFromArray:array];

    // 刷新UI
    // 判断是否有20条
    if (status.count >= 20) {
        self.tableView.isMore = YES;
    }else {
        self.tableView.isMore = YES;
    }
    self.tableView.data = self.weibos;
    [self.tableView reloadData];
}

#pragma mark - SinaWeiboRequest delegate

//网络加载失败
- (void)request:(SinaWeiboRequest *)request didFailWithError:(NSError *)error {
    NSLog(@"网络加载失败:%@",error);
}

//网络加载完成
- (void)request:(SinaWeiboRequest *)request didFinishLoadingWithResult:(id)result {
//    self.tableView.hidden = NO;

    // 隐藏加载提示
//    [super showLoading:NO];
//    [self hideHUD];
    NSArray *statues = [result objectForKey:@"statuses"];
    NSMutableArray *weibos = [NSMutableArray arrayWithCapacity:statues.count];
    for (NSDictionary *statuesDic in statues) {
        WeiboModel *weibo = [[WeiboModel alloc] initWithDataDic:statuesDic];
        [weibos addObject:weibo];
        [weibo release];
    }
    
    self.tableView.data = weibos;
    self.weibos = weibos;
    
    // 将最近的微博ID保存起来了。
    if (weibos.count > 0) {
        WeiboModel *topWeibo = [weibos objectAtIndex:0];
        self.topWeiboId = [topWeibo.weiboId stringValue];
        // 记下最后一条微博的id
        WeiboModel *lastWeibo = [weibos lastObject];
        self.lastWeiboId = [lastWeibo.weiboId stringValue];
    }
    
    //刷新tableView
    [self.tableView reloadData];
}


#pragma mark - tableView eventDelegate
// 下拉
- (void)pullDown:(BaseTableView *)tableView{
//    [tableView performSelector:@selector(doneLoadingTableViewData) withObject:nil afterDelay:1];
    [self pullDownData];
}
// 上拉
- (void)pullUp:  (BaseTableView *)tableView{
    
    [self pullUpData];
}
// 选中一个cell
- (void)tableView:(BaseTableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    DetailViewController *detail = [[DetailViewController alloc]init];
    WeiboModel *weibo = [self.weibos objectAtIndex:indexPath.row];
    detail.weiboModel = weibo;
    [self.navigationController pushViewController:detail animated:YES];
    [detail release];
}
#pragma mark - actions
- (void)bindAction:(UIBarButtonItem *)buttonItem {
    [self.sinaweibo logIn];
}
- (void)logoutAction:(UIBarButtonItem *)buttonItem {
    [self.sinaweibo logOut];
}
#pragma mark - Memery Manager
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
}


@end
