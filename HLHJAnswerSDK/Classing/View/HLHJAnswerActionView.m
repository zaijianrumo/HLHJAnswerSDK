//
//  HLHJAnswerActionView.m
//  HLHJAnswerSDK
//
//  Created by mac on 2018/8/21.
//  Copyright © 2018年 mac. All rights reserved.
//

#import "HLHJAnswerActionView.h"

@interface HLHJAnswerActionView()



@end

@implementation HLHJAnswerActionView

- (instancetype)initWithFrame:(CGRect)frame {
    
    
    self = [super initWithFrame:frame];
    if (self) {
        
         ///顶部
        UIView *topView = [UIView new];
        topView.backgroundColor = [UIColor clearColor];
        [self addSubview:topView];
        
        ///中间横线
        UIView *mlineView = [UIView new];
        mlineView.backgroundColor = [UIColor groupTableViewBackgroundColor];
        [self addSubview:mlineView];
        
        ///底部 我的积分 可抽奖
        UIView *bottomView = [UIView new];
        bottomView.backgroundColor = [UIColor clearColor];
        [self addSubview:bottomView];

        
        [mlineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).mas_offset(30);
            make.right.equalTo(self).mas_offset(-30);
            make.centerY.equalTo(self).mas_offset(30);
            make.height.mas_equalTo(.8);
        }];
        
        [topView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.right.equalTo(self);
            make.bottom.equalTo(mlineView.mas_top);
        }];
        
        [bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.right.left.equalTo(self);
            make.top.equalTo(mlineView.mas_bottom);
        }];
        
       
        ///当前活动 , 下期活动
        
        UIButton *currBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [currBtn setTitle:@"当前活动" forState:UIControlStateNormal];
        [currBtn setBackgroundColor:[UIColor colorWithHexString:@"#7C57F8"]];
        [currBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        [currBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        currBtn.layer.borderColor = [UIColor groupTableViewBackgroundColor].CGColor;
        currBtn.layer.borderWidth  = 1;
        currBtn.selected = YES;
        self.currBtn = currBtn;
        
        
        UIButton *nextBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [nextBtn setTitle:@"下期活动" forState:UIControlStateNormal];
        [nextBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        [nextBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        nextBtn.layer.borderColor = [UIColor groupTableViewBackgroundColor].CGColor;
        nextBtn.layer.borderWidth  = 1;
        self.nextBtn = nextBtn;
        
        [topView addSubview:currBtn];
        [topView addSubview:nextBtn];
        
        [currBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(topView).mas_offset(30);
            make.left.equalTo(topView).mas_offset(50);
            make.height.mas_equalTo(46);
            make.width.equalTo(nextBtn);
        }];
        
        [nextBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(currBtn);
            make.right.equalTo(topView.mas_right).mas_offset(-50);
            make.height.equalTo(currBtn);
            make.left.equalTo(currBtn.mas_right);
        }];
        
        //上面竖线 /活动已经结束
        UILabel *topLineLab = [UILabel new];
        topLineLab.backgroundColor = [UIColor colorWithHexString:@"E0E0E0"];
        topLineLab.textAlignment = NSTextAlignmentCenter;
        topLineLab.backgroundColor = [UIColor blackColor];
        topLineLab.font = [UIFont systemFontOfSize:14];
        [topView addSubview:topLineLab];
        
        
        
        ///结束时间
        UILabel *timelba = [[UILabel alloc]init];
        timelba.text = @"          ";
        timelba.textColor = [UIColor blackColor];
        timelba.font = [UIFont systemFontOfSize:15];
        [topView addSubview:timelba];
        self.end_timeLab = timelba;
        
       /// 奖品
        UIImageView *prizesImgView = [UIImageView new];
        prizesImgView.contentMode =  UIViewContentModeScaleAspectFill;
        prizesImgView.clipsToBounds = YES;
        prizesImgView.backgroundColor = [UIColor clearColor];
        [topView addSubview:prizesImgView];
        self.prizesImgView = prizesImgView;
        
        
        UILabel *prizeslba = [[UILabel alloc]init];
        prizeslba.text = @"";
        prizeslba.textColor = [UIColor blackColor];
        prizeslba.font = [UIFont systemFontOfSize:15];
        prizeslba.numberOfLines = 0;
        prizeslba.textAlignment = NSTextAlignmentLeft;
        [topView addSubview:prizeslba];
        self.prizeslba = prizeslba;
    
        
        [topLineLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(topView);
            make.width.mas_equalTo(1);
            make.height.mas_equalTo(30);
            make.bottom.equalTo(mlineView.mas_top).mas_offset(-35);
        }];
        
        [timelba mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(topLineLab);
            make.right.equalTo(topLineLab.mas_left).mas_offset(-20);
        }];
        
        [prizesImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(topLineLab);
            make.left.equalTo(topLineLab.mas_right).mas_offset(20);
            make.height.mas_equalTo(50);
            make.width.mas_equalTo(40);
        }];
        
        [prizeslba mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(topLineLab);
            make.left.equalTo(prizesImgView.mas_right).mas_offset(10);
            make.right.equalTo(topView).mas_offset(-2);
            
        }];
        
        

    //// 我的积分 可抽奖
    
        UIView *bLineView = [UIView new];
        bLineView.backgroundColor = [UIColor groupTableViewBackgroundColor];
        [bottomView addSubview:bLineView];
        
        [bLineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(bottomView);
            make.top.equalTo(bottomView.mas_top).mas_offset(30);
            make.bottom.equalTo(bottomView.mas_bottom).mas_offset(-30);
            make.width.equalTo(topLineLab);
        }];
        
        ///我的积分
        UILabel *integrallLab = [[UILabel alloc]init];
        integrallLab.text = @"我的奖品";
        integrallLab.textColor = [UIColor blackColor];
        integrallLab.textAlignment = NSTextAlignmentCenter;
        integrallLab.font = [UIFont systemFontOfSize:15];
        [bottomView addSubview:integrallLab];
        
        UIButton *logonBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [logonBtn setTitle:@"查看" forState:UIControlStateNormal];
        [logonBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        logonBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        [bottomView addSubview:logonBtn];
        [logonBtn addTarget:self action:@selector(loginAciton:) forControlEvents:UIControlEventTouchUpInside];
        self.loginLeftBtn = logonBtn;
        logonBtn.tag = 1;
        
        [integrallLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(bottomView.mas_left);
            make.right.equalTo(bLineView.mas_left);
            make.top.equalTo(bottomView.mas_top).mas_offset(30);
            make.height.equalTo(logonBtn.mas_height);
        }];
        
        [logonBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(integrallLab);
            make.top.equalTo(integrallLab.mas_bottom);
        }];
        

        ///可抽奖
        UILabel *luckylLab = [[UILabel alloc]init];
        luckylLab.text = @"可抽奖";
        luckylLab.textColor = [UIColor blackColor];
        luckylLab.textAlignment = NSTextAlignmentCenter;
        luckylLab.font = [UIFont systemFontOfSize:15];
        [bottomView addSubview:luckylLab];
        
        UIButton *logonBtn1 = [UIButton buttonWithType:UIButtonTypeCustom];
        [logonBtn1 setTitle:@"查看" forState:UIControlStateNormal];
        [logonBtn1 setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        logonBtn1.titleLabel.font = [UIFont systemFontOfSize:15];
        [logonBtn1 addTarget:self action:@selector(loginAciton:) forControlEvents:UIControlEventTouchUpInside];
        [bottomView addSubview:logonBtn1];
        self.loginRightBtn = logonBtn1;
        logonBtn1.tag = 2;
        
        [luckylLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(bLineView.mas_right);
            make.right.equalTo(bottomView.mas_right);
            make.top.equalTo(integrallLab.mas_top);
            make.height.equalTo(logonBtn.mas_height);
        }];
        
        [logonBtn1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(luckylLab);
            make.top.equalTo(luckylLab.mas_bottom);
        }];
    }
    return self;
    
}

