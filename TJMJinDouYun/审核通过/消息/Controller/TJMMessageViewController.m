//
//  TJMMessageViewController.m
//  TJMJinDouYun
//
//  Created by Jiaming Tu on 2017/4/27.
//  Copyright © 2017年 zhongzhichuangying. All rights reserved.
//

#import "TJMMessageViewController.h"
#import "TJMMessageTableViewCell.h"
const NSInteger _messageSize = 15;
@interface TJMMessageViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    NSInteger _messagePage;
}
@property (nonatomic,strong) NSMutableArray *localReadedIdArray;
@property (nonatomic,strong) NSMutableArray *dataSourceArray;
@property (nonatomic,strong) MBProgressHUD *progressHUD;

@property (nonatomic,strong) MJRefreshNormalHeader *header;
@property (nonatomic,strong) MJRefreshAutoNormalFooter *footer;


@end

@implementation TJMMessageViewController
#pragma  mark - lazy loading
- (NSMutableArray *)dataSourceArray {
    if (!_dataSourceArray) {
        self.dataSourceArray = [NSMutableArray array];
    }
    return _dataSourceArray;
}
- (NSMutableArray *)localReadedIdArray {
    if (!_localReadedIdArray) {
        self.localReadedIdArray = [NSMutableArray array];
        NSArray *list = [TJMSandBoxManager getModelFromInfoPlistWithKey:kTJMReadedMessageIdList];
        if (list && list.count > 0) {
            [_localReadedIdArray addObjectsFromArray:list];
        }
    }
    return _localReadedIdArray;
}
- (MJRefreshNormalHeader *)header {
    if (!_header) {
        self.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            _messagePage = 0;
            [self.dataSourceArray removeAllObjects];
            [self getMessageList];
        }];
    }
    return _header;
}
- (MJRefreshAutoNormalFooter *)footer {
    if (!_footer) {
        self.footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            _messagePage ++;
            [self getMessageList];
        }];
    }
    return _footer;
}
#pragma  mark - view life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setTitle:@"消息" fontSize:17 colorHexValue:0x333333];
    [self configViews];
    _messagePage = 0;
    self.progressHUD = [TJMHUDHandle showRequestHUDAtView:self.view message:nil];
    NSArray *array = [TJMSandBoxManager getMessages];
    if (array) {
        [self.dataSourceArray addObjectsFromArray:array];
    }
    [self refreshList];
}


#pragma  mark - 设置页面
- (void)configViews {
//    [self.navigationController.navigationBar tjm_hideShadowImageOrNot:YES];
    self.tableView.mj_footer = self.footer;
    self.tableView.mj_header = self.header;
}

#pragma  mark - 更新消息列表 并刷新未读数量
- (void)refreshList {
    [self.header beginRefreshing];
}

#pragma  mark - 获取消息列表
- (void)getMessageList {
    [TJMRequestH getFreeManMessageListWithPage:_messagePage size:_messageSize sort:nil success:^(id successObj, NSString *msg) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            //删除本地缓存消息
            [TJMSandBoxManager deleteMessages];
            TJMMessageData *data = successObj;
            //遍历数组 对比 已读列表
            [data.data enumerateObjectsUsingBlock:^(TJMMessageModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                //判断model 已读 还是 未读
                if (!obj.read) {
                    //如果是未读，则对比已读列表
                    BOOL result = [self.localReadedIdArray containsObject:obj.messageCenterId];
                    if (result) {
                        //但是已读列表中有，则标记为已读
                        obj.read = YES;
                    }
                } else {
                    //如果是已读，而又在已读列表中，则删除已读列表中的对应数据，结束遍历后储存
                    BOOL result = [self.localReadedIdArray containsObject:obj.messageCenterId];
                    if (result) {
                        [_localReadedIdArray removeObject:obj.messageCenterId];
                    }
                }
            }];
            //已读列表存入本地
            if (_localReadedIdArray.count) {
                [TJMSandBoxManager saveInInfoPlistWithModel:_localReadedIdArray key:kTJMReadedMessageIdList];
            }
            [self.dataSourceArray addObjectsFromArray:data.data];
            //存入本地缓存
            [TJMSandBoxManager saveMessagesToPath:_dataSourceArray];
            //回到主线程
            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                if (data.data.count == 0) {
                    [self.tableView.mj_footer endRefreshingWithNoMoreData];
                }
               
                if (_messagePage == 0) {
                    //刷新
                    [self.tableView.mj_header endRefreshing];
                    if (_messageSize > data.data.count) {
                        //没有更多数据
                        [self.tableView.mj_footer endRefreshingWithNoMoreData];
                    }
                } else {
                    [self.tableView.mj_footer endRefreshing];
                }
                [self.tableView reloadData];
                //隐藏菊花图
                [TJMHUDHandle hiddenHUDForView:self.view];
            }];
            
        });
        
    } fail:^(NSString *failString) {
        self.progressHUD.label.text = failString;
        [self.progressHUD hideAnimated:YES afterDelay:1.5];
        [self.header endRefreshing];
        [self.footer endRefreshing];
    }];
}

