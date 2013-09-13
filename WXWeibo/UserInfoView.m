//
//  UserInfoView.m
//  WXWeibo
//
//  Created by cannaan on 13-7-25.
//  Copyright (c) 2013年 www.iphonetrain.com 无限互联3G学院. All rights reserved.
//

#import "UserInfoView.h"
#import "RectButton.h"
#import "UIImageView+WebCache.h"
#import "UserModel.h"
@implementation UserInfoView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // 穿件了xib的view
        UIView *view = [[[NSBundle mainBundle] loadNibNamed:@"UserInfoView" owner:self options:nil] lastObject];
        [self addSubview:view];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    // 用户头像
    NSString *urlString = self.user.avatar_large;
    [self.userImage setImageWithURL:[NSURL URLWithString:urlString]];
    
    //
    self.nameLabel.text = self.user.screen_name;
    
    //性别 地址
    NSString *gender = self.user.gender;
    NSString *sexName = @"未知";
    if ([gender isEqualToString:@"m"]) {
        sexName = @"男";
    }else if([gender isEqualToString:@"f"]) {
        sexName = @"女";
    }
  
    NSString *location = self.user.location;
    //
    if (location == nil) {
        location = @"";// 否则location可能显示null
    }
    self.addressLabel.text = [NSString stringWithFormat:@"%@ %@",sexName,location];
    
    // 简介
    
    self.infoLabel.text = (self.user.description == nil)? @"":self.user.description;
    
    // 微博数
    NSString *countWeibo = [self.user.statuses_count stringValue];
    self.countLabel.text = [NSString stringWithFormat:@"共%@条微博",countWeibo];
    
    // 关注数
    self.attButton.subtitle = [self.user.friends_count stringValue];//longValue直接赋值？
    self.attButton.title = @"关注";
    
    // 粉丝数,如果大于1万需要带单位
    long fansL = [self.user.followers_count longValue];
    NSString *fans = [NSString stringWithFormat:@"%ld",fansL];
        // 单位
    if (fansL >= 10000) {
        fans = [NSString stringWithFormat:@"%ld万",fansL/10000];
    }
    self.fansButton.title = @"粉丝";
    self.fansButton.subtitle = fans;
    
}

- (void)dealloc {
    [_userImage release];
    [_nameLabel release];
    [_addressLabel release];
    [_infoLabel release];
    [_countLabel release];
    [_attButton release];
    [_fansButton release];
    [super dealloc];
}
@end
