//
//  CommentCell.m
//  WXWeibo
//
//  Created by cannaan on 13-7-20.
//  Copyright (c) 2013年 www.iphonetrain.com 无限互联3G学院. All rights reserved.
//

#import "CommentCell.h"
#import "UIImageView+WebCache.h"
#import "CommentModel.h"
#import "UIUtils.h"
@implementation CommentCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)awakeFromNib {
    // get subViews of xib
    _userImage = [(UIImageView *)[self viewWithTag:100]retain];
    _nickLabel = [(UILabel *)[self viewWithTag:101]retain];
    _timeLabel = [(UILabel *)[self viewWithTag:102]retain];
    
    // 这里给的fram 在layout中会被重置
//    _contentLabel = [[RTLabel alloc] initWithFrame:CGRectMake(_userImage.right+10, _nickLabel.bottom+5, 240, 0)];
    _contentLabel = [[RTLabel alloc] initWithFrame:CGRectZero];
    
    _contentLabel.font = [UIFont systemFontOfSize:14.0f];
    _contentLabel.delegate = self;
    _contentLabel.linkAttributes = [NSDictionary dictionaryWithObject:@"#4595CB" forKey:@"color"];
    _contentLabel.selectedLinkAttributes = [NSDictionary dictionaryWithObject:@"darkGray" forKey:@"color"];
    
    [self.contentView addSubview:_contentLabel];
    
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    // 填入数据
    NSString *urlstring = self.commentModel.user.profile_image_url;
    
    _userImage.layer.cornerRadius = 5;
    _userImage.layer.masksToBounds = YES;
    [_userImage setImageWithURL:[NSURL URLWithString:urlstring]];
    
    _nickLabel.text = self.commentModel.user.screen_name;
    _timeLabel.text = [UIUtils fomateString:self.commentModel.created_at];
   
    
    
    // 评论内容
    NSString *commentText = self.commentModel.text;
    _contentLabel.frame = CGRectMake(_userImage.right+10, _nickLabel.bottom+5, 240, 0);
   
    // 解析 @ ＃＃ 超链接
    commentText = [UIUtils parseLink:commentText];
    _contentLabel.text = commentText;
    
    // 自适应
    _contentLabel.height = _contentLabel.optimumSize.height;
    
    
    
}

+ (float)getCommentHeight:(CommentModel *)commentModel{

    RTLabel *rt = [[RTLabel alloc] initWithFrame:CGRectMake(0, 0, 240, 0)];
    rt.text = commentModel.text;
    rt.font = [UIFont systemFontOfSize:14.0f];
    return rt.optimumSize.height;
}
 #pragma mark - rtLabel delegate
- (void)rtLabel:(id)rtLabel didSelectLinkWithURL:(NSURL*)url {

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
