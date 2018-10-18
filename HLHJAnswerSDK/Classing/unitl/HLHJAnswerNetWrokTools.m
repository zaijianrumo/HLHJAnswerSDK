//
//  HLHJAnswerNetWrokTools.m
//  HLHJAnswerSDK
//
//  Created by mac on 2018/8/21.
//  Copyright © 2018年 mac. All rights reserved.
//

#import "HLHJAnswerNetWrokTools.h"
#import "HLHJAnswerToast.h"
#import "SVProgressHUD.h"
#import "HLHJAnswerLoginView.h"
static AFHTTPSessionManager *_manager;
@implementation HLHJAnswerNetWrokTools
+ (AFHTTPSessionManager *)shareInstance {
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _manager = [AFHTTPSessionManager manager];
    });
    return _manager;
}
+ (AFHTTPSessionManager *)sharedManager {
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        _manager = [AFHTTPSessionManager manager];
        _manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript" , @"text/plain" ,@"text/html",@"application/xml",@"image/jpeg",nil];
        [_manager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
        _manager.requestSerializer.timeoutInterval = 30.0f;
        [_manager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
        _manager.requestSerializer.HTTPShouldHandleCookies = YES;
        //***************** HTTPS 设置 *****************************//
        // 设置非校验证书模式
        _manager.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
        // 客户端是否信任非法证书
        _manager.securityPolicy.allowInvalidCertificates = YES;
        // 是否在证书域字段中验证域名
        _manager.securityPolicy.validatesDomainName = NO;
        
 
        
//        [_manager.requestSerializer setValue:[[NSUserDefaults standardUserDefaults]objectForKey:@"mUserDefaultsCookie"]forHTTPHeaderField:@"Cookie"];

        
    });
    return _manager;
}

/**
 普通请求
 
 @param type 请求类型
 @param url 请求链接
 @param parameter 请求参数
 @param success 成功回调
 @param failure 失败回调
 */
+ (void)requestWithType:(requestType)type
             requestUrl:(NSString *_Nonnull)url
              parameter:(NSDictionary *_Nullable)parameter
        successComplete:(void(^_Nullable)(id _Nullable responseObject))success
        failureComplete:(void(^_Nonnull)(NSError * _Nonnull error))failure {
    
    
    url = [NSString stringWithFormat:@"%@%@",BASE_URL,url];
    
    _manager = [self sharedManager];
    ///获取当前用户信息 在用户登录的情况下去获取
    NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:@"token"];
    [_manager.requestSerializer setValue:token ? token:@"" forHTTPHeaderField:@"token"];
    
    if (type == 1) { // GET 请求
        [_manager GET:url parameters:parameter progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject){
            [SVProgressHUD dismiss];
             !success ? : success(responseObject);
             NSInteger codeState = [responseObject[@"code"] integerValue];
             if (codeState == 500) {
                 HLHJAnswerLoginView *loginView = [[HLHJAnswerLoginView alloc]initWithFrame:CGRectZero];
                 [loginView showView];
             }
            
//            NSDictionary *fields = ((NSHTTPURLResponse*)task.response).allHeaderFields;
//            NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/hlhj_prizeanswer/api/activityDetail",BASE_URL]];
//            //获取cookie方法1
//            NSArray *cookies = [NSHTTPCookie cookiesWithResponseHeaderFields:fields forURL:url];
//            NSDictionary *Request = [NSHTTPCookie requestHeaderFieldsWithCookies:cookies];
//            NSUserDefaults *userCookies = [NSUserDefaults standardUserDefaults];
//            [userCookies setObject:[Request objectForKey:@"Cookie"] forKey:@"mUserDefaultsCookie"];
//            [userCookies synchronize];
            
  
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error){
            [SVProgressHUD dismiss];
            if (error.code == NSURLErrorCancelled)  return ;
            NSLog(@"%@",error);
            !failure ? : failure(error);
        }];
    }else if (type == 2){ // POST 请求
        
        [_manager POST:url parameters:parameter progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject){
            [SVProgressHUD dismiss];
            
                !success ? : success(responseObject);
                NSInteger codeState = [responseObject[@"code"] integerValue];
                if (codeState == 500) {
                    HLHJAnswerLoginView *loginView = [[HLHJAnswerLoginView alloc]initWithFrame:CGRectZero];
                    [loginView showView];
                }
   
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error){
            [SVProgressHUD dismiss];
            if (error.code == NSURLErrorCancelled)  return ;
            NSLog(@"%@",error);
            !failure ? : failure(error);
        }];
    }else {
        NSLog(@"未选择请求类型");
        return;
    }
    
}
@end
