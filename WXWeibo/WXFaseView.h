//
//  WXFaseView.h
//  WXWeibo
//
//  Created by cannaan on 13-7-28.
//  Copyright (c) 2013年 www.iphonetrain.com 无限互联3G学院. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^SelectBlock)(NSString *faceName);

@interface WXFaseView : UIView
{
@private
    NSMutableArray *items;
    UIImageView *magnifierView;
}
@property (nonatomic,copy)NSString *selectFaceName;// 记住选中的表情
@property (nonatomic,assign)NSInteger pageNumber;
@property (nonatomic,assign)SelectBlock block;
@end