#pragma  mark - UITableViewDelegate,UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSourceArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TJMMessageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MessageCell" forIndexPath:indexPath];
    //设置cell
    
    TJMMessageModel *model = self.dataSourceArray[indexPath.row];
    [cell setViewWithModel:model];
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 66 * TJMHeightRatio;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10 *TJMHeightRatio;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return [[UIView alloc]initWithFrame:CGRectZero];
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    TJMMessageTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    [cell setSelected:NO animated:YES];
    
    [self readMessageWithIndexPath:indexPath];
    
}
//- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
//    
//}

#pragma  mark - 点击消息后，上传已阅读信息
- (void)readMessageWithIndexPath:(NSIndexPath *)indexPath {
    MBProgressHUD *progressHUD = [TJMHUDHandle showRequestHUDAtView:self.view message:nil];
    TJMMessageModel *model = self.dataSourceArray[indexPath.row];
    [TJMRequestH readMessageWithMessageId:model.messageCenterId success:^(id successObj, NSString *msg) {
        //异步操作
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            //添加这条消息id到 已读消息列表 并储存
//            NSArray *list = [TJMSandBoxManager getModelFromInfoPlistWithKey:kTJMReadedMessageIdList];
//            NSMutableArray *newList = [NSMutableArray arrayWithArray:list];
            
            [self.localReadedIdArray addObject:model.messageCenterId];
            [TJMSandBoxManager saveInInfoPlistWithModel:_localReadedIdArray key:kTJMReadedMessageIdList];//储存
            //未读消息数量-1 并储存
            self.appDelegate.msgBadgeValue = @(self.appDelegate.msgBadgeValue.integerValue - 1);
            [TJMSandBoxManager saveInInfoPlistWithModel:self.appDelegate.msgBadgeValue key:kTJMUnreadMessageNum];
            //回到主线程 刷新 ui
            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                [TJMHUDHandle hiddenHUDForView:self.view];
                //刷新当前点击的cell
                [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
                //跳转页面
                [self performSegueWithIdentifier:@"MessageToMsgDetail" sender:model];
            }];
            //更新消息列表缓存
            [TJMSandBoxManager deleteMessages];
            model.read = YES;
            [TJMSandBoxManager saveMessagesToPath:self.dataSourceArray];
        });
    } fail:^(NSString *failString) {
        progressHUD.label.text = failString;
        [progressHUD hideAnimated:YES afterDelay:1.5];
    }];
    
    
    
    
}

#pragma  mark memory warning
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    if (self.isViewLoaded && !self.view.window) {
        self.view = nil;// 目的是再次进入时能够重新加载调用viewDidLoad函数。
    }
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqualToString:@"MessageToMsgDetail"]) {
        [segue.destinationViewController setValue:sender forKey:@"messageModel"];
    }
}


@end
