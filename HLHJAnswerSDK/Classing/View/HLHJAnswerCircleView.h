//
//  HLHJAnswerCircleView.h
//  HLHJAnswerSDK
//
//  Created by mac on 2018/8/21.
//  Copyright © 2018年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HLHJAnswerCircleView : UIView

@property (nonatomic,strong) CAShapeLayer *backgroundLine;

@property (nonatomic,strong) CAShapeLayer *mainLine;

@property (nonatomic,assign) CGFloat strokelineWidth;

@property (nonatomic,strong) UILabel *numbLb;

- (void)circleWithProgress:(NSInteger)progress andIsAnimate:(BOOL)animate;

@end
