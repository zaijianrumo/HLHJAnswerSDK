//
//  HLHJAnswerController.m
//  HLHJAnswerSDK
//
//  Created by mac on 2018/8/21.
//  Copyright © 2018年 mac. All rights reserved.
//

#import "HLHJAnswerController.h"
/** Controllers **/
#import "HLHJWKWebViewController.h"
/** Model **/
#import "HLHJActivityModel.h"
#import "HLHJQuestionsModel.h"
#import "HLHJPlayerInfoModel.h"
#import "HLHJPrizeModel.h"

/** Views**/
#import "UIButton+EnlageArea.h"
#import "HLHJRulesView.h"
#import "HLHJAnswerActionView.h"
#import "HLHJAnswerLoginView.h"
#import "HLHJSuccessfullyView.h"
#import "HLHJAnsweView.h"
#import "SVProgressHUD.h"


/** #define **/

@interface HLHJAnswerController ()

@property (nonatomic, strong) UIImageView *bgImageView;

@property (nonatomic, strong) UIButton  *startAnswerBtn,*activityRuleBtn;

@property (nonatomic, strong) HLHJAnswerActionView  *actionView;

@property (nonatomic, strong) HLHJAnswerLoginView  *loginView;

@property (nonatomic, strong) HLHJSuccessfullyView  *successfullyView;

@property (nonatomic, strong) HLHJActivityModel  *activityModel;

@property (nonatomic, strong) HLHJRulesView *ruleView,*ruleObjectView;

@end

@implementation HLHJAnswerController

#pragma mark - LifeCycle
-(void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
     self.navigationController.navigationBar.alpha = 0.0;
}
- (void)viewDidDisappear:(BOOL)animated {
    
     [super viewDidDisappear:animated];
     self.navigationController.navigationBar.alpha = 1.0;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];

    
   
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.bgImageView];
    
    [self.view addSubview:self.startAnswerBtn];
    
    [self.view addSubview:self.activityRuleBtn];
    [self.activityRuleBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).mas_offset(15);
        make.top.equalTo(self.view).mas_offset(30);
    }];
    
    CGFloat Kmargin = 15;
    [self.startAnswerBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).mas_offset(Kmargin);
        make.bottom.equalTo(self.view).mas_offset(-Kmargin+8);
        make.right.equalTo(self.view).mas_offset(-Kmargin);
        make.height.mas_equalTo(64);
    }];
    
    [self.view addSubview:self.actionView];
    [self.actionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).mas_offset(Kmargin);
        make.right.equalTo(self.view).mas_offset(-Kmargin);
        make.bottom.equalTo(self.startAnswerBtn.mas_top).mas_offset(-Kmargin-10);
        make.height.mas_equalTo(280);
    }];

    
    ///获取当前用户信息 在用户登录的情况下去获取
    NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:@"token"];
    if(token && token.length > 0){
        [self getPlayerInfo];
    }
    
     __weak typeof(self) weakSelf = self;
    self.actionView.loignBlock = ^(NSInteger buttonType) {
        
        NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:@"token"];
        if (token && token.length > 0) {
            
            weakSelf.navigationController.navigationBar.alpha = 1.0;
            
            HLHJWKWebViewController *web = [[HLHJWKWebViewController alloc]init];
            if (buttonType == 1) {
                  [web loadWebURLSring:[NSString stringWithFormat:@"%@/application/hlhj_prizeanswer/web?token=%@#/demo",BASE_URL,token]];
            }else {
                 [web loadWebURLSring:[NSString stringWithFormat:@"%@/application/hlhj_prizeanswer/web?token=%@#/",BASE_URL,token]];
            }
            [weakSelf.navigationController pushViewController:web animated:YES];
            
        }else {
            HLHJAnswerLoginView *loginView = [[HLHJAnswerLoginView alloc]initWithFrame:CGRectZero];
            [loginView showView];
        }
       
    };
    
    [self.actionView.currBtn addTarget:self action:@selector(currBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.actionView.nextBtn addTarget:self action:@selector(nextBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    ///获取当前活动信息
    [self getActivityData:1];
    ///获取奖品信息
    [self getPrizesData];

    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(getPlayerInfo) name:FinshAnswerNotification object:nil];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(immediateLuckyDraw) name:ImmediateLuckyDrawNotification object:nil];
    
    
}

#pragma mark - Delegate/DataSource Methods

#pragma mark - Notification Methods

