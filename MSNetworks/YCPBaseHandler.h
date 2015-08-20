//
//  YCPBaseHandler.h
//  PrivateKitchen
//
//  Created by magic on 14-11-21.
//  Copyright (c) 2014年 hw. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "YCPBaseRequest.h"
#import "YCPResponseModel.h"

@interface YCPBaseHandler : YCPBaseRequest

/**
 *  是否需要登录，默认为YES(登录,注册,请求验证码等接口不需要)
 */
@property (nonatomic, assign)BOOL      bNeedLogin;

/**
 *  是否是静默请求(不显示成功或者失败提示),默认为NO,此开关可以同时开关bShowSuccessNotice和bShowFailureNotice(无网络提示不受影响)
 */
@property (nonatomic, assign)BOOL      bSilentRquest;

/**
 *  是否显示系统默认的Loading,默认为YES
 */
@property (nonatomic, assign)BOOL      bShowLoadingNotice;

/**
 *  是否显示请求成功提示,默认为NO
 */
@property (nonatomic, assign)BOOL      bShowSuccessNotice;

/**
 *  是否显示请求失败提示,默认为YES
 */
@property (nonatomic, assign)BOOL      bShowFailureNotice;

/**
 *  是否是全局请求,否则会随着页面的Pop会cancel该请求，默认为NO
 */
@property (nonatomic, assign)BOOL      bGlobalRequest;

@property (nonatomic, strong) YCPResponseModel *responseModel;

/**
 *  用block时初始化方法
 */
+ (instancetype)baseHandler;
- (instancetype)initWithBaseHandler;

/**
 *  自定义初始化delegate方法
 */
+ (instancetype)requestWithDelegate:(id)delegate;
- (instancetype)initWithDelegate:(id)delegate;

/**
 *  开始发送请求(带成功，失败block)
 */
- (void)startRequestWithSuccess:(void (^)(YCPResponseModel *responseModel))success failure:(void (^)(YCPResponseModel *responseModel))failure;

@end
