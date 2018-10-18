//
//  HLHJAnswerLoginView.m
//  HLHJAnswerSDK
//
//  Created by mac on 2018/8/21.
//  Copyright © 2018年 mac. All rights reserved.
//

#import "HLHJAnswerLoginView.h"
#import "NSString+HLHJAnswerExtention.h"
@interface HLHJAnswerLoginView()

@property (nonatomic, strong) UIView  *alertView;

@property (nonatomic, strong) UITextField  *phoneFiled;

@property (nonatomic, strong) UITextField  *yzmFiled;

@property (nonatomic, strong) UIButton     *sureBtn;

@property (nonatomic, strong) UIButton     *sendYzmBtn;

@end

@implementation HLHJAnswerLoginView


- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
        
        self.frame = [UIScreen mainScreen].bounds;
        
        self.alertView.frame = CGRectZero;
        
        [self addSubview:self.alertView];
        
        UILabel *titleLab = [UILabel new];
        titleLab.text = @"参与答题";
        titleLab.textColor = [UIColor blackColor];
        titleLab.font = [UIFont systemFontOfSize:16];
        [self.alertView addSubview:titleLab];

        [titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.alertView);
            make.top.equalTo(self.alertView).mas_offset(17);
        }];
        
        UIButton *closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [closeBtn setImage:[UIImage imageNamed:@"HLHJAnswerResouce.bundle/ic_close"] forState:UIControlStateNormal];
        [closeBtn addTarget:self action:@selector(closeBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.alertView addSubview:closeBtn];
        
        [closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(titleLab);
            make.right.equalTo(self.alertView.mas_right).mas_offset(-15);
            make.width.height.mas_equalTo(20);
        }];
        
        
        UIView *lineView = [UIView new];
        lineView.backgroundColor = [UIColor groupTableViewBackgroundColor];
        [self.alertView addSubview:lineView];
        [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self.alertView);
            make.height.mas_equalTo(1);
            make.top.equalTo(titleLab.mas_bottom).mas_equalTo(13);
        }];
        
        
        [self.alertView addSubview:self.phoneFiled];
        CGFloat Kmarigin = 40;
        [self.phoneFiled mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(46);
            make.left.equalTo(self.alertView).mas_offset(Kmarigin  / 2);
            make.right.equalTo(self.alertView).mas_offset(-Kmarigin / 2);
            make.top.equalTo(lineView.mas_bottom).mas_offset(Kmarigin);

        }];
        
        [self.alertView addSubview:self.yzmFiled];
        [self.yzmFiled mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.height.equalTo(self.phoneFiled);
            make.top.equalTo(self.phoneFiled.mas_bottom).mas_offset(Kmarigin / 2 );
        }];
        

        [self.alertView addSubview:self.sureBtn];
        [self.sureBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.height.equalTo(self.phoneFiled);
            make.top.equalTo(self.yzmFiled.mas_bottom).mas_offset(Kmarigin );
            make.height.equalTo(self.phoneFiled.mas_height);
        }];
        
        
    }
    return self;
    
}


- (void)closeBtnAction:(UIButton *)sender {
    
    [self dismissAlertView];
}


- (void)sendYzmAction:(UIButton *)sender {
 
    if ([self.phoneFiled isFirstResponder]) {
        [self.phoneFiled resignFirstResponder];
    }
    
    
    [HLHJAnswerNetWrokTools requestWithType:POST requestUrl:getVerificationCode_api parameter:@{@"mobile":self.phoneFiled.text} successComplete:^(id  _Nullable responseObject) {
        NSInteger codeState = [responseObject[@"code"] integerValue];
        switch (codeState) {
            case 200: {
                [HLHJAnswerToast hsShowBottomWithText:@"发送成功"];
                [self messageTime];
            }break;
            default:
                [HLHJAnswerToast hsShowBottomWithText:responseObject[@"msg"]];
                break;
        }

    } failureComplete:^(NSError * _Nonnull error) {
        
    }];
    
}

