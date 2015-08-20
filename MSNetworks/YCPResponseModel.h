//
//  PKResponseModel.h
//  PrivateKitchen
//
//  Created by magic on 15-1-24.
//  Copyright (c) 2015年 hw. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YCPNetworkingHeader.h"

@interface YCPResponseModel : NSObject

/**
 *  返回类型
 */
@property(nonatomic, assign) YCPResponseType responseType;

/**
 *  返回data数据(封装在data字典的数据)
 */
@property(nonatomic, strong) id responseData;

/**
 *  返回的原数据字符串
 */
@property (nonatomic, strong) NSString *responseRawString;

/**
 *  返回message
 */
@property(nonatomic, copy) NSString *responseMsg;

/**
 *  返回错误信息
 */
@property (nonatomic, strong) NSNumber *errorCode;

/**
 *  错误对象
 */
@property (nonatomic, strong) NSError *error;

@end
