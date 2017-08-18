//
//  TJMMyOrderDetailViewController.m
//  TJMJinDouYun
//
//  Created by Jiaming Tu on 2017/5/8.
//  Copyright © 2017年 zhongzhichuangying. All rights reserved.
//

#import "TJMMyOrderDetailViewController.h"
#import "TJMMyOrderDetailTableViewCell.h"
#import "TJMMyOrderDetailHeaderView.h"
#import "TJMOrderDetailInfoModel.h"
@interface TJMMyOrderDetailViewController ()<UITableViewDelegate,UITableViewDataSource,UIWebViewDelegate>
//约束
//按钮宽度
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *rightButtonWidthConstraint;
//按钮高度
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *leftButtonHeightConstraint;


@property (nonatomic,strong) TJMOrderDetailData *dataSource;

@end

@implementation TJMMyOrderDetailViewController
#pragma  mark - lazy loading 
- (TJMOrderDetailData *)dataSource {
    if (!_dataSource) {
        self.dataSource = [[TJMOrderDetailData alloc]initWithOrderModel:self.orderModel];
    }
    return _dataSource;
}
#pragma  mark - view life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setTitle:@"订单详情" fontSize:17 colorHexValue:0x333333];
    [self resetConstraints];
    [self configViews];
    [TJMRequestH getSingleOrderWithOrderNumber:self.orderModel.orderNo success:^(id successObj, NSString *msg) {
        
    } fail:^(NSString *failString) {
        
    }];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self setBottomButton];
}

#pragma  mark - 设置页面
- (void)configViews {
    [self.tableView registerClass:[TJMMyOrderDetailHeaderView class] forHeaderFooterViewReuseIdentifier:@"MyOrderDetailHeader"];
    [self setRightNaviItemWithImageName:nil orTitle:@"申报异常" titleColorHexValue:0x333333 fontSize:15];
    [self setBackNaviItem];
}
- (void)resetConstraints {
    [self tjm_resetVerticalConstraints:self.leftButtonHeightConstraint, nil];
}
- (void)setBottomButton {
    self.dataSource = [[TJMOrderDetailData alloc]initWithOrderModel:_orderModel];
    self.rightButtonWidthConstraint.constant = TJMScreenWidth / 2;
    switch (self.orderModel.orderStatus.integerValue) {
        case 1: {
            
        } break;
        case 2: {
            [self.leftYellowButton setTitle:@"确认取货" forState:UIControlStateNormal];
            [self.rightWhiteButton setTitle:@"地图导航" forState:UIControlStateNormal];
        } break;
        case 3: {
            [self.leftYellowButton setTitle:@"确认送达" forState:UIControlStateNormal];
            [self.rightWhiteButton setTitle:@"地图导航" forState:UIControlStateNormal];
        } break;
        case 4: {
            self.rightButtonWidthConstraint.constant = TJMScreenWidth;
            [self.rightWhiteButton setTitle:@"已完成" forState:UIControlStateNormal];
        } break;
        case 5: {
            self.rightButtonWidthConstraint.constant = TJMScreenWidth;
            [self.rightWhiteButton setTitle:@"已取消" forState:UIControlStateNormal];
        } break;
        case 6: {
            self.rightButtonWidthConstraint.constant = TJMScreenWidth;
            [self.rightWhiteButton setTitle:@"异常订单" forState:UIControlStateNormal];
        } break;
        case 7: {
            self.rightButtonWidthConstraint.constant = 0;
            [self.leftYellowButton setTitle:@"商家确认" forState:UIControlStateNormal];
        } break;
        default:
            break;
    }
}

#pragma  mark - 拨打电话
- (void)callWithTel:(NSString *)tel {
    //点击拨打电话
    [TJMHUDHandle showRequestHUDAtView:self.view message:nil];
    NSMutableString *str=[[NSMutableString alloc] initWithFormat:@"tel:%@",tel];
    UIWebView *callWebview = [[UIWebView alloc] init];
    callWebview.delegate = self;
    [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:str]]];
    [self.view addSubview:callWebview];
}
#pragma  mark - 按钮方法

