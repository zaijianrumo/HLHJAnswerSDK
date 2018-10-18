//
//  HLHJQuestionsModel.m
//  HLHJAnswerSDK
//
//  Created by mac on 2018/8/23.
//  Copyright © 2018年 mac. All rights reserved.
//

#import "HLHJQuestionsModel.h"

@implementation HLHJQuestionsModel

+ (NSDictionary *)modelCustomPropertyMapper {
    
    return @{@"ID":@"id"};
}

+ (NSDictionary *)modelContainerPropertyGenericClass {
    
    return @{@"questions":[QuestionsModel class]};
}
@end

@implementation QuestionsModel

+ (NSDictionary *)modelCustomPropertyMapper {
    
    return @{@"ID":@"id"};
}

@end
