//
//  WXFaseView.m
//  WXWeibo
//
//  Created by cannaan on 13-7-28.
//  Copyright (c) 2013年 www.iphonetrain.com 无限互联3G学院. All rights reserved.
//

#import "WXFaseView.h"

#define item_width 42
#define item_height 45
@implementation WXFaseView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initDate];
        self.pageNumber = items.count;
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}
/*
 *    数组
 *
 */


- (void)initDate {
    // 读取plist文件,放到二维数组中，
    items = [[NSMutableArray alloc] init];
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"emoticons" ofType:@"plist"];
    NSArray *fileArray = [NSArray arrayWithContentsOfFile:filePath];
    
    NSMutableArray *item2D = nil;
    for (int i = 0; i<fileArray.count; i++) {
        NSDictionary *item = [fileArray objectAtIndex:i];
        if (i%28 == 0) {
            item2D = [NSMutableArray arrayWithCapacity:28];// 出去if就自动释放了？是不是用其他方法创建就不可以或者return也不可以？
            [items addObject:item2D];
        }
        [item2D addObject:item];
        
    }
    // 设置尺寸
    self.width = items.count*320;
    self.height = 4*item_height;
    //表情所占的区域的宽和高宏定义

    
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
    
    // 创建表情视图
    
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    int row = 0;
    int colum = 0;
    
    for (int i = 0; i<items.count; i++) {
        NSArray *item2D = [items objectAtIndex:i];
        
        for (int j = 0; j<item2D.count; j++) {
            
            NSDictionary *item = [item2D objectAtIndex:j];
            NSString *imageName = [item objectForKey:@"png"];
            UIImage *image = [UIImage imageNamed:imageName];
            CGRect frame = CGRectMake(colum * item_width+15, row*item_height+15, 30, 30);
            
            //考虑页数，需要加上前面几页的宽度
            float x = (i*320)+frame.origin.x;
            frame.origin.x = x;
            
            [image drawInRect:frame];
            // 更新列与行
            colum++;
            if (colum % 7 == 0) {
                row++;
                colum = 0;
            }
            if (row == 4) {
                row = 0;
            }
        }
    }
}
//计算行和列
- (void)touchFace:(CGPoint)point {
    int page = point.x / 320;
    
    int row = (point.x - (320 * page) - 15)/item_width;
    int colum = (point.y - 15)/item_height;
    
    if (colum>6) {
        colum = 6;
    }
    if (colum<0) {
        colum = 0;
    }
    if (row > 3) {
        row = 3;
    }
    if (row < 0) {
        row = 0;
    }
    
    int index = colum + (row*7);
    
    NSArray *item2D = [items objectAtIndex:page];
    NSDictionary *item = [item2D objectAtIndex:index];
    NSString *faceName = [item objectForKey:@"chs"];
  
    
    if (![self.selectFaceName isEqualToString:faceName] || self.selectFaceName == nil) {
        magnifierView.left = (page*320)+(colum*item_width);
        magnifierView.bottom = row*item_height+30;
        // 放大镜中的表情视图
        NSString *imageName = [item objectForKey:@"png"];
        UIImage *image = [UIImage imageNamed:imageName];
        UIImageView *emotion = (UIImageView *)[magnifierView viewWithTag:10];
        emotion.image = image;
        
        self.selectFaceName = faceName;
    }
}

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

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    magnifierView.hidden = YES;
    if ([self.superview isKindOfClass:[UIScrollView class] ]) {
        UIScrollView *scrollView = (UIScrollView *)self.superview;
        scrollView.scrollEnabled = YES;
    }
    //调用block
    if (self.block != nil) {
        _block(_selectFaceName);// 不能在这里release，因为多次调用
    }
    
}

- (void)dealloc {
    Block_release(_block);
    [super dealloc];
    
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


@end
