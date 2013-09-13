//
//  DataService.m
//  WXWeibo
//
//  Created by cannaan on 13-7-30.
//  Copyright (c) 2013年 www.iphonetrain.com 无限互联3G学院. All rights reserved.
//

#import "DataService.h"
//#import "JSONKit.h"

#define BASE_URL @"https://open.weibo.cn/2/"

@implementation DataService


+ (ASIHTTPRequest *)requestWithURL:(NSString *)urlstring params:(NSMutableDictionary *)params HTTPMethod:(NSString *)httpMethod completeBlock:(RequestFinishBlock)block {
    
    // --------------------get token--------------------
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    NSDictionary *sinaweiboInfo = [defaults objectForKey:@"SinaWeiboAuthData"];
    NSString *accessToken = [sinaweiboInfo objectForKey:@"AccessTokenKey"];
    // 拼接 eg:https://open.weibo.cn/2/remind/unread_count.json?access_token=xxxxxxxx
    urlstring = [BASE_URL stringByAppendingFormat:@"%@?access_token=%@",urlstring,accessToken];
    
   
    
    // --------------------处理GET方法--------------------
       NSComparisonResult comparRetGET = [httpMethod caseInsensitiveCompare:@"GET"];
    if (comparRetGET == NSOrderedSame) {
        
        NSArray *allKeys = [params allKeys];
        NSMutableString *pamramsString = [NSMutableString string];
        
        // 拼接参数
        for (int i = 0; i<params.count; i++) {
            NSString *key = [allKeys objectAtIndex:i];
            id value = [params objectForKey:key];
            [pamramsString appendFormat:@"%@=%@",key,value ];
            
            if (i < params.count - 1) {
                [pamramsString appendFormat:@"&"];
            }
        }
        
        if (pamramsString.length > 0) {
            // eg:https://open.weibo.cn/2/remind/unread_count.json?access_token=xxxxxxxx &paramesString
            urlstring = [urlstring stringByAppendingFormat:@"&%@",pamramsString];
        }
    }
    
    
    // 创建request 对象
    NSURL *url = [NSURL URLWithString:urlstring];
    __block ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    // 设置请求超过时间
    [request setTimeOutSeconds:60];
    [request setRequestMethod:httpMethod];
    
    // 处理post请求的方式
    NSComparisonResult comparRetGet = [httpMethod caseInsensitiveCompare:@"POST"];
    if (comparRetGet == NSOrderedSame) {
        
        NSArray *allKeys = [params allKeys];
        for (int i = 0; i<params.count; i++) {
            NSString *key = [allKeys objectAtIndex:i];
            id value = [params objectForKey:key];
            
            if ([value isKindOfClass:[NSData class]]) {
                [request addData:value forKey:key];
            }else {
                [request addPostValue:value forKey:key];
            }
        }
    }
    // 设置请求完成的block
    [request setCompletionBlock:^{
        NSData *data = request.responseData;
        
        float version = WXHLOSVersion();
        id result = nil;
        if (version >= 5.0) {
            result = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        } else {
           result = [data objectFromJSONData];
        
        }
        
        if (block != nil ) {
            block(result);
        }
    }];
    
    [request startAsynchronous];// 异步请求
    return request;
}

@end
