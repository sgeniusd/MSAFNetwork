//
//  YCPCommonParamGenerator.h
//  YCCarPartner
//
//  Created by bita on 15/6/16.
//  Copyright (c) 2015年 huipeng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YCPCommonParamGenerator : NSObject

/**
 *  根据请求参数以及appKey生成的token
 *
 *  步骤：
 *  第一步：把所有参数按key升序排序。（除去token）
 *  第二步：把排序后的key和它对应的value拼接成一个字符串。
 *  第三步：把分配的appkey拼接到第二部的字符串后面。
 *  第四步：计算出第三步的md5值。
 */
+ (NSString *)tokenWithDictionary:(NSDictionary *)paramDic;

/**
 * 取idfv值的md5. 生成的deviceid 存贮到keychain中，同个开发商下面的app
 * 共享设备Id（与易车app共用一个）
 */
+ (NSString *)deviceId;

@end
