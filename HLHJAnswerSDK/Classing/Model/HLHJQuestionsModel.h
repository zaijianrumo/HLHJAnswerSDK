//
//  HLHJQuestionsModel.h
//  HLHJAnswerSDK
//
//  Created by mac on 2018/8/23.
//  Copyright © 2018年 mac. All rights reserved.
//

#import <Foundation/Foundation.h>


@class  QuestionsModel;

@interface HLHJQuestionsModel : NSObject

@property (nonatomic, copy) NSString  *ID;

@property (nonatomic, copy) NSString  *title;

@property (nonatomic, copy) NSString  *start_time;

@property (nonatomic, copy) NSString  *end_time;

@property (nonatomic, copy) NSString  *object;

@property (nonatomic, copy) NSString  *rule;

@property (nonatomic, copy) NSString  *question_points;

@property (nonatomic, copy) NSString  *created_time;

//1 当前用户已经打过题了，否则没有打过
@property (nonatomic, assign) NSInteger  has_answered;

@property (nonatomic, assign) CGFloat  pass_score;

@property (nonatomic, assign) NSInteger  draw_times;

@property (nonatomic, strong)NSArray<QuestionsModel *>  *questions;

@end


@interface QuestionsModel : NSObject

@property (nonatomic, copy) NSString  *ID;

@property (nonatomic, copy) NSString  *activity_id;

@property (nonatomic, copy) NSString  *stem;
// //正确选项  0-A, 1-B, 2-C, 3-D
@property (nonatomic, assign) NSInteger  correct_option;

@property (nonatomic, copy) NSString  *created_time;

@property (nonatomic, strong) NSArray  *options;

@end
