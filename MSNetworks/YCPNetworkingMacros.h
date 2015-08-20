//
//  YCPNetworkingMacros.h
//  YCCarPartner
//
//  网络宏定义
//
//  Created by bita on 15/5/28.
//  Copyright (c) 2015年 huipeng. All rights reserved.
//

#ifndef YCCarPartner_YCPNetworkingMacros_h
#define YCCarPartner_YCPNetworkingMacros_h

/**
 *  网络请求超时时长
 */
#define kNetworkTimeoutInterval     30.0f

/**
 *  response缓存时长
 */
static const NSTimeInterval kResponseCacheExpiredInterval = 180.0f;

/**
 *  公共请求头
 */
#define kPublicRequestHeader      @{\
}

//appid
#define kRequestAppId           @""

//appkey
#define kRequestAppKey          @""

/**
 *  服务器地址
 */
#define kRequestServer             @"http://www.baidu.com"           //测试地址

/**
 *  回包的Key
 */
#define kKey_ResponseSuccessFlag    @"status"              //返回成功标识的Key
#define kKey_ResponseData           @"data"                //返回data的Key
#define kKey_ResponseErrorMsg       @"message"             //返回失败消息的Key
#define kKey_ResponseErrorCode      @"error"               //返回错误码的Key

#define kResponse_PageSize          20                     //每页的Size

typedef NS_ENUM(NSInteger, YCPRequestMethod) {
    kRequestMethod_Get,
    kRequestMethod_Post
};

/**
 *  返回类型，目前仅有成功和失败(暂没有具体的失败类型)
 */
typedef NS_ENUM(NSInteger, YCPResponseType) {
    kResponseType_UnKnownError,               //未知
    kResponseType_Success,                    //正确
    kResponseType_Failed,                     //一般错误
    kResponseType_SessionError,               //session问题或者未登录
    kResponseType_CannotConnectToHost,        //网络连接错误
    kResponseType_TimedOut,                   //连接超时
};

#endif
