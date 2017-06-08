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
        _messagePage = 0;
    }
    return _dataSourceArray;
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
    self.progressHUD = [TJMHUDHandle showRequestHUDAtView:self.view message:nil];
    NSArray *array = [TJMSandBoxManager getMessages];
    if (array) {
        [self.dataSourceArray addObjectsFromArray:array];
    }
    [self.header beginRefreshing];
}

#pragma  mark - 设置页面
- (void)configViews {
//    [self.navigationController.navigationBar tjm_hideShadowImageOrNot:YES];
    self.tableView.mj_footer = self.footer;
    self.tableView.mj_header = self.header;
}
#pragma  mark - 获取消息列表
- (void)getMessageList {
    [TJMRequestH getFreeManMessageListWithPage:_messagePage size:_messageSize sort:nil success:^(id successObj, NSString *msg) {
        [TJMHUDHandle hiddenHUDForView:self.view];
        TJMMessageData *data = successObj;
        if (data.data.count == 0) {
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
        }
        [self.dataSourceArray addObjectsFromArray:data.data];
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
    cell.messageLabel.text = model.content;
    NSString *timeString = [NSString getTimeWithTimestamp:model.updateTime formatterStr:@"MM-dd HH:mm"];
    cell.dateLabel.text = timeString;
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
    TJMMessageModel *model = self.dataSourceArray[indexPath.row];
    [self performSegueWithIdentifier:@"MessageToMsgDetail" sender:model];
    
    
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