- (void)logonAction:(UIButton *)sender {
    
    if ([self.phoneFiled isFirstResponder]) {
        [self.phoneFiled resignFirstResponder];
    }
    if ([self.yzmFiled isFirstResponder]) {
        [self.yzmFiled resignFirstResponder];
    }
    
    __weak typeof(self) weakSelf = self;
    [HLHJAnswerNetWrokTools requestWithType:POST requestUrl:login_api parameter:@{@"mobile":self.phoneFiled.text,@"sms_code":self.yzmFiled.text} successComplete:^(id  _Nullable responseObject) {
    
        NSInteger codeState = [responseObject[@"code"] integerValue];
        switch (codeState) {
            case 200: {
    
                [weakSelf dismissAlertView];
                [HLHJAnswerToast hsShowBottomWithText:@"登录成功"];
                [[NSUserDefaults standardUserDefaults]setObject:responseObject[@"data"][@"token"] forKey:@"token"];
                [[NSUserDefaults standardUserDefaults]synchronize];
                
                [[NSNotificationCenter defaultCenter]postNotificationName:FinshAnswerNotification object:nil];
                
            }break;
            default:
                [HLHJAnswerToast hsShowBottomWithText:responseObject[@"msg"]];
                break;
        }
        
    } failureComplete:^(NSError * _Nonnull error) {
        
    }];
    
    
}
- (void)phoneFiledTextChange:(UITextField *)textFiled {
    
    self.phoneFiled = textFiled;
    if (self.phoneFiled.text.length > 11) {
        self.phoneFiled.text = [textFiled.text substringToIndex:11];
    }
    
    if (![NSString phoneMenberRule:self.phoneFiled.text]) {;
        [self.sendYzmBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
         self.sendYzmBtn.userInteractionEnabled = NO;
          return;
    }else {
        [self.sendYzmBtn setTitleColor:[UIColor colorWithHexString:@"#F70798"] forState:UIControlStateNormal];
         self.sendYzmBtn.userInteractionEnabled = YES;
    }

}
- (void)yzmFiledTextChange:(UITextField *)textFiled {
    
    textFiled = self.yzmFiled ;
    if (textFiled.text.length > 6) {
        self.yzmFiled.text = [textFiled.text substringToIndex:6];
    }
    if (textFiled.text.length >= 4 && [NSString phoneMenberRule:self.phoneFiled.text]) {
        self.sureBtn.backgroundColor = [UIColor colorWithHexString:@"#F70798"];
        self.sureBtn.userInteractionEnabled = YES;
    }else {
        self.sureBtn.backgroundColor = [UIColor lightGrayColor];
        self.sureBtn.userInteractionEnabled = NO;
    }
}
- (void)messageTime {
    
    __block int timeout=60; //倒计时时间
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
    
    dispatch_source_set_event_handler(_timer, ^{
        if(timeout<=0){ //倒计时结束，关闭
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置
                [self.sendYzmBtn setTitle:@"发送验证码" forState:UIControlStateNormal];
                [self.sendYzmBtn setTitleColor:[UIColor colorWithHexString:@"#F70798"] forState:0];
                 self.sendYzmBtn.userInteractionEnabled = YES;
            });
        }else{
            int seconds = timeout % 61;
            NSString *strTime = [NSString stringWithFormat:@"%.2d", seconds];
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置
                [UIView beginAnimations:nil context:nil];
                [UIView setAnimationDuration:1];
                [self.sendYzmBtn setTitle:[NSString stringWithFormat:@"%@S",strTime] forState:UIControlStateNormal];
                [self.sendYzmBtn setTitleColor:[UIColor colorWithHexString:@"#F70798"] forState:0];
                //To do
                [UIView commitAnimations];
                self.sendYzmBtn.userInteractionEnabled = NO;
            });
            timeout--;
        }
    });
    dispatch_resume(_timer);
    
}
- (void)showView {
    
    self.backgroundColor = [UIColor clearColor];
    
    [[UIApplication sharedApplication].keyWindow addSubview:self];
   
    self.alertView.frame = CGRectMake(44,[UIScreen mainScreen].bounds.size.height+([UIScreen mainScreen].bounds.size.height-360)/2, ([UIScreen mainScreen].bounds.size.width-88),360);
    
    self.alertView.alpha = 0;
    
    [UIView animateWithDuration:1 animations:^{
        
    } completion:^(BOOL finished) {
        
        [UIView animateWithDuration:.3
                         animations:^{
                             
                             self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:.4f];
                             
                             self.alertView.frame = CGRectMake(44,([UIScreen mainScreen].bounds.size.height-330)/2, ([UIScreen mainScreen].bounds.size.width-88),330);
                             
                             self.alertView.alpha = 1;
                             
                         }completion:^(BOOL finish){
                             
                         }];
    }];
}

