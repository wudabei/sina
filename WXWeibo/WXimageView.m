//
//  WXimageView.m
//  WXWeibo
//
//  Created by cannaan on 13-7-26.
//  Copyright (c) 2013年 www.iphonetrain.com 无限互联3G学院. All rights reserved.
//

#import "WXimageView.h"

@implementation WXimageView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.userInteractionEnabled = YES;// 开启相应触摸
        UITapGestureRecognizer *tapGestrue = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
        [self addGestureRecognizer:tapGestrue];
        [tapGestrue release];
    }
    return self;
}

- (void)tapAction:(UITapGestureRecognizer *)gestrue {

    if (self.touchBlock) {
        _touchBlock();// 网络请求，只请求一次。所以可以直接release block
    }
}

- (void)dealloc {
    [super dealloc];
    Block_release(_touchBlock);
}
@end
