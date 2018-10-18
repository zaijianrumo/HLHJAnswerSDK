//
//  HLHJSuccessfullyView.m
//  HLHJAnswerSDK
//
//  Created by mac on 2018/8/23.
//  Copyright © 2018年 mac. All rights reserved.
//

#import "HLHJSuccessfullyView.h"
#import "HLHJQuestionsModel.h"
@interface HLHJSuccessfullyView()

@property (nonatomic, strong) UIView  *alertView;

@property (nonatomic, assign) CGFloat  integral;

@property (nonatomic, strong) HLHJQuestionsModel  *model;
@end


@implementation HLHJSuccessfullyView

- (instancetype)initWithFrame:(CGRect)frame hlhjQuestionsModel:(HLHJQuestionsModel *)model allIntegral:(CGFloat)Integral {
    
    if (self == [super initWithFrame:frame]) {
        
        self.integral = Integral;
        self.model = model;
        
        self.frame = [UIScreen mainScreen].bounds;
        self.userInteractionEnabled = YES;
        UITapGestureRecognizer *tapClick = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dismissAlertView)];
        
        [self addGestureRecognizer:tapClick];
        self.alertView.frame = CGRectZero;
        [self addSubview:self.alertView];
        
        
        UIImageView *logo = [[UIImageView alloc]init];
        if (Integral >= model.pass_score) {
             logo.image = [UIImage imageNamed:@"HLHJAnswerResouce.bundle/ic_dt_jiangbei"];
        }else {
             logo.image = [UIImage imageNamed:@"HLHJAnswerResouce.bundle/ic_dt_shibai"];
        }
        [self.alertView addSubview:logo];
        [logo mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.alertView).mas_offset(5);
            make.centerX.equalTo(self.alertView);
            make.width.mas_equalTo(230);
            make.height.mas_equalTo(192);
        }];
        
        
        ///闯关成功
        UILabel *fullylabel = [[UILabel alloc] init];
        if (Integral >= model.pass_score) {
              fullylabel.text = @"闯关成功";
        }else {
              fullylabel.text = @"闯关失败";
        }
        
        fullylabel.font = [UIFont boldSystemFontOfSize:25];
        fullylabel.textColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1];
        [self.alertView addSubview:fullylabel];
        [fullylabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.alertView);
            make.top.equalTo(logo.mas_bottom).mas_offset(20);
        }];
        
//        ///共计答题 10 道 累计分数：90 分
        UILabel *contentLabel = [[UILabel alloc] init];
        if (Integral >= model.pass_score) {
             contentLabel.text = [NSString stringWithFormat:@"共计答题 %ld 道 累计分数：%.lf 分 \n\n 恭喜获得 %ld 次抽奖机会",model.questions.count,Integral,model.draw_times];
        }else {
              contentLabel.text = [NSString stringWithFormat:@"共计答题 %ld 道 累计分数：%.lf 分 \n\n 闯关未成功,请下次再试",model.questions.count,Integral];
        }
        contentLabel.font = [UIFont systemFontOfSize:15];
        contentLabel.numberOfLines = 0;
        contentLabel.textAlignment = NSTextAlignmentCenter;
        contentLabel.textColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1];
        [self.alertView addSubview:contentLabel];
        
        [contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.alertView);
            make.top.equalTo(fullylabel.mas_bottom).mas_offset(20);
        }];
        
        
        ///立即抽奖
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        if (Integral >= model.pass_score) {
            [btn setTitle:@"立即抽奖" forState:UIControlStateNormal];
        }else {
            [btn setTitle:@"下次再来" forState:UIControlStateNormal];
           
        }
        [btn addTarget:self action:@selector(dismissAlertView) forControlEvents:UIControlEventTouchUpInside];
        [btn setBackgroundImage:[UIImage imageNamed:@"HLHJAnswerResouce.bundle/btn_ljcj"] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
 
        btn.titleLabel.font = [UIFont systemFontOfSize:15];
        [self.alertView addSubview:btn];
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.alertView).mas_offset(38);
            make.right.equalTo(self.alertView).mas_offset(-38);
            make.bottom.equalTo(self.alertView).mas_offset(-21);
            make.height.mas_equalTo(50);
        }];
        
        ///关闭按钮
        UIButton *closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [closeBtn setImage:[UIImage imageNamed:@"HLHJAnswerResouce.bundle/ic_dt_close"] forState:UIControlStateNormal];
        [closeBtn addTarget:self action:@selector(dismissAlertView) forControlEvents:UIControlEventTouchUpInside];
        [self.alertView addSubview:closeBtn];
        [closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.alertView).mas_offset(5);
            make.right.equalTo(self.alertView).mas_offset(-5);
            make.width.height.mas_equalTo(23);
        }];
        
        
    }
    return self;
}
- (void)showView {
    
    
    self.alertView.alpha = 1;
    
    self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:.3f];
    
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    
    self.alertView.frame = CGRectMake(15,([UIScreen mainScreen].bounds.size.height -420)/2, ([UIScreen mainScreen].bounds.size.width-30),420);
    
    // 第一步：将view宽高缩至无限小（点）
    self.alertView.transform = CGAffineTransformScale(CGAffineTransformIdentity,
                                                      CGFLOAT_MIN, CGFLOAT_MIN);
    [UIView animateWithDuration:.2
                     animations:^{
                         // 第二步： 以动画的形式将view慢慢放大至原始大小的1.2倍
                         self.alertView.transform =
                         CGAffineTransformScale(CGAffineTransformIdentity, 1.0, 1.0);
                     }
                     completion:^(BOOL finished) {
                         [UIView animateWithDuration:0.2
                                          animations:^{
                                              // 第三步： 以动画的形式将view恢复至原始大小
                                              self.alertView.transform = CGAffineTransformIdentity;
                                          }];
                     }];
}

-(void)dismissAlertView {
    
    [UIView animateWithDuration:0.2
                     animations:^{
                         // 第一步： 以动画的形式将view慢慢放大至原始大小的1.2倍
                         self.alertView.transform =
                         CGAffineTransformScale(CGAffineTransformIdentity, 1.0, 1.0);
                     }
                     completion:^(BOOL finished) {
                         [UIView animateWithDuration:0.3
                                          animations:^{
                                              // 第二步： 以动画的形式将view缩小至原来的1/1000分之1倍
                                              self.alertView.transform = CGAffineTransformScale(
                                                                                              CGAffineTransformIdentity, 0.001, 0.001);
                                          }
                                          completion:^(BOOL finished) {
                                              // 第三步： 移除
                                              [self removeFromSuperview];
                                          }];
                     }];
    
    
    if (self.integral >= self.model.pass_score){
         [[NSNotificationCenter defaultCenter]postNotificationName:ImmediateLuckyDrawNotification object:nil];
     }
        [[NSNotificationCenter defaultCenter]postNotificationName:FinshAnswerNotification object:nil];
    
}

- (UIView *)alertView {
    if (!_alertView) {
        _alertView = [[UIView alloc] init];
        _alertView.backgroundColor = [UIColor whiteColor];
        _alertView.layer.masksToBounds = YES;
        _alertView.layer.cornerRadius = 5;
        _alertView.userInteractionEnabled = YES;
    }
    return _alertView;
}
@end
