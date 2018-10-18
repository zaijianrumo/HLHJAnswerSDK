//
//  HLHJAnsweView.m
//  HLHJAnswerSDK
//
//  Created by mac on 2018/8/21.
//  Copyright © 2018年 mac. All rights reserved.
//

#import "HLHJAnsweView.h"
#import "HLHJAnswerTableCell.h"
#import "HLHJAnswerCircleView.h"
#import "HLHJSuccessfullyView.h"
#import "HLHJQuestionsModel.h"
#import "SVProgressHUD.h"
@interface HLHJAnsweView()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) HLHJAnswerCircleView *circleView;

@property (nonatomic, strong) UIView       *alertView;

@property (nonatomic, strong) UITableView  *tableView;
///积分
@property (nonatomic, strong) UILabel      *integralLab;
///所有的题
@property (nonatomic, strong) NSArray      *questionsArray;
///弹框总的高度
@property (nonatomic, assign) CGFloat      allHeight;
///题的下标
@property (nonatomic, assign) NSInteger    index;
///是否选择了答案
@property (nonatomic, assign) BOOL       select;
///自动选择？(时间到了之后自动选择)
@property (nonatomic, assign) BOOL       autoSselect;
///选择的序号
@property (nonatomic, assign) NSInteger    chooseNO;
///平均分
@property (nonatomic, assign) CGFloat  integral;
///答对题的次数
@property (nonatomic, assign) CGFloat  times;
///定时器
@property (nonatomic,strong) NSTimer *labelTimer;
///秒数
@property (nonatomic, assign) NSInteger  seconds;

@end

@implementation HLHJAnsweView

- (instancetype)initWithFrame:(CGRect)frame questions:(NSArray *)questions {
    self = [super initWithFrame:frame];
    if (self) {
        
        self.frame = [UIScreen mainScreen].bounds;
        
        self.questionsArray = questions;
        self.index = 0;
        self.times = 0;
        _seconds = 1;
        self.integral = 100 / questions.count;
        self.allHeight = 460;
        self.alertView.frame = CGRectZero;
        self.integralLab.frame = CGRectZero;
        [self addSubview:self.alertView];
        [self addSubview:self.integralLab];
        
        UIImageView *topimg = [[UIImageView alloc]init];
        topimg.image = [UIImage imageNamed:@"HLHJAnswerResouce.bundle/ic_dt_bg"];
        [self.alertView addSubview:topimg];
        [topimg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.right.equalTo(self.alertView);
            make.height.mas_equalTo(139);
        }];
        
        _labelTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(nameLbChange) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:_labelTimer forMode:NSRunLoopCommonModes];
        
        CGFloat width = [UIScreen mainScreen].bounds.size.width;
        
        _circleView = [[HLHJAnswerCircleView alloc] initWithFrame:CGRectMake((width-40-75)/2, 13, 75, 75)];
        _circleView.backgroundColor = [UIColor whiteColor];
        //进度条宽度
        _circleView.strokelineWidth = 10;
        
        _circleView.layer.cornerRadius = 75/2;
        _circleView.clipsToBounds = YES;
        //设置进度,是否有动画效果
        [_circleView circleWithProgress:100 andIsAnimate:YES];
        
        
        [topimg addSubview:_circleView];
        
        UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
        tableView.backgroundColor = [UIColor whiteColor];
        tableView.separatorStyle = 0;
        tableView.estimatedRowHeight = 50;
        tableView.dataSource = self;
        tableView.delegate = self;
        [tableView registerClass:[HLHJAnswerTableCell class] forCellReuseIdentifier:@"HLHJAnswerTableCell"];
        if (@available(iOS 11.0, *)) {
            tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
            tableView.estimatedSectionFooterHeight = 0;
            tableView.estimatedSectionHeaderHeight = 0;
        }
        [self.alertView addSubview:tableView];
        [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.bottom.right.equalTo(self.alertView);
            make.top.equalTo(topimg.mas_bottom);
        }];
        self.tableView = tableView;
    }
    return self;
}
- (void)nameLbChange {
    
    self.circleView.numbLb.attributedText = [self labelStytle:self.seconds];
    
    __weak typeof(self) weakSelf = self;
    if (_seconds >= 10) {
        [_labelTimer setFireDate:[NSDate distantFuture]];
        self.autoSselect = YES;
        self.select = YES;
        QuestionsModel *model = self.questionsArray[_index];
        self.chooseNO = model.correct_option+1;
        [self.tableView reloadData];
        
        ///最后一题
        if (self->_index == self.questionsArray.count - 1) {
            [self lastAnswer];
            return;
        }
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            weakSelf.chooseNO = 0;
            weakSelf.select = NO;
            weakSelf.index = weakSelf.index + 1;
            weakSelf.autoSselect = NO;
            weakSelf.seconds = 1;
            [weakSelf.labelTimer setFireDate:[NSDate date]];
            //设置进度,是否有动画效果
            [weakSelf.circleView circleWithProgress:100 andIsAnimate:YES];
            [weakSelf.tableView reloadData];
        });
    }
    _seconds += 1;
    
}
-(NSMutableAttributedString*)labelStytle:(NSInteger)value{
    
    NSString* pace=[NSString stringWithFormat:@"%ld%@",(long)value,@"S"];
    NSMutableAttributedString* pace1=[[NSMutableAttributedString alloc]initWithString:pace];
    [pace1 addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:20] range:NSMakeRange(0, pace.length-1)];
    [pace1 addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:13] range:NSMakeRange(pace.length-1, 1)];
    NSRange titleRange = NSMakeRange(0, pace.length);
    [pace1 addAttribute:NSForegroundColorAttributeName
                  value:[UIColor redColor]
                  range:titleRange];
    return pace1;
}

