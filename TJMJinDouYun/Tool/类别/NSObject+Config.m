//
//  NSObject+Config.m
//  TJMJinDouYun
//
//  Created by Jiaming Tu on 2017/5/3.
//  Copyright © 2017年 zhongzhichuangying. All rights reserved.
//

#import "NSObject+Config.h"

@implementation NSObject (Config)


- (void)tjm_resetVerticalConstraints:(NSLayoutConstraint *)constrain, ... NS_REQUIRES_NIL_TERMINATION  {
    if (constrain) {
        // 取出第一个参数
        constrain.constant *= TJMHeightRatio;
        // 定义一个指向个数可变的参数列表指针；
        va_list args;
        // 用于存放取出的参数
        id arg;
        // 初始化变量刚定义的va_list变量，这个宏的第二个参数是第一个可变参数的前一个参数，是一个固定的参数
        va_start(args, constrain);
        // 遍历全部参数 va_arg返回可变的参数(a_arg的第二个参数是你要返回的参数的类型)
        while ((arg = va_arg(args, NSLayoutConstraint *))) {
            NSLayoutConstraint *layoutConstraint = arg;
            layoutConstraint.constant *= TJMHeightRatio;
        }
        // 清空参数列表，并置参数指针args无效
        va_end(args);
    }
}
- (void)tjm_resetHorizontalConstraints:(NSLayoutConstraint *)constrain, ... NS_REQUIRES_NIL_TERMINATION  {
    if (constrain) {
        // 取出第一个参数
        constrain.constant *= TJMWidthRatio;
        // 定义一个指向个数可变的参数列表指针；
        va_list args;
        // 用于存放取出的参数
        id arg;
        // 初始化变量刚定义的va_list变量，这个宏的第二个参数是第一个可变参数的前一个参数，是一个固定的参数
        va_start(args, constrain);
        // 遍历全部参数 va_arg返回可变的参数(a_arg的第二个参数是你要返回的参数的类型)
        while ((arg = va_arg(args, NSLayoutConstraint *))) {
            NSLayoutConstraint *layoutConstraint = arg;
            layoutConstraint.constant *= TJMWidthRatio;
        }
        // 清空参数列表，并置参数指针args无效
        va_end(args);
    }
}


#pragma  mark - 设置字体
- (void)tjm_adjustFont:(CGFloat)fontSize forView:(id)view, ... NS_REQUIRES_NIL_TERMINATION  {
    if (view) {
        // 取出第一个参数
        [self tjm_setFont:fontSize accordingToClass:view];
        // 定义一个指向个数可变的参数列表指针；
        va_list args;
        // 用于存放取出的参数
        id arg;
        // 初始化变量刚定义的va_list变量，这个宏的第二个参数是第一个可变参数的前一个参数，是一个固定的参数
        va_start(args, view);
        // 遍历全部参数 va_arg返回可变的参数(a_arg的第二个参数是你要返回的参数的类型)
        while ((arg = va_arg(args, id))) {
            [self tjm_setFont:fontSize accordingToClass:arg];
        }
        // 清空参数列表，并置参数指针args无效
        va_end(args);
    }
}

- (void)tjm_setFont:(CGFloat)fontSize accordingToClass:(id)unknownClass {
    if([unknownClass isKindOfClass:[UIButton class]]){
        UIButton *button = unknownClass;
        button.titleLabel.font = [UIFont systemFontOfSize:fontSize];
    } else if ([unknownClass isKindOfClass:[UILabel class]]){
        UILabel *label = unknownClass;
        label.font = [UIFont systemFontOfSize:fontSize];
    } else if ([unknownClass isKindOfClass:[UITextField class]]) {
        UITextField *textField = unknownClass;
        textField.font = [UIFont systemFontOfSize:fontSize];
    }else if ([unknownClass isKindOfClass:[UITextView class]]) {
        UITextView *textView = unknownClass;
        textView.font = [UIFont systemFontOfSize:fontSize];
    }
}

