//
//  BrowModeControllerViewController.m
//  WXWeibo
//
//  Created by cannaan on 13-7-24.
//  Copyright (c) 2013年 www.iphonetrain.com 无限互联3G学院. All rights reserved.
//

#import "BrowModeControllerViewController.h"
#import "CONSTS.h"
@interface BrowModeControllerViewController ()

@end

@implementation BrowModeControllerViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"图片浏览模式";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
}

#pragma mark - tableview delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil]autorelease];
    
    if (indexPath.row == 0) {
        cell.textLabel.text = @"大图";
        cell.detailTextLabel.text = @"所有网络加载大图";
    }
    else if(indexPath.row == 1) {
        cell.textLabel.text = @"小图";
        cell.detailTextLabel.text = @"所有网络加载小图";
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    int mode = -1;
    if (indexPath.row == 0) {
        mode = LargeBrowMode;
    }
    else if(indexPath.row == 1) {
        mode = SmallBrowMode;
    }
    // 存储到userDefaults里面,将浏览模式存到本地
    [[NSUserDefaults standardUserDefaults] setInteger:mode forKey:kBrowMode];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    //发送刷新微博列表的通知
    [[NSNotificationCenter defaultCenter] postNotificationName:kReloadWeiboTableNotification  object:nil];
    
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)dealloc {
    [_tablview release];
    [super dealloc];
}
@end
