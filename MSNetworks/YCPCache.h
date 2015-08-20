//
//  YCPCache.h
//  YCCarPartner
//
//  Created by bita on 15/6/4.
//  Copyright (c) 2015年 huipeng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YCPCache : NSObject

@property (nonatomic, strong) id content;

@property (nonatomic, strong) NSDate *lastUpdateDate;

@property (nonatomic, assign) BOOL expired;     //缓存是否过期

@end
