//
//  WXFaceScrollerView.m
//  WXWeibo
//
//  Created by cannaan on 13-7-28.
//  Copyright (c) 2013年 www.iphonetrain.com 无限互联3G学院. All rights reserved.
//

#import "WXFaceScrollerView.h"

@implementation WXFaceScrollerView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initViews];
    }
    return self;
}

- (id)initWithSelectBlock:(SelectBlock)block {
    self = [self initWithFrame:CGRectZero];
    if (self != nil) {
        faceView.block = block;
    }
    return self;
}

- (void)initViews {
    
    faceView = [[GaryFaceView alloc] initWithFrame:CGRectZero];
    scrollerView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, 320, faceView.height)];
    scrollerView.contentSize = CGSizeMake(faceView.width, faceView.height);
    scrollerView.pagingEnabled = YES;
    scrollerView.showsHorizontalScrollIndicator = NO;//禁止滚动条
    scrollerView.clipsToBounds = NO;//超出视图的部分是否被裁减
    scrollerView.delegate = self;//监听偏移量
    scrollerView.backgroundColor = [UIColor clearColor];
    [scrollerView addSubview:faceView];
    [self addSubview:scrollerView];
    
    pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, scrollerView.bottom+2, 40, 20)];
    pageControl.backgroundColor = [UIColor clearColor];
    pageControl.numberOfPages = faceView.pageNumber;
    pageControl.currentPage = 0;
    [self addSubview:pageControl];
    
    
    self.height = scrollerView.height + pageControl.height;
    self.width = scrollerView.width;
//    self.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"emoticon_keyboard_background.png"]];
}

- (void)drawRect:(CGRect)rect {
    [[UIImage imageNamed:@"emoticon_keyboard_background.png"] drawInRect:rect];
}

// get scrollView offset
- (void)scrollViewDidScroll:(UIScrollView *)_scrollView {
    int pageNumber = _scrollView.contentOffset.x/320;
    pageControl.currentPage = pageNumber;
}

- (void)dealloc {
    [scrollerView release];
    [faceView release];
    [super dealloc];
}
@end
