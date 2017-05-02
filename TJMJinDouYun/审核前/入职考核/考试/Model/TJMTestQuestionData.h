//
//  TJMTestQuestionData.h
//  TJMJinDouYun
//
//  Created by Jiaming Tu on 2017/4/19.
//  Copyright © 2017年 zhongzhichuangying. All rights reserved.
//

#import <Foundation/Foundation.h>

@class TJMConfig,TJMQuestionCategory;

@interface TJMTestQuestionData : NSObject

@property (nonatomic,copy) NSArray *question;
@property (nonatomic,strong) TJMConfig *config;
@end

@interface TJMConfig : NSObject

@property (nonatomic,strong) NSNumber *configId;
@property (nonatomic,strong) NSNumber *count;
@property (nonatomic,strong) NSNumber *fullScore;
@property (nonatomic,strong) NSNumber *passScore;
@property (nonatomic,strong) NSNumber *pointScore;
@property (nonatomic,strong) NSNumber *genType;

@end



@interface TJMQuestion : NSObject

@property (nonatomic,strong) NSNumber *questionId;
@property (nonatomic,copy) NSString *title;
@property (nonatomic,assign) BOOL enable;
@property (nonatomic,assign) BOOL multi;
@property (nonatomic,strong) TJMQuestionCategory *questionCategory;
@property (nonatomic,copy) NSArray *answers;

@end

@interface TJMQuestionCategory : NSObject
@property (nonatomic,strong) NSNumber *questionCategoryId;
@property (nonatomic,copy) NSString *name;
@end

@interface TJMAnswer : NSObject

@property (nonatomic,strong) NSNumber *questionAnswerId;
@property (nonatomic,copy) NSString *answerOption;
@property (nonatomic,copy) NSString *content;
@property (nonatomic,assign) BOOL result;

@end
