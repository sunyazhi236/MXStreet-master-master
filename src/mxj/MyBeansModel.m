//
//  MyBeansModel.m
//  mxj
//
//  Created by MQ-MacBook on 16/6/10.
//  Copyright © 2016年 bluemobi. All rights reserved.
//

#import "MyBeansModel.h"

@implementation MyBeansModel

- (void)setUserName:(NSString *)userName
{
    if (userName.length == 0) {
        _userName = @"系统";
    }
    else {
        _userName = userName;
    }
}

- (void)setSortId:(NSString *)sortId
{
    /* 获取日期 */
    NSDate *date;
    /* 时间戳转时间及日期 */
    if ([sortId length] ==13) {
        /* 毫秒级时间戳 */
        date = [NSDate dateWithTimeIntervalSince1970:[sortId longLongValue]/1000];
    }
    else if ([sortId length] == 10) {
        /* 秒级时间戳 */
        date = [NSDate dateWithTimeIntervalSince1970:[sortId longLongValue]];
    }
    else {
        date = [NSDate date];
    }

    NSString *time;
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSString *timeStr2 = [formatter stringFromDate:date];
    NSArray *array = [timeStr2 componentsSeparatedByString:@"-"];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy"];
    NSString *currentYear = [dateFormatter stringFromDate:[NSDate date]];//当前年份
    NSString *currentDate = [formatter stringFromDate:[NSDate date]];//当前年月日
    
    if ([currentDate isEqualToString:timeStr2]) {
        /* 今天 */
        time = @"今 天";
    }
    else //if ([[array objectAtIndex:0] isEqualToString:currentYear])
    {
        /* 今年的不显示年份只显示月日 */
        time = [NSString stringWithFormat:@"%@-%@",[array objectAtIndex:1],[array objectAtIndex:2]];
    }
//    else {
//        /* 非今年 */
//        time = timeStr2;
//    }
    
    self.day = time;
    

    /* 获取时间 */
    NSDateFormatter *formatter2 = [[NSDateFormatter alloc] init];
    [formatter2 setDateFormat:@"HH：mm"];

    self.time = [formatter2 stringFromDate:date];
}

@end
