//
//  DataService.h
//  WXWeibo
//
//  Created by cannaan on 13-7-30.
//  Copyright (c) 2013年 www.iphonetrain.com 无限互联3G学院. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ASIFormDataRequest.h"

typedef void(^RequestFinishBlock)(id result);
@interface DataService : NSObject

+ (ASIHTTPRequest *)requestWithURL:(NSString *)urlstring params:(NSMutableDictionary *)params HTTPMethod:(NSString *)httpMethod completeBlock:(RequestFinishBlock)block;

@end
