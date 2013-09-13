//
//  GaryFaceView.m
//  WXWeibo
//
//  Created by cannaan on 13-7-29.
//  Copyright (c) 2013年 www.iphonetrain.com 无限互联3G学院. All rights reserved.
//

#import "GaryFaceView.h"

#define item_width 42
#define item_height 45
#define columPerPage 7// 每页列数
#define countPerPage 28// 每页总数

@implementation GaryFaceView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initDate];
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}
- (void)initDate {
    
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"emoticons" ofType:@"plist"];
    array = [[NSMutableArray arrayWithContentsOfFile:filePath]retain];
    
    // self的尺寸和长度
    self.height = 4 * item_height;
    self.width = (array.count/countPerPage + 1) * 320;

    // 放大镜
    magnifierView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 64, 92)];
    magnifierView.image = [UIImage imageNamed:@"emoticon_keyboard_magnifier.png"];
    magnifierView.backgroundColor = [UIColor clearColor];
    magnifierView.hidden = YES;
    
    UIImageView *emoticon = [[UIImageView alloc] initWithFrame:CGRectMake(64/2 - 30/2, 15, 30, 30)];
    emoticon.tag = 10;
    emoticon.backgroundColor = [UIColor clearColor];
    [magnifierView addSubview:emoticon];
    [emoticon release];
    [self addSubview:magnifierView];
    
}



//绘制图片
- (void)drawRect:(CGRect)rect
{
    for (int i = 0; i<array.count; i++) {
        // get image
        NSDictionary *dic = [array objectAtIndex:i];
        NSString *imageName = [dic objectForKey:@"png"];
        UIImage *image  = [UIImage imageNamed:imageName];
        // get frame
        CGPoint point = [self returnCoordinate:i];
        CGRect frame = CGRectMake(point.x,point.y, 30, 30);

        [image drawInRect:frame];
    }
}

// 显示放大镜
- (void)touchFace:(CGPoint)point {
   
    int index = [self returnCount:point];
    NSDictionary *item = [array objectAtIndex:index];
    NSString *faceName = [item objectForKey:@"chs"];
    

    if (![self.selectFaceName isEqualToString:faceName] || self.selectFaceName == nil) {
        // 确定放大镜的位置
        CGPoint newPoint = [self returnCoordinate:[self returnCount:point]];
        
        magnifierView.left = newPoint.x - 64/2 + 30/2;
        magnifierView.bottom = newPoint.y + 30;
//        magnifierView.left = (page*320)+(colum*item_width);
//        magnifierView.bottom = row*item_height+30;
        
        // 放大镜中的表情视图
        NSString *imageName = [item objectForKey:@"png"];
        UIImage *image = [UIImage imageNamed:imageName];
        UIImageView *emotion = (UIImageView *)[magnifierView viewWithTag:10];
        emotion.image = image;
    }
    self.selectFaceName = faceName;
}

// 根据坐标返回所对应的索引
- (int)returnCount: (CGPoint)point {
    
    int x = point.x;
    int y = point.y;
    
    int colum = x%320  ;
    if (colum >  item_width*columPerPage -15 ) {
        colum =  item_width*columPerPage - 15 - 1 ;
    }
    int index = (x/320) * countPerPage // 整页数
                + (colum - 15)/item_width  // 第几列
                + (y - 15) / item_height *columPerPage ;// 整行数

    return index;
}

// 根据索引，返回坐标()
- (CGPoint)returnCoordinate:(int)index {
    
    int x =   (index / countPerPage) * 320
              + ((index % countPerPage) % columPerPage ) * item_width + 15;
    int y =   (index % countPerPage) / columPerPage * item_height + 15;
    CGPoint point = CGPointMake((float)x, (float)y);
    
    return point;
}

#pragma mark - touch event
// touch事件
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    magnifierView.hidden = NO;
    
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self];
    [self touchFace:point];
    
    if ([self.superview isKindOfClass:[UIScrollView class] ]) {
        UIScrollView *scrollView = (UIScrollView *)self.superview;
        scrollView.scrollEnabled = NO;
    }
}
- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self];
    [self touchFace:point];
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
    if ([self.superview isKindOfClass:[UIScrollView class] ]) {
        UIScrollView *scrollView = (UIScrollView *)self.superview;
        scrollView.scrollEnabled = YES;
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    magnifierView.hidden = YES;
    if ([self.superview isKindOfClass:[UIScrollView class] ]) {
        UIScrollView *scrollView = (UIScrollView *)self.superview;
        scrollView.scrollEnabled = YES;
    }
    //调用block
    if (self.block != nil) {
        _block(_selectFaceName);// 
    }
}

- (void)dealloc {
    NSLog(@"%s",__FUNCTION__);
    [array release];
    Block_release(_block);
    [super dealloc];
}
@end