- (void)immediateLuckyDraw {
    
    NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:@"token"];
    
    HLHJWKWebViewController *web = [[HLHJWKWebViewController alloc]init];
        [web loadWebURLSring:[NSString stringWithFormat:@"%@/application/hlhj_prizeanswer/web?token=%@#/",BASE_URL,token]];
    [self.navigationController pushViewController:web animated:YES];
}

#pragma mark - KVO Methods

#pragma mark - Public Methods
///获取当前/下期活动信息
- (void)getActivityData:(NSInteger)state {
    
    __weak typeof(self) weakSelf = self;
    [SVProgressHUD showWithStatus:nil];
    [HLHJAnswerNetWrokTools requestWithType:GET requestUrl:activity_api parameter:@{@"status":[@(state) stringValue]} successComplete:^(id  _Nullable responseObject) {
        [SVProgressHUD dismiss];
        NSLog(@"---%@",responseObject);
        NSInteger codeState = [responseObject[@"code"] integerValue];
        if (codeState == 200) {
            
            weakSelf.activityModel = [HLHJActivityModel yy_modelWithJSON:responseObject[@"data"]];
            if ([responseObject[@"data"] isKindOfClass:[NSDictionary class]]) {
                ///只有这里需要展示时间，需要的话可以封装一下
                NSDate *date               = [NSDate dateWithTimeIntervalSince1970:[weakSelf.activityModel.end_time doubleValue]];
                NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                [formatter setDateFormat:@"yyyy-MM-dd"];
                NSString *dateString       = [formatter stringFromDate: date];
                dispatch_async(dispatch_get_main_queue(), ^{
                
                    weakSelf.actionView.end_timeLab.hidden = NO;
                    weakSelf.actionView.prizeslba.hidden = NO;
                    weakSelf.actionView.prizesImgView.hidden = NO;
                    
                    weakSelf.actionView.end_timeLab.text = [NSString stringWithFormat:@"%@ 截止",dateString];
                    weakSelf.actionView.prizeslba.text = weakSelf.activityModel.title;
                    
                    weakSelf.actionView.topLineLab.backgroundColor = [UIColor lightGrayColor];
                    weakSelf.actionView.topLineLab.text = @"";
                    
                    [weakSelf.actionView.topLineLab mas_updateConstraints:^(MASConstraintMaker *make) {
                        make.width.mas_equalTo(1);
                    }];
                });
                weakSelf.startAnswerBtn.userInteractionEnabled = state == 1?YES:NO;
                weakSelf.startAnswerBtn.selected = state == 1?YES:NO;
            }else {
             
                if(state == 1){ ///当前活动
                    weakSelf.actionView.topLineLab.text = @"活动已结束";
                }else { ///下期活动
                    weakSelf.actionView.topLineLab.text = @"暂无计划";
                }
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    weakSelf.actionView.end_timeLab.hidden = YES;
                    weakSelf.actionView.prizeslba.hidden = YES;
                    weakSelf.actionView.prizesImgView.hidden = YES;
                    weakSelf.actionView.topLineLab.backgroundColor = [UIColor clearColor];
                    [weakSelf.actionView.topLineLab mas_updateConstraints:^(MASConstraintMaker *make) {
                        make.width.mas_equalTo(200);
                    }];
                });
                
                weakSelf.startAnswerBtn.userInteractionEnabled = NO;
                weakSelf.startAnswerBtn.selected = NO;
                
            }
        }
    } failureComplete:^(NSError * _Nonnull error) {
        [SVProgressHUD dismiss];
    }] ;
}
///当前用户信息
- (void)getPlayerInfo {
    
__weak typeof(self) weakSelf = self;
  NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:@"token"];
    [HLHJAnswerNetWrokTools requestWithType:GET requestUrl:getPlayerInfo_api parameter:@{@"token":token?token:@""} successComplete:^(id  _Nullable responseObject) {
        NSInteger codeState = [responseObject[@"code"] integerValue];
        if (codeState == 200) {
            HLHJPlayerInfoModel *model = [HLHJPlayerInfoModel yy_modelWithJSON:responseObject[@"data"]];
            
            dispatch_async(dispatch_get_main_queue(), ^{
//                [weakSelf.actionView.loginLeftBtn setTitle:model.points forState:UIControlStateNormal];
//                [weakSelf.actionView.loginRightBtn setTitle:model.drawable_times forState:UIControlStateNormal];
//                weakSelf.actionView.loginLeftBtn.userInteractionEnabled = NO;
//                weakSelf.actionView.loginRightBtn.userInteractionEnabled = NO;
            });
    
        }else {
//             dispatch_async(dispatch_get_main_queue(), ^{
//                 weakSelf.actionView.loginLeftBtn.userInteractionEnabled = YES;
//                 weakSelf.actionView.loginRightBtn.userInteractionEnabled = YES;
//             });
        }
    } failureComplete:^(NSError * _Nonnull error) {
    
    }] ;
}
///获取所有奖项
- (void)getPrizesData {
    __weak typeof(self) weakSelf = self;

    [HLHJAnswerNetWrokTools requestWithType:GET requestUrl:getPrizes_api parameter:nil successComplete:^(id  _Nullable responseObject) {
        NSInteger codeState = [responseObject[@"code"] integerValue];
        if (codeState == 200) {
           NSArray *prizesArr = [NSArray yy_modelArrayWithClass:[HLHJPrizeModel class] json:responseObject[@"data"]];
            if (prizesArr.count > 0) {
                HLHJPrizeModel *model = prizesArr[0];
                [weakSelf.actionView.prizesImgView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",BASE_URL,model.pic]]];
            }
            
        }
    } failureComplete:^(NSError * _Nonnull error) {
        
    }] ;
}
#pragma mark - Private Methods

#pragma mark - Action Methods
///开始答题
- (void)startAnswerAction:(UIButton *)sender {
   
    
    [SVProgressHUD showWithStatus:nil];
    
    NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:@"token"];
    
    self.startAnswerBtn.userInteractionEnabled =NO;
 
    NSDictionary *parame  = @{@"activity_id":_activityModel.ID,
                              @"token":token?token:@""};

    [HLHJAnswerNetWrokTools requestWithType:GET requestUrl:activityDetail_api parameter:parame successComplete:^(id  _Nullable responseObject) {
        
        [SVProgressHUD dismiss];
        self.startAnswerBtn.userInteractionEnabled = YES;

        NSInteger codeState = [responseObject[@"code"] integerValue];
        switch (codeState) {
            case 200: {
                
                HLHJQuestionsModel *model = [HLHJQuestionsModel yy_modelWithJSON:responseObject[@"data"]];
                ///判断是否已经答题
                if (model.has_answered == 1) {
                    [HLHJAnswerToast hsShowBottomWithText:@"您已经参与过此活动"];
                    return;
                }
                NSArray<QuestionsModel *> *questionArray = model.questions;
                if (questionArray.count > 0) {
                    HLHJAnsweView *answerView = [[HLHJAnsweView alloc]initWithFrame:CGRectZero questions:questionArray];
                    answerView.model = model;
                    [answerView showView];
                }else {
                    [HLHJAnswerToast hsShowBottomWithText:@"活动还未出题"];
                }
            }break;
                
            default:
                [HLHJAnswerToast hsShowBottomWithText:responseObject[@"msg"]];
                break;
        }
  
    } failureComplete:^(NSError * _Nonnull error) {
        [SVProgressHUD dismiss];
        self.startAnswerBtn.userInteractionEnabled = YES;
    }] ;
}
- (void)currBtnAction:(UIButton *)sender {
    
    self.actionView.currBtn.selected = YES;
    self.actionView.nextBtn.selected = NO;
    
    self.startAnswerBtn.selected = YES;
    self.startAnswerBtn.userInteractionEnabled = YES;
    
    [self.actionView.currBtn setBackgroundColor:[UIColor colorWithHexString:@"#7C57F8"]];
    [self.actionView.nextBtn setBackgroundColor:[UIColor colorWithHexString:@"ffffff"]];
    [self getActivityData:1];
    
}
- (void)nextBtnAction:(UIButton *)sender {
    
    self.actionView.nextBtn.selected = YES;
    self.actionView.currBtn.selected = NO;
    
    self.startAnswerBtn.selected = NO;
    self.startAnswerBtn.userInteractionEnabled = NO;
    
    [self.actionView.nextBtn setBackgroundColor:[UIColor colorWithHexString:@"#7C57F8"]];
    [self.actionView.currBtn setBackgroundColor:[UIColor colorWithHexString:@"ffffff"]];
    [self getActivityData:2];
}

