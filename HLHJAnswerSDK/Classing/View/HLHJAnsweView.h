//
//  HLHJAnsweView.h
//  HLHJAnswerSDK
//
//  Created by mac on 2018/8/21.
//  Copyright © 2018年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>
@class HLHJQuestionsModel;

@interface HLHJAnsweView : UIView

@property (nonatomic, strong) HLHJQuestionsModel  *model;

- (instancetype)initWithFrame:(CGRect)frame questions:(NSArray *)questions;

- (void)showView;

-(void)dismissAlertView;

@end
