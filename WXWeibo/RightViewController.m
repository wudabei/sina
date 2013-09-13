//
//  RightViewController.m
//  WXWeibo
//
//  Created by wei.chen on 13-1-21.
//  Copyright (c) 2013年 www.iphonetrain.com 无限互联3G学院. All rights reserved.
//

#import "RightViewController.h"
#import "SendViewController.h"
#import "BaseNavigationController.h"

@interface RightViewController ()

@end

@implementation RightViewController

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
    self.view.backgroundColor = [UIColor darkGrayColor];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)action:(UIButton *)sender {
    switch (sender.tag) {
      
        case 101:
        {
            SendViewController *sendCtrl = [[SendViewController alloc] init];
            BaseNavigationController *sendNav= [[BaseNavigationController alloc] initWithRootViewController:sendCtrl];
            [self.appdelegate.menuCtrl presentViewController:sendNav animated:YES completion:NULL];
            //            [self presentViewController:sendNav animated:YES completion:NULL];
            [sendCtrl release];//  导航控制器，控制器相互的关系

            break;
        }
        case 102:
        {
            
            break;
        }
        case 103:
        {
            
            break;
        }
        case 104:
        {
            
            break;
        }
        case 105:
        {
            
            break;
        }
       
    }
}
@end
