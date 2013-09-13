//
//  WeiboTableView.m
//  WXWeibo
//
//  Created by cannaan on 13-7-10.
//  Copyright (c) 2013年 www.iphonetrain.com 无限互联3G学院. All rights reserved.
//

#import "WeiboTableView.h"
#import "WeiboCell.h"
#import "WeiboModel.h"
#import "WeiboView.h"
#import "DetailViewController.h"

@implementation WeiboTableView


- (id)initWithFrame:(CGRect)frame style:(UITableViewStyle)style{

    self = [super initWithFrame:frame style:style];
    if (self != nil) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadData) name:kReloadWeiboTableNotification object:nil];
    }
    return self;
}

#pragma mark - UITableView delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.data.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identify = @"WeiboCell";
    WeiboCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
    if (cell == nil) {
        cell = [[[WeiboCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify] autorelease];
    }
    
    WeiboModel *weibo = [self.data objectAtIndex:indexPath.row];
    cell.weiboModel = weibo;
    
    return cell;
}

- (float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    WeiboModel *weibo = [self.data objectAtIndex:indexPath.row];
    float height = [WeiboView getWeiboViewHeight:weibo isRepost:NO isDetail:NO];
    
    height += 60;
    
    return height;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    WeiboModel *weibo = [self.data objectAtIndex:indexPath.row];
    DetailViewController *detail = [[DetailViewController alloc] init];
    detail.weiboModel = weibo;
    
    [self.viewController.navigationController pushViewController:detail animated:YES];
    [detail release];
    
    [tableView deselectRowAtIndexPath:indexPath animated:NO];

}

@end
