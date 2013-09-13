//
//  WeiboCell.m
//  WXWeibo
//
//  Created by wei.chen on 13-1-23.
//  Copyright (c) 2013年 www.iphonetrain.com 无限互联3G学院. All rights reserved.
//

#import "WeiboCell.h"
#import <QuartzCore/QuartzCore.h>
#import "WeiboView.h"
#import "WeiboModel.h"
#import "UIImageView+WebCache.h"
#import "UIUtils.h"
#import "RegexKitLite.h"
#import "WXimageView.h"
#import "UserViewController.h"
@implementation WeiboCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self _initView];
    }
    return self;
}

//初始化子视图
- (void)_initView {
    //用户头像
    _userImage = [[WXimageView alloc] initWithFrame:CGRectZero];
    _userImage.backgroundColor = [UIColor clearColor];
    _userImage.layer.cornerRadius = 5;  //圆弧半径
    _userImage.layer.borderWidth = .5;
    _userImage.layer.borderColor = [UIColor grayColor].CGColor;
    _userImage.layer.masksToBounds = YES;
    
    [self.contentView addSubview:_userImage];
    
    //昵称
    _nickLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    _nickLabel.backgroundColor = [UIColor clearColor];
    _nickLabel.font = [UIFont systemFontOfSize:14.0];
    [self.contentView addSubview:_nickLabel];
    
    //转发数
    _repostCountLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    _repostCountLabel.font = [UIFont systemFontOfSize:12.0];
    _repostCountLabel.backgroundColor = [UIColor clearColor];
    _repostCountLabel.textColor = [UIColor blackColor];
    [self.contentView addSubview:_repostCountLabel];
    
    //回复数
    _commentLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    _commentLabel.font = [UIFont systemFontOfSize:12.0];
    _commentLabel.backgroundColor = [UIColor clearColor];
    _commentLabel.textColor = [UIColor blackColor];
    [self.contentView addSubview:_commentLabel];
    
    
    //微博来源
    _sourceLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    _sourceLabel.font = [UIFont systemFontOfSize:12.0];
    _sourceLabel.backgroundColor = [UIColor clearColor];
    _sourceLabel.textColor = [UIColor blackColor];
    [self.contentView addSubview:_sourceLabel];
    
    //发布时间
    _createLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    _createLabel.font = [UIFont systemFontOfSize:12.0];
    _createLabel.backgroundColor = [UIColor clearColor];
    _createLabel.textColor = [UIColor blueColor];
    [self.contentView addSubview:_createLabel];
    
    _weiboView = [[WeiboView alloc] initWithFrame:CGRectZero];
    [self.contentView addSubview:_weiboView];
    
    // 设置cell的选中背景颜色
    UIView *selectedBackgroundView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 0)];
    selectedBackgroundView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"statusdetail_cell_sepatator" ]];
    self.selectedBackgroundView = selectedBackgroundView;
    [selectedBackgroundView release];
}

// 覆写weiboModel 为了设置block，拿到昵称
- (void)setWeiboModel:(WeiboModel *)weiboModel {
    if (_weiboModel != weiboModel) {
        [_weiboModel release];
        _weiboModel = [weiboModel retain];
    }
    
    __block WeiboCell *this = self;
    _userImage.touchBlock = ^{
        NSString *nickName = this.weiboModel.user.screen_name;
        UserViewController *userCtrl = [[UserViewController alloc] init];
        userCtrl.userName = nickName;
        [this.viewController.navigationController pushViewController:userCtrl animated:YES];
    };

}


- (void)layoutSubviews {
    [super layoutSubviews];
    
    //-----------用户头像视图_userImage--------
    _userImage.frame = CGRectMake(5, 5, 35, 35);
    NSString *userImageUrl = _weiboModel.user.profile_image_url;
    [_userImage setImageWithURL:[NSURL URLWithString:userImageUrl]];
    
    //昵称_nickLabel
    _nickLabel.frame = CGRectMake(50, 5, 200, 20);
    _nickLabel.text = _weiboModel.user.screen_name;
    

    
    //微博视图_weiboView
    _weiboView.weiboModel = _weiboModel;
    //获取微博视图的高度
    float h = [WeiboView getWeiboViewHeight:_weiboModel isRepost:NO isDetail:NO];
    _weiboView.frame = CGRectMake(50, _nickLabel.bottom+10, kWeibo_Width_List, h);
    
    // weiboView 重新布局方法。
    [_weiboView setNeedsLayout];
    
    
    // 发布时间
    NSString *createDate = _weiboModel.createDate;
    
    if (createDate != nil) {
        
        NSData *data = [UIUtils dateFromFomate:createDate formate:@"E M d HH:mm:ss Z yyyy"];
        NSString *dataString = [UIUtils stringFromFomate:data formate:@"MM-dd HH:mm"];
        _createLabel.text = dataString;
        _createLabel.frame = CGRectMake(50, self.height - 20, 100, 20);
        _createLabel.hidden = NO;
        [_createLabel sizeToFit];
    }else {
    
        _createLabel.hidden = YES;
    
    }
    
    // 微博来源
    NSString *source = _weiboModel.source;
    NSString *ret = [self parseSource:source];
    if (ret != nil) {
        _sourceLabel.text = [NSString stringWithFormat:@"来自%@",ret];
        _sourceLabel.frame = CGRectMake(_createLabel.right+8, _createLabel.top, 100, 20);
        [_sourceLabel sizeToFit];
        _sourceLabel.hidden = NO;
    }else{
        _sourceLabel.hidden = YES;
    }

    
}

- (NSString *)parseSource:(NSString *)source{
    NSString *regex = @">\\w+<";
    NSArray *array =[source componentsMatchedByRegex:regex];
    if (array.count > 0) {
        NSString *ret = [array objectAtIndex:0];
        NSRange range;
        range.location = 1;
        range.length = ret.length -2;
        NSString *resultstring = [ret substringWithRange:range];
        return resultstring;
    }else{
        return nil;
    }
}

@end
