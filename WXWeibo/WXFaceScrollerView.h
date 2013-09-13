//
//  WXFaceScrollerView.h
//  WXWeibo
//
//  Created by cannaan on 13-7-28.
//  Copyright (c) 2013年 www.iphonetrain.com 无限互联3G学院. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GaryFaceView.h"

@interface WXFaceScrollerView : UIView<UIScrollViewDelegate>
{
    UIScrollView    *scrollerView;
    UIPageControl   *pageControl;
    GaryFaceView      *faceView;
}

- (id)initWithSelectBlock:(SelectBlock)block;
@end