- (void)tjm_constructImaginaryLineWithView:(UIView *)view {
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    [shapeLayer setBounds:view.bounds];
    [shapeLayer setPosition:CGPointMake(CGRectGetWidth(view.frame) / 2, CGRectGetHeight(view.frame))];
    [shapeLayer setFillColor:[UIColor clearColor].CGColor];
    //  设置虚线颜色为blackColor
    [shapeLayer setStrokeColor:TJMFUIColorFromRGB(0xd0d0d0).CGColor];
    //  设置虚线宽度
    [shapeLayer setLineWidth:CGRectGetHeight(view.frame)];
    [shapeLayer setLineJoin:kCALineJoinRound];
    //  设置线宽，线间距
    [shapeLayer setLineDashPattern:[NSArray arrayWithObjects:[NSNumber numberWithInt:7 * TJMWidthRatio], [NSNumber numberWithInt:3 * TJMWidthRatio], nil]];
    //  设置路径
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, NULL, 0, 0);
    CGPathAddLineToPoint(path, NULL,CGRectGetWidth(view.frame), 0);
    [shapeLayer setPath:path];
    CGPathRelease(path);
    [view.layer addSublayer:shapeLayer];

}
#pragma  mark - 返回日期 格式(例：今天17:30)
- (NSString *)tjm_setDateFormatterWithTimestamp:(NSInteger)timestamp {
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:timestamp / 1000];
    NSString *whatDay = [self tjm_compareDate:date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"hh:mm"];
    NSString *dateString = [formatter stringFromDate:date];
    return [whatDay stringByAppendingString:dateString];
    
}
#pragma  mark 返回 今天 昨天 前天 等
-(NSString *)tjm_compareDate:(NSDate *)date{
    
    NSTimeInterval secondsPerDay = 24 * 60 * 60;
    NSDate *today = [[NSDate alloc] init];
    NSDate *beforeYesterday, *yesterday;
    
    beforeYesterday = [today dateByAddingTimeInterval: - 2 * secondsPerDay];
    yesterday = [today dateByAddingTimeInterval: -secondsPerDay];
    
    // 10 first characters of description is the calendar date:
    NSString * todayString = [[today description] substringToIndex:10];
    NSString * yesterdayString = [[yesterday description] substringToIndex:10];
    NSString * beforeYesterdayString = [[beforeYesterday description] substringToIndex:10];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy-MM-dd "];
    NSString *formatterDateString = [formatter stringFromDate:date];
    NSString * dateString = [[date description] substringToIndex:10];
    if ([dateString isEqualToString:todayString]) {
        return @"今天";
    } else if ([dateString isEqualToString:yesterdayString]) {
        return @"昨天";
    } else if ([dateString isEqualToString:beforeYesterdayString]) {
        return @"前天";
    } else {
        return formatterDateString;
    }  
}

#pragma  mark 转换开工时间
- (NSString *)tjm_getTimeStringWithTimestamp:(NSInteger)timestamp {
    NSTimeInterval timeInterval = timestamp;
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:timeInterval];
    // 3.创建日历
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSCalendarUnit type =  NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    // 4.利用日历对象比较两个时间的差值
    NSDateComponents *cmps = [calendar components:type fromDate:[[NSDate alloc]initWithTimeIntervalSince1970:0] toDate:date options:0];
    // 5.返回结果
    NSString *hour = cmps.hour < 10 ? [NSString stringWithFormat:@"0%zd",cmps.hour] : [NSString stringWithFormat:@"%zd",cmps.hour];
    NSString *minute = cmps.minute < 10 ? [NSString stringWithFormat:@"0%zd",cmps.minute] : [NSString stringWithFormat:@"%zd",cmps.minute];
    NSString *second = cmps.second < 10 ? [NSString stringWithFormat:@"0%zd",cmps.second] : [NSString stringWithFormat:@"%zd",cmps.second];
    
    return [NSString stringWithFormat:@"%@:%@:%@",hour,minute,second];
}


@end
