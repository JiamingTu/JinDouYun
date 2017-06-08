//
//  TJMExamViewController.m
//  TJMJinDouYun
//
//  Created by Jiaming Tu on 2017/4/19.
//  Copyright © 2017年 zhongzhichuangying. All rights reserved.
//

#import "TJMExamViewController.h"
#import "TJMQuestionTableViewCell.h"
#import "TJMAnswerTableViewCell.h"
#import "TJMEntryCheckViewController.h"
@interface TJMExamViewController ()<UITableViewDelegate,UITableViewDataSource,TDAlertViewDelegate>

//约束
//竖直
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *commitButtonHeightConstraint;


//
@property (nonatomic,strong) TJMTestQuestionData *questionData;

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *commitButton;

@property (nonatomic,strong) NSMutableDictionary *resultDict;
@end

@implementation TJMExamViewController
#pragma  mark - lazy loading
- (NSMutableDictionary *)resultDict {
    if (!_resultDict) {
        self.resultDict = [NSMutableDictionary dictionary];
    }
    return _resultDict;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setTitle:@"考试" fontSize:17 colorHexValue:0x333333];
    [self adjustFonts];
    [self resetConstraints];
    [self setBackNaviItem];
    [self getExamQuestions];
    
    
}
#pragma  mark - 页面设置
- (void)resetConstraints {
    [self tjm_resetVerticalConstraints:self.commitButtonHeightConstraint, nil];
}
- (void)adjustFonts {
    [self tjm_adjustFont:18 forView:self.commitButton, nil];
}

#pragma  mark - 获取试题 
- (void)getExamQuestions {
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    //转菊花
    MBProgressHUD *progressHUD = [TJMHUDHandle showRequestHUDAtView:self.view message:@"加载题目"];
    //请求
    [TJMRequestH freeManRandomGenerationTestQuestionSuccess:^(id successObj, NSString *msg) {
        self.questionData = successObj;
        [self.tableView reloadData];
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        [TJMHUDHandle hiddenHUDForView:self.view];
    } fial:^(NSString *failString) {
        progressHUD.label.text = [NSString stringWithFormat:@"%@，加载失败请退出重试",failString];
        [progressHUD hideAnimated:YES afterDelay:1.5];
    }];
}

#pragma  mark - 按钮方法
- (IBAction)commitExamAction:(UIButton *)sender {
    [self alertViewWithTag:10000 delegate:self title:@"确认提交？" cancelItem:@"取消" sureItem:@"确定"];
    
}
#pragma  mark - TDAlertViewDelegate
- (void)alertView:(TDAlertView *)alertView didClickItemWithIndex:(NSInteger)itemIndex {
    if (alertView.tag == 10000) {
        //答题完毕
        if (itemIndex == 0) {
            //计算得分
            //遍历题目
            NSInteger totalScore = [self calculateScore];
            NSInteger passScore = [self.questionData.config.passScore integerValue];
            if (totalScore >= passScore) {
                [TJMHUDHandle transientNoticeAtView:self.view withMessage:[NSString stringWithFormat:@"恭喜，考试通过，得分%zd",totalScore]];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    //提交结果
                    [TJMRequestH passExamWithChapter:@"4" success:^(id successObj, NSString *msg) {
                        //请求成功
                        TJMEntryCheckViewController *entryCheckVC = [self popTargetViewControllerWithViewControllerNumber:1];
                        entryCheckVC.freeManInfo.examStatus = @(4);
                        [self.navigationController popToViewController:entryCheckVC animated:YES];
                    } fail:^(NSString *failString) {
                        [TJMHUDHandle transientNoticeAtView:self.view withMessage:[NSString stringWithFormat:@"%@，请重试",failString]];
                    }];
                });
            } else {
                //考试未通过
                [self alertViewWithTag:10001 delegate:self title:@"考试未通过，是否再试一次" cancelItem:@"过会再考" sureItem:@"再试一次"];
            }
        }
        
    } else if (alertView.tag == 10001) {
        if (itemIndex == 0) {
             [self getExamQuestions];
        } else {
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
}
#pragma  mark - 计算得分
- (NSInteger)calculateScore {
    if (self.questionData) {
        __block NSInteger totalScore = 0,pointScore = [self.questionData.config.pointScore integerValue];
        [_questionData.question enumerateObjectsUsingBlock:^(TJMQuestion * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            if (obj.multi) {
                //多选 遍历 所有正确答案 是否被选中
                //标记：正确答案个数(rightAnswerCount) 答对个数(rightCount)
                //错误答案个数（errorAnswerCount） 未选择错误项的个数（unselectedCount）
                NSInteger rigthAnswerCount = 0, rightCout = 0;
                NSInteger errorAnswerCount = 0, unselectederrorCount = 0;
                for (TJMAnswer *answer in obj.answers) {
                    //统计 正确答案个数
                    if (answer.result) {
                        rigthAnswerCount ++;
                        if (answer.result == answer.isSelected) {
                            rightCout ++;
                        }
                    } else {
                        //未选择的个数
                        errorAnswerCount ++;
                        if (answer.result == answer.isSelected) {
                            unselectederrorCount ++;
                        }
                    }
                }
                //选择的项正确 且 错误的项未选择 才得分
                if (rightCout == rigthAnswerCount && errorAnswerCount == unselectederrorCount) {
                    totalScore += pointScore;
                }
            } else {
                //单选
                for (TJMAnswer *answer in obj.answers) {
                    //如果选中的answer 是正确答案 则加分 不然 不加
                    if (answer.isSelected) {
                        if (answer.result) {
                            totalScore += pointScore;
                        }
                    }
                }
            }
        }];
        TJMLog(@"最终得分：%zd",totalScore);
        return totalScore;
    }
    return 0;
}

#pragma  mark - UITableViewDelegate,UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.questionData.question.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    TJMQuestion *question = self.questionData.question[section];
    
    return question.answers.count + 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TJMQuestion *question = self.questionData.question[indexPath.section];
    if (indexPath.row == 0) {
        TJMQuestionTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"QuestionCell" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.numLabel.text = [NSString stringWithFormat:@"%zd.",indexPath.section + 1];
        cell.questionTitleLabel.text = question.title;
        return cell;
    } else {
        TJMAnswerTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AnswerCell" forIndexPath:indexPath];
        TJMAnswer *answer = question.answers[indexPath.row - 1];
        cell.isMulti = question.multi;
        [cell.selectImageView setHighlighted:answer.isSelected];
        
        cell.answerTitleLabel.text = answer.content;
        return cell;
    }
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    TJMQuestion *question = self.questionData.question[indexPath.section];
    if (indexPath.row != 0) {
        TJMAnswer *answer = question.answers[indexPath.row - 1];
        if (!question.multi) {
            //如果是单选
            //将所有答案都变成未选中
            for (TJMAnswer *answer in question.answers) {
                answer.isSelected = NO;
            }
            //将当前答案变为选中
            
            answer.isSelected = YES;
            [tableView reloadSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationFade];
        } else {
            answer.isSelected = !answer.isSelected;
            [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        }
    }
    
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 271 * TJMHeightRatio;
    return self.tableView.rowHeight;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10 * TJMHeightRatio;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return [[UIView alloc]init];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    if (self.isViewLoaded && !self.view.window) {
        self.view = nil;// 目的是再次进入时能够重新加载调用viewDidLoad函数。
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
