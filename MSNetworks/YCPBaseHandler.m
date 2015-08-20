//
//  YCPBaseHandler.m
//  PrivateKitchen
//
//  Created by magic on 14-11-21.
//  Copyright (c) 2014年 hw. All rights reserved.
//

#import "YCPBaseHandler.h"
#import "YCPResponseCache.h"

#import "YCPCommonParamGenerator.h"

@interface YCPBaseHandler ()

- (void)baseHandlerConfig;

@end

@implementation YCPBaseHandler

/**
 *  用block时初始化方法
 */
+ (instancetype)baseHandler {
    return [[[self class] alloc] initWithBaseHandler];
}

- (instancetype)initWithBaseHandler {
    self = [super init];
    if(self) {
        [self baseHandlerConfig];
    }
    return self;
}

+ (instancetype)requestWithDelegate:(id)delegate {
    return [[[self class] alloc] initWithDelegate:delegate];
}

- (instancetype)initWithDelegate:(id)delegate
{
    self = [super init];
    if (self) {
        self.delegate = delegate;
        _bShowSuccessNotice = YES;
        
        [self baseHandlerConfig];
    }
    return self;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self baseHandlerConfig];
    }
    return self;
}

- (void)baseHandlerConfig
{
    _bNeedLogin = YES;
    _bSilentRquest = NO;
    _bShowLoadingNotice = YES;
    _bShowSuccessNotice = NO;
    _bShowFailureNotice = YES;
    _bGlobalRequest = NO;
}

- (void)setBSilentRquest:(BOOL)bSilentRquest
{
    _bSilentRquest = bSilentRquest;
    
    _bShowLoadingNotice = !bSilentRquest;
    _bShowSuccessNotice = !bSilentRquest;
    _bShowFailureNotice = !bSilentRquest;
}

- (id)requestCommonArgument
{
    NSMutableDictionary *commontArguments = [NSMutableDictionary dictionary];
    if (self.bNeedLogin) {
        //登录需要添加的共通字段，加在这里
    }
    
    NSDictionary *parentArguments = [super requestCommonArgument];
    if (parentArguments) {
        [commontArguments addEntriesFromDictionary:parentArguments];
    }
    
    NSMutableDictionary *paramsExceptToken = [NSMutableDictionary dictionary];
    
    [paramsExceptToken addEntriesFromDictionary:commontArguments];
    [paramsExceptToken addEntriesFromDictionary:[self requestArgument]];
    
    NSString *token = [YCPCommonParamGenerator tokenWithDictionary:paramsExceptToken];

    [commontArguments setObj:token forKey:@"token"];
    
    return commontArguments;
}

/**
 *  开始发送请求(带成功，失败block)
 */
- (void)startRequestWithSuccess:(void (^)(YCPResponseModel *responseModel))success failure:(void (^)(YCPResponseModel *responseModel))failure
{
    id responseObj = [[YCPResponseCache sharedResponseCache] cachedResponseForRequest:self];
    if (responseObj) {
        YCPResponseModel *responseModel = [self responseModelWithResponseData:responseObj];
        success(responseModel);
    } else {
        WS(weakSelf);
        [super startRequestWithSuccess:^(YCPBaseRequest *request) {
            YCPBaseHandler *baseHandler = (YCPBaseHandler *)request;
            id responseObj = request.requestOperation.responseObject;
            
            YCPResponseModel *responseModel = [weakSelf responseModelWithResponseData:responseObj];
            if (weakSelf.responseCacheEnabled && weakSelf.successServerResponse) {
                //缓存Response
                [[YCPResponseCache sharedResponseCache] saveCachedResponseWithRequest:weakSelf];
            }
        
            responseModel.responseType = [weakSelf responseType:[responseObj integerForKey:kKey_ResponseErrorCode]];
            responseModel.responseRawString = request.requestOperation.responseString;
            responseModel.responseMsg = [responseObj stringForKey:kKey_ResponseErrorMsg];
            responseModel.error = request.requestOperation.error;
            baseHandler.responseModel = responseModel;
            
            if ([request isKindOfClass:[YCPBaseHandler class]]) {
                YCPBaseHandler *baseHandler = (YCPBaseHandler *)request;
                YCPResponseModel *responseModel = baseHandler.responseModel;
                
                if (weakSelf.successServerResponse && success) {
                    /**服务器返回成功提示*/
                    if (_bShowSuccessNotice && responseModel.responseMsg.length > 0) {
                        //                    [PKProgressHUD showLoadingWithTitle:responseModel.responseMsg delay:kToastDelayDefault];
                    }
                    
                    if (success) {
                        success(responseModel);
                    }
                }
                else {
                    /**服务器返回提示*/
                    if (_bShowFailureNotice
                        && responseModel.responseMsg.length > 0) {
                        //                    [PKProgressHUD showLoadingWithTitle:responseModel.responseMsg delay:kToastDelayDefault];
                    }
                    
                    if (failure) {
                        failure(responseModel);
                    }
                }
            }
        } failure:^(YCPBaseRequest *request) {
            /**
             *  请求错误提示(非服务器错误)
             */
            if (request.error.code != NSURLErrorCancelled/*主动取消cancel*/) {
                [weakSelf __showNetworkErrorMsg:request];
            }
            
            if (failure) {
                YCPBaseHandler *baseHandler = (YCPBaseHandler *)request;
                YCPResponseModel *responseModel = [[YCPResponseModel alloc] init];
                responseModel.error = request.requestOperation.error;
                responseModel.responseType = [weakSelf responseType:request.error.code];
                responseModel.responseRawString = request.requestOperation.responseString;
                baseHandler.responseModel = responseModel;
                
                failure(baseHandler.responseModel);
            }
        }];
    }
}

/**
 *  请求错误提示(非服务器错误)
 */
- (void)__showNetworkErrorMsg:(YCPBaseRequest *)request
{
//    NSString *errorMsg = @"请求失败!";
//    if (![PKNetworkAgent sharedInstance].reachabilityManager.reachable) {
//        errorMsg = NETWORK_UNAVAILIABLE_MESSAGE;
//    }
//    [PKProgressHUD showLoadingWithTitle:errorMsg delay:kToastDelayDefault];
}

- (YCPResponseModel *)responseModelWithResponseData:(id)responseObject
{
    YCPResponseModel *responseModel = [[YCPResponseModel alloc] init];
    if ([responseObject isKindOfClass:[NSDictionary class]] && responseObject[kKey_ResponseData]) {
        responseModel.responseData = responseObject[kKey_ResponseData];
    } else {
        responseModel.responseData = responseObject;
    }
    return responseModel;
}

/** error 0.正确   -1.一般错误   -2.session问题或者未登录 */
- (YCPResponseType)responseType:(NSInteger)errorCode {
    YCPResponseType responseType = kResponseType_UnKnownError;
    switch (errorCode) {
        case 0:
        {
            responseType = kResponseType_Success;
        }
            break;
        case -1:
        {
            responseType = kResponseType_Failed;
        }
            break;
        case -2:
        {
            responseType = kResponseType_SessionError;
        }
            break;
        case -1004:
        {
            responseType = kResponseType_CannotConnectToHost;
        }
            break;
        case -1001:
        {
            responseType = kResponseType_TimedOut;
        }
            break;
        default:
            break;
    }
    
    return responseType;
}

@end
