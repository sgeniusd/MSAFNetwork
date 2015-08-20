//
//  YCPTokenGenerator.m
//  YCCarPartner
//
//  Created by bita on 15/6/16.
//  Copyright (c) 2015年 huipeng. All rights reserved.
//

#import "YCPCommonParamGenerator.h"
#import "YCPNetworkingHeader.h"
#import "NSString+Hash.h"
#import "SFHFKeychainUtils.h"

NSString const * kDeviceModelServiceName = @"bitautoDevice";
NSString const * kDeviceIdKey = @"deviceId";

@implementation YCPCommonParamGenerator

+ (NSString *)tokenWithDictionary:(NSDictionary *)paramDic {
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"self" ascending:YES];
    NSArray *sortedKeys = [[paramDic allKeys] sortedArrayUsingDescriptors:@[sortDescriptor]];
    NSMutableString *keyValueChain = [[NSMutableString alloc] init];
    
    NSArray *ignoredPropertyNames = [self ignoredPropertyNames];
    
    for (NSString *key in sortedKeys) {
        if (ignoredPropertyNames == nil || ![ignoredPropertyNames containsObject:key]) {
            id value = paramDic[key];
            if ([value isKindOfClass:[NSNumber class]]) {
                value = [((NSNumber *)value) stringValue];
            }
            [keyValueChain appendFormat:@"%@%@",key,value];
        }
    }
    [keyValueChain appendString:kRequestAppKey];
    return [keyValueChain md5String];
}

/**
 * 取idfv值的md5. 生成的deviceid 存贮到keychain中，同个开发商下面的app
 * 共享设备Id
 */
+ (NSString *)deviceId {
    
    NSString *deviceIdStr = [SFHFKeychainUtils getPasswordForUsername:(NSString*)kDeviceIdKey
                                                       andServiceName:(NSString*)kDeviceModelServiceName
                                                                error:nil];
    if (!deviceIdStr.length) {
        deviceIdStr = [[[[UIDevice currentDevice] identifierForVendor] UUIDString] md5String];
        [SFHFKeychainUtils storeUsername:(NSString*)kDeviceIdKey
                             andPassword:deviceIdStr
                          forServiceName:(NSString*)kDeviceModelServiceName
                          updateExisting:YES
                                   error:nil];
    }
    return deviceIdStr;
}

/**
 *  忽略的字段
 */
+ (NSArray *)ignoredPropertyNames {
    return @[@"ignoredProperty"];
}

@end
