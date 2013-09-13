//
//  WXimageView.h
//  WXWeibo
//
//  Created by cannaan on 13-7-26.
//  Copyright (c) 2013年 www.iphonetrain.com 无限互联3G学院. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^ImageBlock)(void);

@interface WXimageView : UIImageView
@property (nonatomic,copy)ImageBlock touchBlock;
@end
