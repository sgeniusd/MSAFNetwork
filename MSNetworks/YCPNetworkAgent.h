//
//  PKNetworkAgent.h
//  YCCarPartner
//
//  AFNetwork请求(YCPBaseRequest)的操作类
//
//  Created by magic on 15-1-22.
//  Copyright (c) 2015年 hw. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YCPBaseRequest.h"

@interface YCPNetworkAgent : NSObject

+ (YCPNetworkAgent *)sharedInstance;

- (void)addRequest:(YCPBaseRequest *)request;

- (void)cancelRequest:(YCPBaseRequest *)request;

- (void)cancelRequestWithKey:(NSString *)key;

- (void)cancelAllRequest;

/**
 *  获取网络状态
 */
- (AFNetworkReachabilityManager *)reachabilityManager;

@end
