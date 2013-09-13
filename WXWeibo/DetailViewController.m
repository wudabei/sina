//
//  DetailViewController.m
//  WXWeibo
//
//  Created by cannaan on 13-7-20.
//  Copyright (c) 2013年 www.iphonetrain.com 无限互联3G学院. All rights reserved.
//

#import "DetailViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "UIImageView+WebCache.h"
#import "WeiboModel.h"
#import "WeiboView.h"
#import "CommentTableView.h"
#import "CommentModel.h"
@interface DetailViewController ()

@end

@implementation DetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self _initView];
    [self  loadData];
}

- (void)_initView {
    // 大的视图
    UIView *tableViewHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 0)];
    tableViewHeaderView.backgroundColor = [UIColor clearColor];
    
    // 加载用户图片
    NSString *userImgURL = _weiboModel.user.profile_image_url;
    self.userImageView.layer.cornerRadius = 5;
    self.userImageView.layer.masksToBounds = YES;
    [self.userImageView setImageWithURL: [NSURL URLWithString:userImgURL]];
    
    // 用户昵称
    self.nickLabel.text = _weiboModel.user.screen_name;
    
    [tableViewHeaderView addSubview:self.userBarView];
    tableViewHeaderView.height += 60;
    
    //----------------创建微博视图-----------------------
    float h = [WeiboView getWeiboViewHeight:self.weiboModel isRepost:NO isDetail:YES];
    _weiboView = [[WeiboView alloc]initWithFrame:CGRectMake(10, _userBarView.bottom+10, ScreenWidth - 20, h)];
    _weiboView.isDetail = YES;
    _weiboView.weiboModel = _weiboModel;
    [tableViewHeaderView addSubview:_weiboView];
    
    tableViewHeaderView.height += (h+10);
  
    self.tableView.tableHeaderView = tableViewHeaderView;
    self.tableView.eventDelegate = self;
    [tableViewHeaderView release];
}

- (void)loadData{
    NSString *weiboID = [_weiboModel.weiboId stringValue];
    if (weiboID.length == 0) {
        return;
    }
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObject:weiboID forKey:@"id"];
    [self.sinaweibo requestWithURL:@"comments/show.json" httpMethod:@"GET" params:params block:^(NSDictionary *result) {
        [self loadDataFinish:result];
    }];
}

- (void)loadDataFinish:(NSDictionary *)result{
    
    NSArray *array = [result objectForKey:@"comments"];
    NSMutableArray *comments = [NSMutableArray arrayWithCapacity:array.count];
    
    for (NSDictionary *dic in array) {
        CommentModel *commentModel = [[CommentModel alloc]initWithDataDic:dic];
        [comments addObject:commentModel];
        [commentModel release];
    }
    // 控制加载数目
    if (array.count >= 20) {
        self.tableView.isMore = YES;
    }else {
        self.tableView.isMore = NO;
    }
    self.tableView.data = comments;
    // 传给tablview评论表格属性
    self.tableView.commentDic = result;
    [self.tableView reloadData];
}


#pragma mark - BaseTableView delegate
- (void)pullDown:(BaseTableView *)tableView {
    // 模拟
    [tableView performSelector:@selector(doneLoadingTableViewData) withObject:nil afterDelay:1];
}
// 上拉
- (void)pullUp:  (BaseTableView *)tableView {
    //模拟
    [tableView performSelector:@selector(reloadData) withObject:nil afterDelay:1];
}

// 选中一个cell
- (void)tableView:(BaseTableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

}


// 更改为CommentTableVIew之后去掉 这两个协议方法
//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
//    return 0;
//
//}
//
//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
//    return nil;
//
//}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)dealloc {
    [_tableView release];
    [_userImageView release];
    [_nickLabel release];
    [_userBarView release];
    [super dealloc];
}
@end
