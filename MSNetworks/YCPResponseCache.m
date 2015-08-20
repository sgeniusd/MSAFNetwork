//
//  YCPResponseCache.m
//  YCCarPartner
//
//  Created by bita on 15/6/4.
//  Copyright (c) 2015年 huipeng. All rights reserved.
//

#import "YCPResponseCache.h"
#import "YCPCache.h"

@interface YCPResponseCache ()

@property (nonatomic, strong) NSCache   *cache;

- (NSString *)keyForRequest:(YCPBaseRequest *)request;

- (id)responseForRequest:(YCPBaseRequest *)request;

@end

@implementation YCPResponseCache

+ (YCPResponseCache *)sharedResponseCache
{
    static YCPResponseCache *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc]init];
    });
    return sharedInstance;
}

#pragma mark - getter Method

- (NSCache *)cache
{
    if (_cache == nil) {
        _cache = [[NSCache alloc]init];
    }
    return _cache;
}

#pragma mark - Private Method

- (NSString *)keyForRequest:(YCPBaseRequest *)request
{
    NSString *reuqestURL = [[NSString alloc]initWithFormat:@"%@%@", [request serviceURL], [request relativeURL]];
    
    NSMutableDictionary *param = [[NSMutableDictionary alloc]init];
    id commnetArg = [request requestCommontArgumentExceptTime];
    id specificArg = [request requestArgument];
    if (commnetArg) {
        [param addEntriesFromDictionary:commnetArg];
    }
    if (specificArg) {
        [param addEntriesFromDictionary:specificArg];
    }
    if ([param count] == 0) {
        param = nil;
    }
    
    if (param) {
        NSMutableArray *mutablePairs = [NSMutableArray array];
        
        for (NSString *paramKey in [param allKeys]) {
            [mutablePairs addObject:[[NSString alloc]initWithFormat:@"%@=%@",paramKey,param[paramKey]]];
        }
        NSString *paramString = [mutablePairs componentsJoinedByString:@"&"];
        if (paramString.length > 0) {
            if (request.requestMehtod == kRequestMethod_Get) {
                //get请求，加问号
                reuqestURL = [reuqestURL stringByAppendingFormat:@"?%@", paramString];
            } else {
                //post请求，不加
                reuqestURL = [reuqestURL stringByAppendingString:paramString];
            }
        }
    }
    return reuqestURL;
}

- (id)responseForRequest:(YCPBaseRequest *)request
{
    return request.requestOperation.responseObject;
}

/**
 *  保存缓存的Response
 */
- (void)saveCachedResponseWithRequest:(YCPBaseRequest *)request
{
    id response = [self responseForRequest:request];
    NSString *key = [self keyForRequest:request];
    if (request.successServerResponse && response) {
        YCPCache *cache = [[YCPCache alloc]init];
        cache.content = response;
        cache.lastUpdateDate = [NSDate date];
        [self.cache setObject:cache forKey:key];
    }
}

/**
 *  取得缓存的Response
 */
- (id)cachedResponseForRequest:(YCPBaseRequest *)request
{
    YCPCache *cache = [self.cache objectForKey:[self keyForRequest:request]];
    if (cache.expired) {
        cache = nil;
    }
    return cache.content;
}

@end
