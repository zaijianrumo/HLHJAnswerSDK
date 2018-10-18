//
//  HLHJActivityModel.m
//  HLHJAnswerSDK
//
//  Created by mac on 2018/8/22.
//  Copyright © 2018年 mac. All rights reserved.
//

#import "HLHJActivityModel.h"

@implementation HLHJActivityModel

+ (NSDictionary *)modelCustomPropertyMapper {
    
    return @{@"ID":@"id",@"des":@"description"};
}

@end
