//
//  UIVew+Additions.m
//  WXWeibo
//
//  Created by cannaan on 13-7-25.
//  Copyright (c) 2013年 www.iphonetrain.com 无限互联3G学院. All rights reserved.
//

#import "UIVew+Additions.h"

@implementation UIView (Additions)
- (UIViewController *)viewController{
    
    UIResponder *next = [self nextResponder];//get nextResponder
    do {
        if ([next isKindOfClass:[UIViewController class]]) {
            return (UIViewController *)next;
        }

        next = [next nextResponder];
    } while (next != nil);
    return nil;

}
@end
