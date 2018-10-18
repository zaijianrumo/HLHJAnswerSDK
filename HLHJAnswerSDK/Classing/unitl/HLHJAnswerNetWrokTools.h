//
//  HLHJAnswerNetWrokTools.h
//  HLHJAnswerSDK
//
//  Created by mac on 2018/8/21.
//  Copyright © 2018年 mac. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, requestType) {
    GET = 1,
    POST = 2,
};
@interface HLHJAnswerNetWrokTools : NSObject

+ (AFHTTPSessionManager *_Nonnull)shareInstance;

+ (void)requestWithType:(requestType )type
             requestUrl:(NSString *_Nonnull)url
              parameter:(NSDictionary *_Nullable)parameter
        successComplete:(void(^_Nullable)(id _Nullable responseObject))success
        failureComplete:(void(^_Nonnull)(NSError * _Nonnull error))failure;


@end
