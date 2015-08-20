//
//  YCPTestHandler.m
//  MSAFNetwork
//
//  Created by bita on 15/8/19.
//  Copyright © 2015年 MagicSong. All rights reserved.
//

#import "YCPTestHandler.h"

@implementation YCPTestHandler

- (instancetype)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

/**
 *  域名，可以自定义，默认通过宏统一设置
 */
- (NSString *)serviceURL
{
    return @"http://www.baidu.com";
}

/**
 *  服务端相对路径，根据请求不同做自定义设置
 */
- (NSString *)relativeURL
{
    return @"";
}

@end
