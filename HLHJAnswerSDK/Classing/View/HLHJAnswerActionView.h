//
//  HLHJAnswerActionView.h
//  HLHJAnswerSDK
//
//  Created by mac on 2018/8/21.
//  Copyright © 2018年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^LoignBlock)(NSInteger buttonType);

@interface HLHJAnswerActionView : UIView


@property (nonatomic, copy) LoignBlock  loignBlock;

///当前活动
@property (nonatomic, strong)  UIButton *currBtn;
///下期活动
@property (nonatomic, strong)  UIButton *nextBtn;
///可抽奖登录
@property (nonatomic, strong) UIButton  *loginLeftBtn;
///可抽奖登录
@property (nonatomic, strong) UIButton  *loginRightBtn;

///奖品图片
@property (nonatomic, strong) UIImageView  *prizesImgView;
///奖品名称
@property (nonatomic, strong) UILabel      *prizeslba;
///暂无计划
@property (nonatomic, strong) UILabel     * topLineLab;
///活动结束时间
@property (nonatomic, strong) UILabel  *end_timeLab;
@end
