//
//  HLHJRulesView.m
//  HLHJAnswerSDK
//
//  Created by mac on 2018/8/27.
//  Copyright © 2018年 mac. All rights reserved.
//

#import "HLHJRulesView.h"

@implementation HLHJRulesView

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self == [super initWithFrame:frame]) {

        
        UIView *bgView = [UIView new];
        bgView.backgroundColor = [UIColor whiteColor];
        bgView.layer.cornerRadius = 5;
        bgView.clipsToBounds = YES;
        [self addSubview:bgView];
        
        [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
        
        UIImageView *img = [[UIImageView alloc]init];
        img.image = [UIImage imageNamed:@"HLHJAnswerResouce.bundle/ic_dt_shuqian"];
        [self addSubview:img];
        
        [img mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).mas_offset(-17);
            make.top.equalTo(self).mas_offset(15);
        }];
        
        self.noLab = [[UILabel alloc]init];
        self.noLab.text = @"01";
        self.noLab.textColor = [UIColor whiteColor];
        self.noLab.font = [UIFont boldSystemFontOfSize:14];
        self.noLab.textAlignment = NSTextAlignmentCenter;
        [img addSubview:self.noLab];
        [self.noLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(img);
        }];
        
        
        self.objectLab = [[UILabel alloc]init];
        self.objectLab.text = @"活动对象";
        self.objectLab.textColor = [UIColor blackColor];
        self.objectLab.font = [UIFont boldSystemFontOfSize:15];
        self.objectLab.textAlignment = NSTextAlignmentCenter;
        [bgView addSubview:self.objectLab];
        [self.objectLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(img);
            make.left.equalTo(img.mas_right).mas_offset(5);
        }];
        
        self.contentTextView = [[UITextView alloc]init];
        self.contentTextView.text = @"测试事实似乎丝毫四核四十岁测试事实似乎丝";
        self.contentTextView.textColor = [UIColor blackColor];
        self.contentTextView.textAlignment = NSTextAlignmentLeft;
        self.contentTextView.font = [UIFont systemFontOfSize:13];
        [self.contentTextView setEditable:NO];
        [self.contentTextView endEditing:YES];
        [bgView addSubview:self.contentTextView];
        [self.contentTextView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.objectLab);
            make.top.equalTo(self.objectLab.mas_bottom).mas_offset(5);
            make.bottom.equalTo(bgView).mas_offset(-5);
            make.right.equalTo(bgView).mas_offset(-5);
        }];
   
        
    }
    return self;
    
}


@end
