//
//  TJMTestQuestionData.m
//  TJMJinDouYun
//
//  Created by Jiaming Tu on 2017/4/19.
//  Copyright © 2017年 zhongzhichuangying. All rights reserved.
//

#import "TJMTestQuestionData.h"

@implementation TJMTestQuestionData

+ (NSDictionary *)objectClassInArray{
    return @{
             @"question" : @"TJMQuestion",
             };
}
@end

@implementation TJMConfig

@end

@implementation TJMQuestion

+ (NSDictionary *)objectClassInArray{
    return @{
             @"answers" : @"TJMAnswer",
             };
}

//- (NSString *)description {
//    return [NSString stringWithFormat:@"answers:%@\n enable:%d\n multi:%d\n questionCategory:%@\n questionId:%@\n title:%@\n",self.answers,self.enable,self.multi,self.questionCategory,self.questionId,self.title];
//}
@end

@implementation TJMQuestionCategory

@end

@implementation TJMAnswer

@end
