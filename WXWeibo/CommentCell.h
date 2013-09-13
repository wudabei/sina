//
//  CommentCell.h
//  WXWeibo
//
//  Created by cannaan on 13-7-20.
//  Copyright (c) 2013年 www.iphonetrain.com 无限互联3G学院. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RTLabel.h"

@class CommentModel;
@interface CommentCell : UITableViewCell<RTLabelDelegate>
{
    UIImageView *_userImage;
    UILabel     *_nickLabel;
    UILabel     *_timeLabel;
    RTLabel     *_contentLabel;
}

@property (nonatomic,retain)CommentModel *commentModel;

// 计算评论单元格的高度
+ (float)getCommentHeight:(CommentModel *)commentModel;
//@property (nonatomic,retain)WeiboModel *weiboModel;
@end
