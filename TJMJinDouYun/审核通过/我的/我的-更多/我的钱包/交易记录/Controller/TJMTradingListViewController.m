//
//  TJMTradingListViewController.m
//  TJMJinDouYun
//
//  Created by Jiaming Tu on 2017/5/8.
//  Copyright © 2017年 zhongzhichuangying. All rights reserved.
//

#import "TJMTradingListViewController.h"
#import "TJMTradingListTableViewCell.h"
const NSInteger _tradingSize = 15;
@interface TJMTradingListViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    NSInteger _tradingPage;
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic,strong) NSMutableArray *dataSourceArray;

@property (nonatomic,strong) MJRefreshNormalHeader *header;
@property (nonatomic,strong) MJRefreshAutoNormalFooter *footer;
@end

@implementation TJMTradingListViewController
#pragma  mark - lazy loading
- (NSMutableArray *)dataSourceArray {
    if (!_dataSourceArray) {
        self.dataSourceArray = [NSMutableArray array];
        _tradingPage = 0;
    }
    return _dataSourceArray;
}
- (MJRefreshNormalHeader *)header {
    if (!_header) {
        self.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            [self.dataSourceArray removeAllObjects];
            _tradingPage = 0;
            [self.footer resetNoMoreData];
            [self getTradingRecordList];
        }];
    }
    return _header;
}
- (MJRefreshAutoNormalFooter *)footer {
    if (!_footer) {
        self.footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            _tradingPage ++;
            [self getTradingRecordList];
        }];
    }
    return _footer;
}
#pragma  mark - view life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setTitle:@"交易记录" fontSize:17 colorHexValue:0x333333];
    [self setBackNaviItem];
    
    [self configViews];
    [self.header beginRefreshing];
    
    
}
#pragma  mark - 设置页面
- (void)configViews {
    [self.tableView setTableFooterView:[[UIView alloc]initWithFrame:CGRectZero]];
    self.tableView.mj_header = self.header;
    self.tableView.mj_footer = self.footer;
}
#pragma  mark - 获取数据
- (void)getTradingRecordList {
    [TJMRequestH getTradingRecordWithPage:_tradingPage size:_tradingSize sort:nil dir:nil success:^(id successObj, NSString *msg) {
        TJMTradingRecordData *data = successObj;
        if (data.content.count == 0) {
            [self.footer endRefreshingWithNoMoreData];
            return ;
        }
        if (data.content.count < _tradingSize) {
            [self.footer endRefreshingWithNoMoreData];
        }
        if (_tradingPage == 0) {
            //刷新
            
            [self.header endRefreshing];
        } else {
            //上拉
            [self.footer endRefreshing];
        }
        [self.dataSourceArray addObjectsFromArray:data.content];
        [self.tableView reloadData];
    } fail:^(NSString *failString) {
        
    }];
}

#pragma  mark - UITableViewDelegate,UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger count = self.dataSourceArray.count;
    if (!count) {
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    } else {
        tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    }
    return count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TJMTradingListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TradingList" forIndexPath:indexPath];
    TJMTradingRecordModel *model = self.dataSourceArray[indexPath.row];
    if (indexPath.row == self.dataSourceArray.count - 1) {
        [cell setSeparatorInset:UIEdgeInsetsMake(0, TJMScreenWidth + 1, 0, 0)];
    } else {
        [cell setSeparatorInset:UIEdgeInsetsMake(0, 0, 0, 0)];
    }
    [cell setViewWithModel:model];
    
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10 * TJMHeightRatio;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return [[UIView alloc]initWithFrame:CGRectZero];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44 * TJMHeightRatio;
}

#pragma  mark - memory warning
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
