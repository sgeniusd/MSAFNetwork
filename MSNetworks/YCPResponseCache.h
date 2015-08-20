//
//  YCPResponseCache.h
//  YCCarPartner
//
//  Created by bita on 15/6/4.
//  Copyright (c) 2015年 huipeng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YCPBaseRequest.h"

@interface YCPResponseCache : NSObject

+ (YCPResponseCache *)sharedResponseCache;

/**
 *  保存缓存的Response
 */
- (void)saveCachedResponseWithRequest:(YCPBaseRequest *)request;

/**
 *  取得缓存的Response
 */
- (id)cachedResponseForRequest:(YCPBaseRequest *)request;

@end