///活动规则
- (void)seeActionRuleAction:(UIButton *)sender {
    
    sender.selected = !sender.selected;
    if (sender.selected) {
        self.actionView.hidden = YES;
        self.startAnswerBtn.hidden = YES;
        self.ruleView.hidden = NO;
        self.ruleObjectView.hidden = NO;
        [self.activityRuleBtn setImage:[UIImage imageNamed:@"HLHJAnswerResouce.bundle/nav_back"] forState:UIControlStateNormal];
        [self.activityRuleBtn setTitle:@"" forState:UIControlStateNormal];
        
    }else {
         self.actionView.hidden = NO;
         self.startAnswerBtn.hidden = NO;
          self.ruleView.hidden = YES;
          self.ruleObjectView.hidden = YES;
        
         [self.activityRuleBtn setImage:[UIImage imageNamed:@"HLHJAnswerResouce.bundle/ic_guize"] forState:UIControlStateNormal];
         [self.activityRuleBtn setTitle:@" 活动规则" forState:UIControlStateNormal];
        
        
        
    }
}
#pragma mark - Getter Methods

#pragma mark - Setter Methods

- (UIImageView *)bgImageView {
    if (!_bgImageView) {
        _bgImageView = [[UIImageView alloc]initWithFrame:self.view.bounds];
        _bgImageView.image = [UIImage imageNamed:@"HLHJAnswerResouce.bundle/bg"];
    }
    return _bgImageView;
    
}
- (UIButton *)startAnswerBtn {
    
    if (!_startAnswerBtn) {
        _startAnswerBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_startAnswerBtn setBackgroundImage:[UIImage imageNamed:@"HLHJAnswerResouce.bundle/btn_ksdt_disable"] forState:UIControlStateNormal];
        [_startAnswerBtn setBackgroundImage:[UIImage imageNamed:@"HLHJAnswerResouce.bundle/btn_ksdt_normal"] forState:UIControlStateSelected];
        [_startAnswerBtn setTitle:@"开始答题" forState:UIControlStateNormal];
        [_startAnswerBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_startAnswerBtn addTarget:self action:@selector(startAnswerAction:) forControlEvents:UIControlEventTouchUpInside];
        _startAnswerBtn.titleLabel.font = [UIFont systemFontOfSize:16];
        _startAnswerBtn.selected = YES;
    }
    return _startAnswerBtn;
}

