//
//  NearbyViewController.m
//  WXWeibo
//
//  Created by cannaan on 13-7-27.
//  Copyright (c) 2013年 www.iphonetrain.com 无限互联3G学院. All rights reserved.
//

#import "NearbyViewController.h"
#import "UIImageView+WebCache.h"
@interface NearbyViewController ()

@end

@implementation NearbyViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.isCancelButton = YES;// 需要在 super viewDidload 中执行完成。也就是说super的执行
        self.isBackButton = NO;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"我在这里呀！";
    
    self.tableView.hidden = YES;
    [super showLoading:YES];
    CLLocationManager *loctionManager = [[CLLocationManager alloc] init];
    loctionManager.delegate = self;
    [loctionManager setDesiredAccuracy:kCLLocationAccuracyNearestTenMeters];
    [loctionManager startUpdatingLocation];
}


#pragma mark - UI
- (void)refreshUI {
    self.tableView.hidden = NO;
    [super showLoading:NO];
    [self.tableView reloadData];
}

#pragma mark - CLLocationManager delegate
- (void)locationManager:(CLLocationManager *)manager
didUpdateToLocation:(CLLocation *)newLocation
           fromLocation:(CLLocation *)oldLocation {

    [manager stopUpdatingLocation];
    
    if (self.data == nil) {
        // 等于nil的时候再请求接口
        float longitude = newLocation.coordinate.longitude;
        float latitude= newLocation.coordinate.latitude;
        
        NSString *longString = [NSString stringWithFormat:@"%f",longitude];
        NSString *latString = [NSString stringWithFormat:@"%f",latitude];
//        NSNumber *longString = [NSNumber numberWithFloat:longitude];
//        NSNumber *latString = [NSNumber numberWithFloat:latitude];
        NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:longString,@"long",latString,@"lat", nil];
        [self.sinaweibo requestWithURL:@"place/nearby/pois.json" httpMethod:@"GET" params:params block:^(id result) {
            [self loadNearbyDataFinish:result];
        }];
        
    }
}


#pragma mark - data
- (void)loadNearbyDataFinish:(NSDictionary *)result {
    
    NSArray *pois = [result objectForKey:@"pois"];
    NSLog(@"rselt=========%@",result);
    self.data = pois;
    NSLog(@"++++++++++++++%@",pois);
    [self refreshUI];
    
}

#pragma mark - tableView delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.data.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *identify = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identify]autorelease];
    }
    
    NSDictionary *dic = [self.data objectAtIndex:indexPath.row];
    NSString *title = [dic objectForKey:@"title"];
    NSString *address = [dic objectForKey:@"address"];
    NSString *icon = [dic objectForKey:@"icon"];
    
    if (![title isKindOfClass:[NSNull class]]) {
        cell.textLabel.text = title;
    }
    if (![address isKindOfClass:[NSNull class]]) {
        cell.detailTextLabel.text = address;
    }
    if (![icon isKindOfClass:[NSNull class]]) {
//        [cell.imageView setImageWithURL:[NSURL URLWithString:icon]];
        [cell.imageView setImageWithURL:[NSURL URLWithString:icon] placeholderImage:[UIImage imageNamed:@"page_image_loading"]];
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;// 默认是40
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.selectBlock != nil) {
        NSDictionary *dic = [self.data objectAtIndex:indexPath.row];
        _selectBlock(dic);
        Block_release(_selectBlock);
        _selectBlock = nil;
    }
    [self dismissModalViewControllerAnimated:YES];//回到发微博界面
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
