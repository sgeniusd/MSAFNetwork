//
//  PKBaseRequest.h
//  PrivateKitchen
//
//  Created by magic on 15-1-22.
//  Copyright (c) 2015年 hw. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFHTTPRequestOperation.h"
#import "YCPNetworkingHeader.h"
#import "NSDictionary+SafeAccess.h"

typedef void(^AFConstructingBlock)(id<AFMultipartFormData> formdata);
typedef void(^AFProgressBlock)(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite);

@class YCPBaseRequest;

@protocol PKRequestDelegate <NSObject>

@optional

- (void)requestDidStart:(YCPBaseRequest *)request;
- (void)requestWillStart:(YCPBaseRequest *)request;
- (void)requestFinished:(YCPBaseRequest *)request;
- (void)requestFailed:(YCPBaseRequest *)request;

@end

@interface YCPBaseRequest : NSObject

/**
 *  是否加密
 */
@property (nonatomic, assign)BOOL      encryptEnabled;

/**
 *  是否支持URLReponse缓存，默认为NO
 */
@property (nonatomic, assign) BOOL      responseCacheEnabled;

/**
 *  根据返回的json结构体的相应字段判断是否请求成功
 */
@property (nonatomic, assign) BOOL      successServerResponse;

/**
 *  是否显示请求URL（DEBUG模式为YES）
 */
@property (nonatomic, assign) BOOL      showRequestLog;

/**
 *  是否受批量取消请求影响，默认为YES
 */
@property (nonatomic, assign) BOOL      batchCancelEnable;

/**
 *  请求附加字段
 */
@property (nonatomic, strong) NSDictionary *requestCommonArgument;

/**
 *  请求附加字段
 */
@property (nonatomic, strong) NSDictionary *requestArgument;

@property (nonatomic, weak)id<PKRequestDelegate> delegate;
@property (nonatomic, strong)AFHTTPRequestOperation *requestOperation;
@property (nonatomic, copy) AFConstructingBlock constructingBlock;      //表单上传Block
@property (nonatomic, copy) AFProgressBlock uploadProgressBlock;        //上传进度Block
@property (nonatomic, copy) AFProgressBlock downloadProgressBlock;      //下载进度Block
@property (nonatomic, copy) void(^successBlock)(YCPBaseRequest *request);
@property (nonatomic, copy) void(^failureBlock)(YCPBaseRequest *request);

@property (nonatomic, strong) NSError       *error;

/**
 *  Opeartion哈希值作为Key
 */
@property (nonatomic, copy) NSString    *hashKey;

/**
 *  开始发送请求
 */
- (void)startRequest;

/**
 *  开始发送请求(带成功，失败block)
 */
- (void)startRequestWithSuccess:(void (^)(YCPBaseRequest *request))success failure:(void (^)(YCPBaseRequest *request))failure;

/**
 *  开始发送请求
 */
- (void)cancelRequest;

/**
 *  把block设为nil
 */
- (void)clearCompletionBlock;

/**
 *  Service URL
 */
- (NSString *)serviceURL;

/**
 *  请求的相对URL
 */
- (NSString *)relativeURL;

/**
 *  请求方式
 */
- (YCPRequestMethod)requestMehtod;

/**
 *  请求的连接超时时间
 */
- (NSTimeInterval)timeoutInterval;

/**
 *  通用请求参数
 */
- (id)requestCommonArgument;

/**
 *  请求参数
 */
- (NSDictionary *)requestArgument;

/**
 *  请求参数（去掉请求时间参数）
 */
- (NSDictionary *)requestCommontArgumentExceptTime;

@end