- (void)rightItemAction:(UIButton *)button {
    //点击申报异常后执行的方法
    TJMLog(@"申报异常");
    [self callWithTel:@"0592-911006"];
}
#pragma  mark 确认取货 确认收货按钮
- (IBAction)leftYellowAction:(UIButton *)sender {
    NSString *identifier;
    if (self.orderModel.type == 0) {
        if (self.orderModel.orderStatus.integerValue == 2) {
            //确认取货
            if (!self.isWorking.boolValue) {
                [TJMHUDHandle transientNoticeAtView:self.view withMessage:@"收工状态无法取货"];
                return;
            }
            identifier = @"DetailToPickUp";
        } else if (self.orderModel.orderStatus.integerValue == 3) {
            
            if (self.orderModel.payType.integerValue == 4) {
                //到付
                identifier = @"DetailToDeliveryPay";
            } else {
                //签收
                identifier = @"DetailToSignIn";
            }
            
        }
    } else {
        //代收货款 或者 商家确认 界面和 到付相同
        identifier = @"DetailToDeliveryPay";
    }
    [self performSegueWithIdentifier:identifier sender:self.orderModel];
}
- (IBAction)naviAction:(UIButton *)sender {
    if ([sender.titleLabel.text isEqualToString:@"已完成"]) {
        return;
    }
    CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(0, 0);
    if (self.orderModel.orderStatus.integerValue == 2) {
        //我到取件处的导航
        coordinate = CLLocationCoordinate2DMake(self.orderModel.consignerLat.floatValue, self.orderModel.consignerLng.floatValue);
    } else if (self.orderModel.orderStatus.integerValue == 3) {
        //我到收货处的导航
        coordinate = CLLocationCoordinate2DMake(self.orderModel.receiverLat.floatValue, self.orderModel.receiverLng.floatValue);
    }
    [[TJMLocationService sharedLocationService] getFreeManLocationWith:TJMGetLocationTypeNaviService target:coordinate];
}



#pragma  mark - UITableViewDelegate,UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataSource.data.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSArray *arr = self.dataSource.data[section];
    return arr.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TJMMyOrderDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MyOrderDetailCell" forIndexPath:indexPath];
    TJMOrderDetailInfoModel *model = self.dataSource.data[indexPath.section][indexPath.row];
    
    [cell setViewWithModel:model];
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    TJMMyOrderDetailTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    [cell setSelected:NO animated:YES];
    TJMOrderDetailInfoModel *model = self.dataSource.data[indexPath.section][indexPath.row];
    if (model.isTel) {
        [self callWithTel:model.detail];
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 50 * TJMHeightRatio;
    if (indexPath.section == 2) {
        return  50 * TJMHeightRatio;
    }
    return self.tableView.rowHeight;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 37 * TJMHeightRatio;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section == 2) {
        return 30 * TJMHeightRatio;
    }
    return 0;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return [[UIView alloc]initWithFrame:CGRectZero];
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    TJMMyOrderDetailHeaderView *header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"MyOrderDetailHeader"];
    
    switch (section) {
        case 0: {
            header.label.text = @"寄件人信息";
        } break;
        case 1: {
            header.label.text = @"收件人信息";
        } break;
        case 2: {
            header.label.text = @"订单信息";
        } break;
            
        default:
            break;
    }
    
    return header;
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat sectionHeaderHeight = 37 * TJMHeightRatio;
    if (scrollView.contentOffset.y <= sectionHeaderHeight && scrollView.contentOffset.y >= -64) {
        scrollView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0);
    } else if (scrollView.contentOffset.y >= sectionHeaderHeight) {
        scrollView.contentInset = UIEdgeInsetsMake(-sectionHeaderHeight + 64, 0, 0, 0);
    }
}

#pragma  mark - UIWebViewDelegate
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    [TJMHUDHandle hiddenHUDForView:self.view];
    return YES;
}

#pragma  mark - memory warning
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
    if ([segue.identifier isEqualToString:@"DetailToPickUp"] || [segue.identifier isEqualToString:@"DetailToDeliveryPay"] || [segue.identifier isEqualToString:@"DetailToSignIn"]) {
        [segue.destinationViewController setValue:sender forKey:@"orderModel"];
    }
}
@end
