//
//  PKBaseRequest.m
//  PrivateKitchen
//
//  Created by magic on 15-1-22.
//  Copyright (c) 2015年 hw. All rights reserved.
//

#import "YCPBaseRequest.h"
#import "YCPNetworkAgent.h"
#import "YCPCommonParamGenerator.h"

@implementation YCPBaseRequest

- (instancetype)init
{
    self = [super init];
    if (self) {
        _responseCacheEnabled = NO;
        _batchCancelEnable = YES;
        
        #if DEBUG
        _showRequestLog = YES;
        #endif
    }
    return self;
}

#pragma mark - Getter Method

- (NSString *)hashKey
{
    if (_hashKey == nil && _requestOperation) {
        _hashKey = [[NSString alloc]initWithFormat:@"%lu", (unsigned long)[_requestOperation hash]];
    }
    return _hashKey;
}

/**
 *  开始发送请求
 */
- (void)startRequest
{
    [self startRequestWithSuccess:nil failure:nil];
}

/**
 *  开始发送请求(带成功，失败block)
 */
- (void)startRequestWithSuccess:(void (^)(YCPBaseRequest *request))success failure:(void (^)(YCPBaseRequest *request))failure
{
    if (_delegate && [_delegate respondsToSelector:@selector(requestWillStart:)]) {
        [_delegate requestWillStart:self];
    }
    
    self.successBlock = success;
    self.failureBlock = failure;
    [[YCPNetworkAgent sharedInstance]addRequest:self];
    
    if (_delegate && [_delegate respondsToSelector:@selector(requestDidStart:)]) {
        [_delegate requestDidStart:self];
    }
}

/**
 *  取消发送请求
 */
- (void)cancelRequest
{
    _delegate = nil;
    self.successBlock = nil;
    self.failureBlock = nil;
    [[YCPNetworkAgent sharedInstance] cancelRequest:self];
}

/**
 *  把block设为nil
 */
- (void)clearCompletionBlock
{
    _delegate = nil;
    self.successBlock = nil;
    self.failureBlock = nil;
}

#pragma mark - Setter Method

- (void)setUploadProgressBlock:(AFProgressBlock)uploadProgressBlock
{
    if (_uploadProgressBlock != uploadProgressBlock) {
        _uploadProgressBlock = uploadProgressBlock;
        
        if (_uploadProgressBlock && self.requestOperation) {
            [self.requestOperation setUploadProgressBlock:_uploadProgressBlock];
        }
    }
}

- (void)setDownloadProgressBlock:(AFProgressBlock)downloadProgressBlock
{
    if (_downloadProgressBlock != downloadProgressBlock) {
        _downloadProgressBlock = downloadProgressBlock;
        
        if (_downloadProgressBlock && self.requestOperation) {
            [self.requestOperation setDownloadProgressBlock:_downloadProgressBlock];
        }
    }
}

#pragma mark - Getter Method

/**
 *  根据返回的json结构体的相应字段判断是否请求成功
 */
//@property (nonatomic, assign) BOOL      successServerResponse
- (BOOL)successServerResponse
{
    BOOL success = NO;
    
    NSDictionary *responseData = (NSDictionary *)self.requestOperation.responseObject;
    //status 1.正确, 0.错误
    if (responseData && [responseData[kKey_ResponseSuccessFlag] boolValue]) {
        success = YES;
    }
    return success;
}

/**
 *  Service URL
 */
- (NSString *)serviceURL
{
    return kRequestServer;
}

/**
 *  请求的相对URL
 */
- (NSString *)relativeURL
{
    return @"";
}

/**
 *  请求方式
 */
- (YCPRequestMethod)requestMehtod
{
    return kRequestMethod_Post;
}

/**
 *  请求的连接超时时间
 */
- (NSTimeInterval)timeoutInterval
{
    return kNetworkTimeoutInterval;
}

/**
 *  通用请求参数
 */
- (id)requestCommonArgument
{
    if (_requestCommonArgument == nil) {
        NSMutableDictionary *commonParams = [NSMutableDictionary dictionary];
        
        [commonParams setObj:kRequestAppId forKey:@"appid"];
        [commonParams setObj:kRequestAppKey forKey:@"appkey"];
        [commonParams setObj:[YCPCommonParamGenerator deviceId] forKey:@"deviceid"];
        [commonParams setObj:@(1) forKey:@"devtype"]; //1:iOS 2:Android
        [commonParams setObj:@((int64_t)[[NSDate date]timeIntervalSince1970]) forKey:@"timestamp"];
        _requestCommonArgument = commonParams;
    }
    return _requestCommonArgument;
}

/**
 *  请求参数
 */
- (NSDictionary *)requestArgument
{
    return _requestArgument;
}

- (NSDictionary *)requestCommontArgumentExceptTime
{
    NSMutableDictionary *reqArgumentExceptTime = nil;
    if ([self requestCommonArgument]) {
        reqArgumentExceptTime = [NSMutableDictionary dictionary];
        [reqArgumentExceptTime setDictionary:[self requestCommonArgument]];
        if (reqArgumentExceptTime[@"timestamp"]) {
            [reqArgumentExceptTime removeObjectForKey:@"timestamp"];
        }
        if (reqArgumentExceptTime[@"token"]) {
            [reqArgumentExceptTime removeObjectForKey:@"token"];
        }
    }
    return reqArgumentExceptTime;
}

@end
