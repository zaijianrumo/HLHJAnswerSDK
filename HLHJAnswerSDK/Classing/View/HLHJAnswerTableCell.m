//
//  HLHJAnswerTableCell.m
//  HLHJAnswerSDK
//
//  Created by mac on 2018/8/21.
//  Copyright © 2018年 mac. All rights reserved.
//

#import "HLHJAnswerTableCell.h"


@implementation HLHJAnswerTableCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    if (self == [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {

        self.selectionStyle = 0;
        
        self.bgView = [[UIView alloc]init];
        self.bgView.backgroundColor = [UIColor colorWithHexString:@"ffffff"];//7C57F8
        self.bgView.layer.cornerRadius = 5;
        self.bgView.layer.borderWidth = 1;
        self.bgView.layer.borderColor = [UIColor colorWithHexString:@"999999"].CGColor;
        
        [self.contentView addSubview:self.bgView];
        [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).mas_offset(15);
            make.right.equalTo(self.contentView).mas_offset(-15);
            make.top.equalTo(self.contentView.mas_top).mas_offset(5);
            make.bottom.equalTo(self.contentView.mas_bottom).mas_offset(-5);
        }];
        
        self.statusImgView = [[UIImageView alloc]init];
        self.statusImgView.contentMode = UIViewContentModeScaleAspectFill;
        [self.bgView addSubview:self.statusImgView];
        [self.statusImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.bgView);
            make.left.equalTo(self.bgView.mas_left).mas_offset(10);
            make.width.mas_equalTo(0);
            make.height.mas_equalTo(17);
        }];
        
        self.titleLab = [[UILabel alloc]init];
        self.titleLab.text = @"方便干事儿方便干事儿方";
        self.titleLab.textColor =  [UIColor blackColor];
        self.titleLab.numberOfLines = 0;
        self.titleLab.textAlignment = NSTextAlignmentCenter;
        self.titleLab.font = [UIFont systemFontOfSize:15];
        [self.bgView addSubview:self.titleLab];
        [self.titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.top.bottom.equalTo(self.bgView);
            make.left.equalTo(self.statusImgView.mas_right).mas_offset(5);
        }];
    
    }
    return self;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
