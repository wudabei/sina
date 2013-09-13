//
//  NearbyViewController.h
//  WXWeibo
//
//  Created by cannaan on 13-7-27.
//  Copyright (c) 2013年 www.iphonetrain.com 无限互联3G学院. All rights reserved.
//

#import "BaseViewController.h"
#import <CoreLocation/CoreLocation.h>

typedef void(^SelectDoneBlock)(NSDictionary *);// 返回cell中的字典返回

@interface NearbyViewController : BaseViewController<UITableViewDataSource,UITableViewDelegate,CLLocationManagerDelegate>
@property (retain, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic,retain)NSArray *data;
@property (nonatomic,copy)SelectDoneBlock selectBlock;
@end
