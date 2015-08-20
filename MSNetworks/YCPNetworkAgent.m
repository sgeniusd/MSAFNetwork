//
//  PKNetworkAgent.m
//  PrivateKitchen
//
//  Created by magic on 15-1-22.
//  Copyright (c) 2015年 hw. All rights reserved.
//

#import "YCPNetworkAgent.h"
#import "AFHTTPRequestOperationManager.h"
#import "YCPResponseCache.h"

@implementation YCPNetworkAgent {
    AFHTTPRequestOperationManager   *_manager;
    NSMutableDictionary             *_cacheRequestRecord;       //请求对象缓存
}

+ (YCPNetworkAgent *)sharedInstance
{
    static id sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc]init];
    });
    return sharedInstance;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _manager = [AFHTTPRequestOperationManager manager];
        _cacheRequestRecord = [[NSMutableDictionary alloc]init];
    }
    return self;
}

#pragma mark -Public Function
- (void)addRequest:(YCPBaseRequest *)request
{    
    _manager.requestSerializer.timeoutInterval = [request timeoutInterval];
    
    NSString *requestURL = [self __constructRequestURL:request];
    
    NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
    
    id commnetArg = [request requestCommonArgument];
    id specificArg = [request requestArgument];
    if (commnetArg) {
        [param addEntriesFromDictionary:commnetArg];
    }
    if (specificArg) {
        [param addEntriesFromDictionary:specificArg];
    }
    if ([param count] == 0) {
        param = nil;
    }
    
    YCPRequestMethod method = request.requestMehtod;
    AFConstructingBlock constructingBlock = request.constructingBlock;
    
    __weak YCPNetworkAgent *networkAgent = self;
    request.requestOperation = [self __afRequest:requestURL
                                      parameters:param
                                          method:method
                       constructingBodyWithBlock:constructingBlock
                                         success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                             [networkAgent __handleResponse:operation success:YES];
                                         }
                                         failure:^(AFHTTPRequestOperation *operation, id responseObject) {
                                             [networkAgent __handleResponse:operation success:NO];
                                         }];
    request.requestOperation.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/html", @"text/plain", nil];
    _manager.requestSerializer.cachePolicy = NSURLRequestReloadIgnoringLocalCacheData;
    if (request.uploadProgressBlock) {
        [request.requestOperation setUploadProgressBlock:request.uploadProgressBlock];
    }
    if (request.downloadProgressBlock) {
        [request.requestOperation setDownloadProgressBlock:request.downloadProgressBlock];
    }
    [self __addCacheRequest:request];
    
#if DEBUGLOG
    /**
     *  日志打印
     */
    if (request.showRequestLog) {
        NSLog(@"\n\n\n\nrequestURL = %@%@\n\n\n\n",requestURL,[param queryString]);
        NSLog(@"requstURL = %@, param=%@", requestURL, param);
    }
#endif
}

/**
 *  取消某个请求
 */
- (void)cancelRequest:(YCPBaseRequest *)request
{
    [request.requestOperation cancel];
}

/**
 *  通过key取消对应请求
 */
- (void)cancelRequestWithKey:(NSString *)key
{
    YCPBaseRequest *request = _cacheRequestRecord[key];
    if (request) {
        [request cancelRequest];
    }
}

/**
 *  取消所有请求
 */
- (void)cancelAllRequest
{
    for (YCPBaseRequest *request in [_cacheRequestRecord allValues]) {
        if (request.batchCancelEnable) {
            [self cancelRequest:request];
        }
    }
}

/**
 *  获取网络状态
 */
- (AFNetworkReachabilityManager *)reachabilityManager
{
    return _manager.reachabilityManager;
}

#pragma mark -Private Function

/**
 *  拼接请求URL
 */
- (NSString *)__constructRequestURL:(YCPBaseRequest *)request
{
    return [[NSString alloc]initWithFormat:@"%@%@", [request serviceURL], [request relativeURL]];
}

/**
 *  封装内部AFNetwork的请求
 */
- (AFHTTPRequestOperation *)__afRequest:(NSString *)URLString
                             parameters:(id)param
                                 method:(YCPRequestMethod)method
              constructingBodyWithBlock:(void (^)(id <AFMultipartFormData> formData))cbBlock
                                success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                                failure:(void (^)(AFHTTPRequestOperation *operation, id responseObject))failure
{
    AFHTTPRequestOperation *requestOperation = nil;    
    if (method == kRequestMethod_Get) {
        requestOperation = [_manager GET:URLString parameters:param success:success failure:failure];
    } else {
        if (cbBlock) {
            requestOperation = [_manager POST:URLString parameters:param constructingBodyWithBlock:cbBlock success:success failure:failure];
        } else {
            requestOperation = [_manager POST:URLString parameters:param success:success failure:failure];
        }
    }
    return requestOperation;
}

/**
 *  处理请求结果
 */
- (void)__handleResponse:(AFHTTPRequestOperation *)operation success:(BOOL)bSuccess
{
    NSString *cacheKey = [self __hashKeyOfOperation:operation];
    YCPBaseRequest *request = _cacheRequestRecord[cacheKey];
    if (bSuccess) {
        if (request.successBlock) {
            request.successBlock(request);
        }
        
        if (request.delegate && [request.delegate respondsToSelector:@selector(requestFinished:)]) {
            [request.delegate requestFinished:request];
        }
    } else {
        request.error = operation.error;
        if (request.failureBlock) {
            request.failureBlock(request);
        }
        
        if (request.delegate && [request.delegate respondsToSelector:@selector(requestFailed:)]) {
            [request.delegate requestFailed:request];
        }
    }
    
    [request clearCompletionBlock];
    [self __removeCacheRequest:request];
}

#pragma mark -Request缓存相关

/**
 *  获取请求对象的Hash值(与PKBaseRequest的hashKey相同)
 */
- (NSString *)__hashKeyOfOperation:(AFHTTPRequestOperation *)operation
{
    return [[NSString alloc]initWithFormat:@"%lu", (unsigned long)[operation hash]];
}

- (void)__addCacheRequest:(YCPBaseRequest *)request
{
    if (request) {
        NSString *cacheKey = [self __hashKeyOfOperation:request.requestOperation];
        _cacheRequestRecord[cacheKey] = request;
    }
}

- (void)__removeCacheRequest:(YCPBaseRequest *)requset
{
    NSString *cacheKey = [self __hashKeyOfOperation:requset.requestOperation];
    [_cacheRequestRecord removeObjectForKey:cacheKey];
}

@end
