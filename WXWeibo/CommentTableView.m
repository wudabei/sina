//
//  CommentTableView.m
//  WXWeibo
//
//  Created by cannaan on 13-7-20.
//  Copyright (c) 2013年 www.iphonetrain.com 无限互联3G学院. All rights reserved.
//

#import "CommentTableView.h"
#import "CommentCell.h"
#import "CommentModel.h"
@implementation CommentTableView

- (id)initWithFrame:(CGRect)frame style:(UITableViewStyle)style
{
    self = [super initWithFrame:frame style:style];
    if (self) {
        // Initialization code
    }
    return self;
}

#pragma mark - delegate tableView
//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
//    return _data.count;
//    
//}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identify = @"CommentCell";
    CommentCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"CommentCell" owner:self options:nil] lastObject];// ?

    }
    
    CommentModel *commentModel = [self.data objectAtIndex:indexPath.row];
    cell.commentModel = commentModel;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}

- (float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    CommentModel *commentModel = [self.data objectAtIndex:indexPath.row];
    float h = [CommentCell getCommentHeight:commentModel];
    
    return h+40;
}


// 协议方法，
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    // 高度是由单独的方法来指定的
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, tableView.width, 40)];
    view.backgroundColor = [UIColor whiteColor];
    UILabel *textLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, tableView.width, 20)];
    textLabel.backgroundColor = [UIColor clearColor];
    textLabel.font = [UIFont boldSystemFontOfSize:16.0f];
    textLabel.textColor = [UIColor blueColor];
    
    NSNumber *totle = [self.commentDic objectForKey:@"total_number"];
    if ([totle intValue] > 0) {
        textLabel.text = [NSString stringWithFormat:@"评论数他妈的是：%@",totle];
        [view addSubview:textLabel];
    }
    [textLabel release];
    
    UIImageView *separeView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 40-1, tableView.width, 1)];
    separeView.image = [UIImage imageNamed:@"userinfo_header_separator.png"];
    [view addSubview:separeView];
    [separeView release];
    
    return [view autorelease];// 注意加入到自动释放池！！！

}

- (float)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 40;
}

@end
