//
//  NSString+HLHJAnswerExtention.m
//  HLHJAnswerSDK
//
//  Created by mac on 2018/8/27.
//  Copyright © 2018年 mac. All rights reserved.
//

#import "NSString+HLHJAnswerExtention.h"

@implementation NSString (HLHJAnswerExtention)
+ (BOOL)phoneMenberRule:(NSString *)phoneMenber {
    if (!phoneMenber) {
        return NO;
    }
    if (phoneMenber.length != 11)
    {
        return NO;
    }
    NSString *regex = @"^(13[0-9]|14[579]|15[0-3,5-9]|16[6]|17[0135678]|18[0-9]|19[89])\\d{8}$";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    BOOL isMatch = [pred evaluateWithObject:phoneMenber];
    if (isMatch) {
        return YES;
    }
    return NO;
}

@end