- (void)setModel:(HLHJQuestionsModel *)model {
    _model = model;
}

#pragma TableViewDatasource / TableviewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    QuestionsModel *model = self.questionsArray[_index];
    return model.options.count + 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CGFloat rowHeight = UITableViewAutomaticDimension;
    
    if (rowHeight < 60) {
        
        return 60;
        
    }else {
        return rowHeight;
    }
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    QuestionsModel *model = self.questionsArray[_index];
    if (indexPath.row == 0) {
        static NSString *cellID = @"identifier";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
        if (!cell) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
            cell.accessoryType = UITableViewCellAccessoryNone;
            cell.selectionStyle = 0;
        }
        cell.textLabel.text = [NSString stringWithFormat:@"\n%ld.%@\n",(long)_index + 1,model.stem];
        cell.textLabel.numberOfLines = 0;
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
        cell.textLabel.font = [UIFont boldSystemFontOfSize:15];
        cell.textLabel.textColor = [UIColor blackColor];
        return cell;
    }else {
        
        HLHJAnswerTableCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HLHJAnswerTableCell"];
        cell.titleLab.text = model.options[indexPath.row-1];
        
        if (self.select) {
            ///1.得到选择的选项的下标
            NSInteger chooseIndex = indexPath.row;
            ///2.判断是否是正确答案
            if (self.chooseNO == model.correct_option+1 && self.chooseNO == chooseIndex) {
                
                cell.bgView.backgroundColor = [UIColor colorWithHexString:@"7C57F8"];
                cell.bgView.layer.borderWidth = 0;
                cell.titleLab.textColor = [UIColor whiteColor];
                cell.statusImgView.image = [UIImage imageNamed:@"HLHJAnswerResouce.bundle/ic_dt_zhengque"];
                [cell.statusImgView mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.width.mas_equalTo(17);
                }];
                if (!_autoSselect) {
                    self.times  = self.times + 1;
                }
            }else {
                ///选择了错误答案
                if (self.chooseNO == chooseIndex) {
                    
                    cell.bgView.backgroundColor = [UIColor colorWithHexString:@"F70798"];//
                    cell.bgView.layer.borderWidth = 0;
                    cell.titleLab.textColor = [UIColor whiteColor];
                    cell.statusImgView.image = [UIImage imageNamed:@"HLHJAnswerResouce.bundle/ic_dt_cuowu"];
                    [cell.statusImgView mas_updateConstraints:^(MASConstraintMaker *make) {
                        make.width.mas_equalTo(17);
                    }];
                }
                
                if (model.correct_option+1 == chooseIndex) {
                    cell.bgView.backgroundColor = [UIColor colorWithHexString:@"7C57F8"];
                    cell.bgView.layer.borderWidth = 0;
                    cell.titleLab.textColor = [UIColor whiteColor];
                    cell.statusImgView.image = [UIImage imageNamed:@"HLHJAnswerResouce.bundle/ic_dt_zhengque"];
                    [cell.statusImgView mas_updateConstraints:^(MASConstraintMaker *make) {
                        make.width.mas_equalTo(17);
                    }];
                }
            }
        }else {
            ///重置状态
            cell.bgView.backgroundColor = [UIColor colorWithHexString:@"ffffff"];
            cell.bgView.layer.borderWidth = 1;
            cell.titleLab.textColor = [UIColor blackColor];
            cell.statusImgView.image = [UIImage imageNamed:@""];
            [cell.statusImgView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.width.mas_equalTo(0);
            }];
        }
        ///所有题都答对为100分
        CGFloat integral  = self.integral * self.times;
        if (self.times == self.questionsArray.count) {
            integral = 100;
        }
        self.integralLab.text = [NSString stringWithFormat:@"当前分数:%.lf",integral];
        return cell;
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return .1f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return .1f;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (self.select) {
        return;
    }
    [_labelTimer setFireDate:[NSDate distantFuture]];
    self.chooseNO = indexPath.row;
    self.select = YES;
    [self.tableView reloadData];
    
    
    ///最后一题
    if (self->_index == self.questionsArray.count - 1) {
            [self lastAnswer];
        return;
    }
    __weak typeof(self) weakSelf = self;
    ///不是最后一题刷新界面
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        weakSelf.chooseNO = 0;
        weakSelf.select = NO;
        weakSelf.index = weakSelf.index + 1;
        weakSelf.autoSselect = NO;
        weakSelf.seconds = 1;
        [weakSelf.labelTimer setFireDate:[NSDate date]];
        [weakSelf.circleView circleWithProgress:100 andIsAnimate:YES];
        [self.tableView reloadData];
    });   
}

