//
//  BrowModeControllerViewController.h
//  WXWeibo
//
//  Created by cannaan on 13-7-24.
//  Copyright (c) 2013年 www.iphonetrain.com 无限互联3G学院. All rights reserved.
//

#import "BaseViewController.h"

@interface BrowModeControllerViewController : BaseViewController<UITableViewDataSource,UITableViewDelegate>
@property (retain, nonatomic) IBOutlet UITableView *tablview;

@end