-(void)dismissAlertView {
    
    [UIView animateWithDuration:1 animations:^{
        
    self.alertView.frame = CGRectMake(44,([UIScreen mainScreen].bounds.size.height-330)/2, ([UIScreen mainScreen].bounds.size.width-88),330);
        
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:.08
                         animations:^{
                             self.backgroundColor = [UIColor clearColor];
                             
                             self.alertView.frame = CGRectMake(44,[UIScreen mainScreen].bounds.size.height+([UIScreen mainScreen].bounds.size.height-330)/2, ([UIScreen mainScreen].bounds.size.width-88),330);
                             
                             self.alertView.alpha = 0.0;
                         }completion:^(BOOL finish){
                             [self removeFromSuperview];
                         }];
    }];
    

    
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
- (UITextField *)phoneFiled {
    if (!_phoneFiled) {
    
        _phoneFiled = [[UITextField alloc]init];
        _phoneFiled.placeholder = @"请输入手机号";
        _phoneFiled.textColor = [UIColor blackColor];
        _phoneFiled.font = [UIFont systemFontOfSize:15];
        _phoneFiled.keyboardType = UIKeyboardTypePhonePad;
        _phoneFiled.layer.borderWidth = 1;
        _phoneFiled.layer.borderColor = [UIColor groupTableViewBackgroundColor].CGColor;
        _phoneFiled.layer.cornerRadius = 20;
        _phoneFiled.clipsToBounds = YES;
        
        UIView *leftView  = [[UIView alloc]init];
        leftView.frame = CGRectMake(0, 0, 10, 20);
        _phoneFiled.leftView = leftView;
        _phoneFiled.leftViewMode = UITextFieldViewModeAlways;
        [_phoneFiled addTarget:self action:@selector(phoneFiledTextChange:) forControlEvents:UIControlEventEditingChanged];
    }
    return _phoneFiled;
    
}
- (UITextField *)yzmFiled {
    if (!_yzmFiled) {
        
        _yzmFiled = [[UITextField alloc]init];
        _yzmFiled.placeholder = @"验证码";
        _yzmFiled.textColor = [UIColor blackColor];
        _yzmFiled.font = [UIFont systemFontOfSize:15];
        _yzmFiled.keyboardType = UIKeyboardTypePhonePad;
        _yzmFiled.layer.borderWidth = 1;
        _yzmFiled.layer.borderColor = [UIColor groupTableViewBackgroundColor].CGColor;
        _yzmFiled.layer.cornerRadius = 20;
        _yzmFiled.clipsToBounds = YES;
        
        UIView *leftView  = [[UIView alloc]init];
        leftView.frame = CGRectMake(0, 0, 10, 20);
        _yzmFiled.leftView = leftView;
        _yzmFiled.leftViewMode = UITextFieldViewModeAlways;
    
        _yzmFiled.rightView = self.sendYzmBtn;
        _yzmFiled.rightViewMode = UITextFieldViewModeAlways;
        [_yzmFiled addTarget:self action:@selector(yzmFiledTextChange:) forControlEvents:UIControlEventEditingChanged];
    }
    return _yzmFiled;
    
}
- (UIButton *)sendYzmBtn {
    if (!_sendYzmBtn) {
        _sendYzmBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_sendYzmBtn  setTitle:@"发送验证码" forState:UIControlStateNormal];
        [_sendYzmBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        _sendYzmBtn.titleLabel.font = [UIFont systemFontOfSize:12];
        _sendYzmBtn.frame = CGRectMake(0, 0, 80, 30);
        _sendYzmBtn.userInteractionEnabled = NO;
        [_sendYzmBtn addTarget:self action:@selector(sendYzmAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _sendYzmBtn;
}

- (UIButton *)sureBtn {
    if (!_sureBtn) {
        _sureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_sureBtn  setTitle:@"确定" forState:UIControlStateNormal];
        [_sureBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _sureBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        _sureBtn.backgroundColor = [UIColor lightGrayColor];
        _sureBtn.layer.cornerRadius = 20;
        _sureBtn.clipsToBounds = YES;
        _sureBtn.userInteractionEnabled = NO;
        [_sureBtn addTarget:self action:@selector(logonAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _sureBtn;
}

@end
