//
//  HLHJSuccessfullyView.h
//  HLHJAnswerSDK
//
//  Created by mac on 2018/8/23.
//  Copyright © 2018年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>


@class HLHJQuestionsModel;

@interface HLHJSuccessfullyView : UIView

- (instancetype)initWithFrame:(CGRect)frame hlhjQuestionsModel:(HLHJQuestionsModel *)model allIntegral:(CGFloat)Integral;

- (void)showView;

-(void)dismissAlertView;

@end
