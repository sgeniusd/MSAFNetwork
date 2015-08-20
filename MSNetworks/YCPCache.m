//
//  YCPCache.m
//  YCCarPartner
//
//  Created by bita on 15/6/4.
//  Copyright (c) 2015年 huipeng. All rights reserved.
//

#import "YCPCache.h"
#import "YCPNetworkingMacros.h"

@implementation YCPCache

#pragma mark - Getter Method

- (BOOL)expired
{
    NSTimeInterval timeInterval = [[NSDate date]timeIntervalSinceDate:self.lastUpdateDate];
    return (timeInterval > kResponseCacheExpiredInterval);
}

@end