- (UIButton *)activityRuleBtn {
    
    if (!_activityRuleBtn) {
        _activityRuleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_activityRuleBtn setTitle:@" 活动规则" forState:UIControlStateNormal];
        [_activityRuleBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_activityRuleBtn setImage:[UIImage imageNamed:@"HLHJAnswerResouce.bundle/ic_guize"] forState:UIControlStateNormal];
        [_activityRuleBtn addTarget:self action:@selector(seeActionRuleAction:) forControlEvents:UIControlEventTouchUpInside];
        _activityRuleBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [_activityRuleBtn setEnlargeEdgeWithTop:20 right:20 bottom:20 left:0];
        
    }
    return _activityRuleBtn;
    
}

- (HLHJAnswerActionView *)actionView {
    if (!_actionView) {
        _actionView = [[HLHJAnswerActionView alloc]initWithFrame:CGRectZero];
        _actionView.backgroundColor = [UIColor whiteColor];
        _actionView.layer.cornerRadius = 8;
        _actionView.clipsToBounds = YES;
    }
    return _actionView;
}

- (HLHJAnswerLoginView *)loginView {
    if (!_loginView) {
        _loginView = [[HLHJAnswerLoginView alloc]initWithFrame:CGRectZero];
    }
    return _loginView;
}


- (HLHJRulesView *)ruleView {
    if(!_ruleView){
        ///活动规则
        _ruleView = [[HLHJRulesView alloc]initWithFrame:CGRectZero];
        _ruleView.noLab.text = @"02";
        _ruleView.contentTextView.text = self.activityModel.rule;
        _ruleView.objectLab.text = @"活动规则";
        [self.view addSubview:_ruleView];
        [_ruleView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.bgImageView.mas_bottom).mas_offset(-28);
            make.left.equalTo(self.bgImageView.mas_left).mas_offset(30);
            make.right.equalTo(self.bgImageView.mas_right).mas_offset(-16);
            make.height.mas_equalTo(175);
        }];
    }
    return _ruleView;
}

- (HLHJRulesView *)ruleObjectView {
    if (!_ruleObjectView) {
        
        ///活动对象
        _ruleObjectView = [[HLHJRulesView alloc]initWithFrame:CGRectZero];
        _ruleObjectView.noLab.text = @"01";
        _ruleObjectView.objectLab.text = @"活动对象";
        _ruleObjectView.contentTextView.text = self.activityModel.object;
        [self.view addSubview:_ruleObjectView];
        [_ruleObjectView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.height.equalTo(self.ruleView);
            make.bottom.equalTo(self.ruleView.mas_top).mas_offset(-10);
        }];
    }
    return _ruleObjectView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}

@end