-(void)loginAciton:(UIButton *)sender {
    if (self.loignBlock) {
        self.loignBlock(sender.tag);
    }
}
@end


/*
//
//  HLHJAnswerActionView.m
//  HLHJAnswerSDK
//
//  Created by mac on 2018/8/21.
//  Copyright © 2018年 mac. All rights reserved.
//


#import "HLHJAnswerActionView.h"

@implementation HLHJAnswerActionView

- (instancetype)initWithFrame:(CGRect)frame {
    
    
    self = [super initWithFrame:frame];
    if (self) {
        
        ///顶部
        UIView *topView = [UIView new];
        topView.backgroundColor = [UIColor clearColor];
        [self addSubview:topView];
        
        
        [topView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
        
        
        ///当前活动 , 下期活动
        
        UIButton *currBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [currBtn setTitle:@"当前活动" forState:UIControlStateNormal];
        [currBtn setBackgroundColor:[UIColor colorWithHexString:@"#7C57F8"]];
        [currBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        [currBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        currBtn.layer.borderColor = [UIColor groupTableViewBackgroundColor].CGColor;
        currBtn.layer.borderWidth  = 1;
        currBtn.selected = YES;
        self.currBtn = currBtn;
        
        
        UIButton *nextBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [nextBtn setTitle:@"下期活动" forState:UIControlStateNormal];
        [nextBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        [nextBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        nextBtn.layer.borderColor = [UIColor groupTableViewBackgroundColor].CGColor;
        nextBtn.layer.borderWidth  = 1;
        self.nextBtn = nextBtn;
        
        [topView addSubview:currBtn];
        [topView addSubview:nextBtn];
        
        [currBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(topView).mas_offset(30);
            make.left.equalTo(topView).mas_offset(50);
            make.height.mas_equalTo(46);
            make.width.equalTo(nextBtn);
        }];
        
        [nextBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(currBtn);
            make.right.equalTo(topView.mas_right).mas_offset(-50);
            make.height.equalTo(currBtn);
            make.left.equalTo(currBtn.mas_right);
        }];
        
        //上面竖线 /活动已经结束
        UILabel *topLineLab = [UILabel new];
        topLineLab.backgroundColor = [UIColor colorWithHexString:@"E0E0E0"];
        topLineLab.textAlignment = NSTextAlignmentCenter;
        topLineLab.backgroundColor = [UIColor blackColor];
        topLineLab.font = [UIFont systemFontOfSize:14];
        [topView addSubview:topLineLab];
        self.topLineLab = topLineLab;
        
        
        ///结束时间
        UILabel *timelba = [[UILabel alloc]init];
        timelba.text = @"          ";
        timelba.textColor = [UIColor blackColor];
        timelba.font = [UIFont systemFontOfSize:15];
        [topView addSubview:timelba];
        self.end_timeLab = timelba;
        
        /// 奖品
        UIImageView *prizesImgView = [UIImageView new];
        prizesImgView.contentMode =  UIViewContentModeScaleAspectFill;
        prizesImgView.clipsToBounds = YES;
        prizesImgView.backgroundColor = [UIColor clearColor];
        [topView addSubview:prizesImgView];
        self.prizesImgView = prizesImgView;
        
        
        UILabel *prizeslba = [[UILabel alloc]init];
        prizeslba.text = @"";
        prizeslba.textColor = [UIColor blackColor];
        prizeslba.font = [UIFont systemFontOfSize:15];
        prizeslba.numberOfLines = 0;
        prizeslba.textAlignment = NSTextAlignmentLeft;
        [topView addSubview:prizeslba];
        self.prizeslba = prizeslba;
        
        
        [topLineLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(topView);
            make.width.mas_equalTo(1);
            make.height.mas_equalTo(30);
            make.bottom.equalTo(self.mas_bottom).mas_offset(-35);
        }];
        
        [timelba mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(topLineLab);
            make.right.equalTo(topLineLab.mas_left).mas_offset(-20);
        }];
        
        [prizesImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(topLineLab);
            make.left.equalTo(topLineLab.mas_right).mas_offset(20);
            make.height.mas_equalTo(50);
            make.width.mas_equalTo(40);
        }];
        
        [prizeslba mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(topLineLab);
            make.left.equalTo(prizesImgView.mas_right).mas_offset(10);
            make.right.equalTo(topView).mas_offset(-2);
            
        }];
        
        
    }
    return self;
    
}

-(void)loginAciton:(UIButton *)sender {
    if (self.loignBlock) {
        self.loignBlock();
    }
}
@end
*/