///最后一题
-(void)lastAnswer {
     __weak typeof(self) weakSelf = self;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [SVProgressHUD showWithStatus:nil];
        
        [HLHJAnswerNetWrokTools requestWithType:POST requestUrl:submitAnswer_api parameter:@{@"activity_id": weakSelf.model.ID,@"correct_count":[@(weakSelf.times) stringValue]} successComplete:^(id  _Nullable responseObject) {
            [SVProgressHUD dismiss];
            
            NSInteger codeState = [responseObject[@"code"] integerValue];
            if (codeState == 200) {
                ///先移除答题框
                CGFloat integral  = weakSelf.integral * weakSelf.times;
                if (weakSelf.times == weakSelf.questionsArray.count) {
                    integral = 100;
                }
                [weakSelf dismissAlertView];
                ///展示答题成功页面
                HLHJSuccessfullyView  * successfullyView  =[[HLHJSuccessfullyView alloc]initWithFrame:CGRectZero hlhjQuestionsModel:weakSelf.model allIntegral:integral];
                
                [successfullyView showView];
            }else {
                [HLHJAnswerToast hsShowBottomWithText:responseObject[@"msg"]];
            }
        } failureComplete:^(NSError * _Nonnull error) {
            [SVProgressHUD dismiss];
        }];
    });
}
- (void)showView {
    
    self.backgroundColor = [UIColor clearColor];
    
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    
    self.alertView.frame = CGRectMake(20,[UIScreen mainScreen].bounds.size.height+([UIScreen mainScreen].bounds.size.height-_allHeight)/2, ([UIScreen mainScreen].bounds.size.width-40),_allHeight);
    
    self.alertView.alpha = 0;
    
    [UIView animateWithDuration:1 animations:^{
        
    } completion:^(BOOL finished) {
        
        [UIView animateWithDuration:.3
                         animations:^{
                             
                             self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:.8f];
                             
                             
                             self.alertView.frame = CGRectMake(20,([UIScreen mainScreen].bounds.size.height-_allHeight)/2, ([UIScreen mainScreen].bounds.size.width-40),_allHeight);
                             
                             
                             self.integralLab.frame = CGRectMake(20,CGRectGetMinY(self.alertView.frame) - 40, ([UIScreen mainScreen].bounds.size.width-40), 20);
                             
                             self.alertView.alpha = 1;
                             
                         }completion:^(BOOL finish){
                             
                         }];
    }];
}

-(void)dismissAlertView {
    
    [_labelTimer invalidate];
    _labelTimer = nil;
    
    [UIView animateWithDuration:1 animations:^{
        
        self.alertView.frame = CGRectMake(20,([UIScreen mainScreen].bounds.size.height-_allHeight)/2, ([UIScreen mainScreen].bounds.size.width-40),_allHeight);
        
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:.08
                         animations:^{
                             self.backgroundColor = [UIColor clearColor];
                             
                             self.alertView.frame = CGRectMake(20,[UIScreen mainScreen].bounds.size.height+([UIScreen mainScreen].bounds.size.height-self->_allHeight)/2, ([UIScreen mainScreen].bounds.size.width-40),_allHeight);
                             
                             self.alertView.alpha = 0.0;
                             
                         }completion:^(BOOL finish){
                             [self removeFromSuperview];
                         }];
    }];
}
- (UIView *)alertView {
    if (!_alertView) {
        _alertView = [[UIView alloc] init];
        _alertView.backgroundColor = [UIColor clearColor];
        _alertView.layer.masksToBounds = YES;
        _alertView.layer.cornerRadius = 5;
        _alertView.userInteractionEnabled = YES;
    }
    return _alertView;
}
- (UILabel *)integralLab {
    if (!_integralLab) {
        _integralLab = [[UILabel alloc]init];
        _integralLab.text = @"当前分数:0";
        _integralLab.textAlignment = NSTextAlignmentCenter;
        _integralLab.textColor = [UIColor whiteColor];
        _integralLab.font = [UIFont boldSystemFontOfSize:15];
    }
    return _integralLab;
}

@end
