//
//  DetailViewController.h
//  WXWeibo
//
//  Created by cannaan on 13-7-20.
//  Copyright (c) 2013年 www.iphonetrain.com 无限互联3G学院. All rights reserved.
//

#import "BaseViewController.h"
#import "CommentTableView.h"
@class WeiboModel;
@class WeiboView;
@class CommentTableView;
@interface DetailViewController : BaseViewController<UITableViewEventDelegate>
{
    WeiboView *_weiboView;
}
@property (nonatomic,retain)WeiboModel *weiboModel;

@property (retain, nonatomic) IBOutlet UIView *userBarView;
@property (retain, nonatomic) IBOutlet UILabel *nickLabel;
@property (retain, nonatomic) IBOutlet UIImageView *userImageView;
@property (retain, nonatomic) IBOutlet CommentTableView *tableView;

@end
