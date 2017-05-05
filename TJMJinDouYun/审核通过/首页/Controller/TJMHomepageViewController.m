//
//  TJMHomepageViewController.m
//  TJMJinDouYun
//
//  Created by Jiaming Tu on 2017/4/18.
//  Copyright © 2017年 zhongzhichuangying. All rights reserved.
//

#import "TJMHomepageViewController.h"
#import "TJMHomeOrderTableViewCell.h"
#import "TJMHomeHeaderView.h"
@interface TJMHomepageViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) NSTimer *timer;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *imaginaryLineView;






//约束
//竖直
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *headerImageTopConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *headerImageHeightConstraint;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *workButtonTopConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *workButtonHeightConstraint;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *earningsImageTopConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *earningsImageHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *earningsImageBottomConstraint;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *workTimeImageHeightConstraint;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imaginaryLineViewTopConstraint;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *buttonCutLineHeightConstraint;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *middleCutLineHeightConstraint;
//抢单等按钮高度约束
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *buttonHeightConstraint;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *totalMoneyLabelHeightConstraint;
//水平
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *nameLabelLeftConstraint;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *workTimeImageRightConstraint;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *earningsImageRightConstraint;





@end

@implementation TJMHomepageViewController
#pragma  mark - lazy loading
- (UIButton *)naviLeftButton {
    if (!_naviLeftButton) {
        UIImage *image = [UIImage imageNamed:@"nav_btn_drop-down-"];
        UIFont *font = [UIFont systemFontOfSize:15];
        self.naviLeftButton = [[UIButton alloc]init];
        self.naviLeftButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        self.naviLeftButton.titleLabel.font = font;
        [self.naviLeftButton setTitle:@"厦门" forState:UIControlStateNormal];
        [self.naviLeftButton setTitleColor:TJMFUIColorFromRGB(0x333333) forState:UIControlStateNormal];
        [self.naviLeftButton setImage:image forState:UIControlStateNormal];
        [self.naviLeftButton addTarget:self action:@selector(itemAction:) forControlEvents:UIControlEventTouchUpInside];
        self.naviLeftButton.tag = 1100;
    }
    return _naviLeftButton;
}

#pragma  mark - view life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setFonts];
    [self resetConstraints];
    [self configViews];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

}

- (void)viewDidLayoutSubviews {
    
}

#pragma  mark - 页面配置
- (void)configViews {
    
//    self.tableView.estimatedRowHeight = 100;
    [self.tableView registerClass:[TJMHomeHeaderView class] forHeaderFooterViewReuseIdentifier:@"HomeHeader"];
    [self setNaviLeftButtonFrameWithButton:self.naviLeftButton];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc]initWithCustomView:self.naviLeftButton];
    self.navigationItem.leftBarButtonItem = leftItem;
    //设置右边导航按钮
    UIBarButtonItem *rightItem = [self setNaviItemWithImageName:@"nav_btn_heatmap" tag:1000];
    self.navigationItem.rightBarButtonItem = rightItem;
    //增加虚线
    [self constructImaginaryLineWithView:self.imaginaryLineView];
    
    
    
}

//设置左导航按钮尺寸
- (void)setNaviLeftButtonFrameWithButton:(UIButton *)button {
    
    CGFloat titleLabelInset = 10.5 * TJMWidthRatio;
    self.naviLeftButton.titleEdgeInsets = UIEdgeInsetsMake(0, -titleLabelInset, 0, titleLabelInset);
    //字的宽度 字体长度 * 字体尺寸 + （图片宽度 + UI偏移量 - titleLabel偏移量）* 比例系数
    CGFloat imageInset = button.currentTitle.length * button.titleLabel.font.pointSize + (button.currentImage.size.width + 6.5 - titleLabelInset) * TJMWidthRatio;
    self.naviLeftButton.imageEdgeInsets = UIEdgeInsetsMake(0, imageInset, 0, -imageInset);
    CGFloat width = self.naviLeftButton.currentImage.size.width + button.currentTitle.length * button.titleLabel.font.pointSize + 6.5 * TJMWidthRatio;
    CGFloat height = self.naviLeftButton.titleLabel.font.pointSize + 2;
    self.naviLeftButton.frame = CGRectMake(0, 0, width, height);
}
- (void)itemAction:(UIButton *)button {
    TJMLog(@"%zd",button.tag);
    switch (button.tag) {
        case 1000:
        {
            
        }
            break;
        case 1100:
        {
            
        }
            break;
            
        default:
            break;
    }
}

//约束
- (void)resetConstraints {
    [self resetVerticalConstraints:self.headerImageTopConstraint,self.headerImageHeightConstraint,self.workButtonTopConstraint,self.workButtonHeightConstraint,self.earningsImageTopConstraint,self.earningsImageHeightConstraint,self.earningsImageBottomConstraint,self.workTimeImageHeightConstraint,self.imaginaryLineViewTopConstraint,self.buttonCutLineHeightConstraint,self.middleCutLineHeightConstraint,self.buttonHeightConstraint,self.totalMoneyLabelHeightConstraint, nil];
    [self resetHorizontalConstraints:self.nameLabelLeftConstraint,self.workTimeImageRightConstraint,self.earningsImageRightConstraint, nil];
}
//设置字体
- (void)setFonts {
    [self adjustFont:16 forView:self.nameLabel, nil];
    [self adjustFont:13 forView:self.currentStatusLabel,self.statusLabel, nil];
    [self adjustFont:18 forView:self.workButton, nil];
    [self adjustFont:12 forView:self.todayEarningsLabel,self.workTimeLabel, nil];
    [self adjustFont:15 forView:self.totalTimeLabel,self.totalMoneyLabel,self.rabOrderButton,self.waitFetchButton,self.waitSendButton, nil];
}

#pragma  mark - UITableViewDelegate,UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TJMHomeOrderTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"OrderCell" forIndexPath:indexPath];
    
    return cell;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    TJMHomeHeaderView *header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"HomeHeader"];
    
    
    return header;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 50 * TJMHeightRatio;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 271 * TJMHeightRatio;
    return self.tableView.rowHeight;
}


#pragma  mark - memory warning
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
