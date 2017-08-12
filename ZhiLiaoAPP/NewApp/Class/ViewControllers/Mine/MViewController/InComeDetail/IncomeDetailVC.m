//
//  IncomeDetailVC.m
//  NewApp
//
//  Created by gxtc on 17/2/23.
//  Copyright © 2017年 gxtc. All rights reserved.
//

#import "IncomeDetailVC.h"

@interface IncomeDetailVC ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,assign)NSInteger page;
@property (nonatomic,strong)UITableView * tableView;
@property (nonatomic,strong)NSMutableArray * dataArray;

@property (nonatomic,strong)ProfitMemberModel * memberModel ;

@property (nonatomic,assign)BOOL isMJRefresh;


/**今日已获得收益*/
@property(nonatomic,strong)UILabel * todayIncom;
/**今日广告分成*/
@property(nonatomic,strong)UILabel * todayAdcIncom;

/**昨日收入*/
@property(nonatomic,strong)UILabel * yestodayIncom;

/**昨日广告分成*/
@property(nonatomic,strong)UILabel * yestodayAdvIncom;

/**我的收入*/
@property(nonatomic,strong)UILabel * sum_money;

@end

@implementation IncomeDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.page = 1;
    self.isMJRefresh = YES;
    self.dataArray = [NSMutableArray new];
    
    [self addUI];
    
}

- (void)addUI{
    [super addUI];
    self.titleLabel.text = @"收支明细";
    [self addRightBarButtonNew];
    
    [self tableViewNew:[self addTableHeadViewNew]];
}

- (void)rightBarButtonAction{

    NSLog(@"晒晒");
    
    ShaiShaiMyIncomeVC * vc = [[ShaiShaiMyIncomeVC alloc]init];
    
    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];

}



/**收益明细*/
- (void)getProfitDetailFromNet{

    NetWork * net = [NetWork shareNetWorkNew];

    [net profitDetailFromNetWithPage:self.page];
    
    __weak IncomeDetailVC * weakSelf =self;
    
    net.profitDetailBK=^(NSString * code,NSString * messgae,NSString * str,NSArray * dataArray,NSArray * member){
    
        
        if (weakSelf.isMJRefresh) {
            
        
        
            if (member.count > 0) {
            
                
//                weakSelf.memberModel = member[0];
            
                ProfitMemberModel * model = member[0];
                
                
                weakSelf.sum_money.text = [NSString stringWithFormat:@"￥%@",model.sum_money];
                
                weakSelf.todayIncom.attributedText =  [weakSelf addRootAppandAttributedText1:model.today_income andText2:@"元" andColor1:[UIColor redColor] andColor2:[UIColor lightGrayColor] andFont1:20 andFont2:12 ];
                
                weakSelf.yestodayIncom.attributedText = [weakSelf addRootInsertAttributedText1:@"昨日收入:元" andText2:model.yesterDay_income  andIndex:5 andColor1:[UIColor lightGrayColor] andColor2:[UIColor redColor] andFont1:15.0 andFont2:16.0];
                
                
                weakSelf.todayAdcIncom.attributedText =  [weakSelf addRootAppandAttributedText1:model.today_gg andText2:@"元" andColor1:[UIColor redColor] andColor2:[UIColor lightGrayColor] andFont1:20 andFont2:12 ];
                
                weakSelf.yestodayAdvIncom.attributedText = [weakSelf addRootInsertAttributedText1:@"昨日分成:元" andText2:model.yesterDay_gg andIndex:5 andColor1:[UIColor lightGrayColor] andColor2:[UIColor redColor] andFont1:15.0 andFont2:16.0];
                
            }
        
        
        
            if (dataArray.count > 0) {
            
                weakSelf.dataArray = [NSMutableArray arrayWithArray:dataArray];
            
            }
        
        }else{
        
            if (member.count > 0) {
                
                weakSelf.memberModel = member[0];
                
            }
            
            
            
            if (dataArray.count > 0) {
                
                [weakSelf.dataArray addObjectsFromArray:dataArray];
                
            }

        
        
        }
        
        [weakSelf.tableView reloadData];
        [weakSelf.tableView.mj_header endRefreshing];
        [weakSelf.tableView.mj_footer endRefreshing];
        
    };
}





- (void)MJreloadData{
    self.isMJRefresh = YES;
    self.page = 1;
    [self getProfitDetailFromNet];
}



- (void)MJLoadMoreData{
    
    self.isMJRefresh = NO;
    self.page ++;
    [self getProfitDetailFromNet];
}



- (void)tableViewNew:(UIView *)headView{
    UITableView * tableView = [[UITableView alloc]initWithFrame:CGRectMake(0,64, ScreenWith, ScreenHeight - 64 ) style:UITableViewStyleGrouped];
    tableView.showsVerticalScrollIndicator = NO;
    tableView.rowHeight = ScreenWith/9;
    tableView.dataSource = self;
    tableView.delegate = self;
    tableView.tableHeaderView = headView;
    self.tableView = tableView;
    [self.view addSubview:tableView];
    
    
    tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(MJreloadData)];
    tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(MJLoadMoreData)];
    [tableView.mj_header beginRefreshing];

}


- (UIView *)addTableHeadViewNew{
    
    UIView * view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWith, ScreenWith)];

    UIImageView * imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, ScreenWith, ScreenWith* 3/7)];
    imageView.image = [UIImage imageNamed:@"user_task_bg"];
    [view addSubview:imageView];
    
    UILabel * Mine = [self addRootLabelWithfram:CGRectMake(0, ScreenWith *3/14 - ScreenWith/10, ScreenWith, ScreenWith/10) andTitleColor:[UIColor whiteColor] andFont:25.0 andBackGroundColor:[UIColor clearColor] andTitle:@"我的收入"];
    Mine.textAlignment = NSTextAlignmentCenter;
    
    UILabel * allMoney = [self addRootLabelWithfram:CGRectMake(0, ScreenWith*3/14 + 5, ScreenWith, ScreenWith/8) andTitleColor:[UIColor whiteColor] andFont:35.0 andBackGroundColor:[UIColor clearColor] andTitle:@"￥0.00"];
    allMoney.textAlignment = NSTextAlignmentCenter;
    self.sum_money = allMoney;
    
    
    [imageView addSubview:Mine];
    [imageView addSubview:allMoney];
    
    
    UIView * cub1 = [[UIView alloc]initWithFrame:CGRectMake(0, ScreenWith * 3/7, ScreenWith/2, ScreenWith * 4/7)];
    cub1.backgroundColor = [UIColor whiteColor];
    
    UILabel * cub1Label1 = [self addRootLabelWithfram:CGRectMake(0, 0, ScreenWith/2, ScreenWith*4/21) andTitleColor:[UIColor lightGrayColor] andFont:16 andBackGroundColor:[UIColor clearColor] andTitle:@"今日已获得收益:"];
    cub1Label1.textAlignment = NSTextAlignmentCenter;
    [cub1 addSubview:cub1Label1];

    
    
    
    NSMutableAttributedString * cub1attStr1 = [self addRootAppandAttributedText1:@"0.00" andText2:@"元" andColor1:[UIColor redColor] andColor2:[UIColor lightGrayColor] andFont1:20 andFont2:12 ];
    UILabel * cub1Label2 = [[UILabel alloc]initWithFrame:CGRectMake(0, ScreenWith*4/21, ScreenWith/2, ScreenWith*4/21)];
    cub1Label2.attributedText = cub1attStr1;
    cub1Label2.textAlignment = NSTextAlignmentCenter;
    [cub1 addSubview:cub1Label2];
    self.todayIncom = cub1Label2;
    
    
    
    NSMutableAttributedString * cub1attStr2 = [self addRootInsertAttributedText1:@"昨日收入:元" andText2:@"0.00" andIndex:5 andColor1:[UIColor lightGrayColor] andColor2:[UIColor redColor] andFont1:15.0 andFont2:16.0];
    UILabel * cub1Label3 = [[UILabel alloc]initWithFrame:CGRectMake(0, ScreenWith*8/21, ScreenWith/2, ScreenWith*4/21)];
    cub1Label3.attributedText = cub1attStr2;
    cub1Label3.textAlignment = NSTextAlignmentCenter;
    [cub1 addSubview:cub1Label3];
    self.yestodayIncom = cub1Label3;
    
    
    
    UIView * cub2 = [[UIView alloc]initWithFrame:CGRectMake(ScreenWith/2, ScreenWith * 3/7, ScreenWith/2, ScreenWith * 4/7)];
    cub2.backgroundColor = [UIColor whiteColor];

    UILabel * cub2Label1 = [self addRootLabelWithfram:CGRectMake(0, 0, ScreenWith/2, ScreenWith*4/21) andTitleColor:[UIColor lightGrayColor] andFont:16 andBackGroundColor:[UIColor clearColor] andTitle:@"今日分成:"];
    cub2Label1.textAlignment = NSTextAlignmentCenter;
    [cub2 addSubview:cub2Label1];
    
    
    NSMutableAttributedString * cub2attStr1 = [self addRootAppandAttributedText1:@"0.00" andText2:@"元" andColor1:[UIColor redColor] andColor2:[UIColor lightGrayColor] andFont1:20 andFont2:12 ];
    
    UILabel * cub2Label2 = [[UILabel alloc]initWithFrame:CGRectMake(0, ScreenWith*4/21, ScreenWith/2, ScreenWith*4/21)];
    cub2Label2.attributedText = cub2attStr1;
    cub2Label2.textAlignment = NSTextAlignmentCenter;
    [cub2 addSubview:cub2Label2];
    self.todayAdcIncom = cub2Label2;
    
    
    NSMutableAttributedString * cub2attStr2 = [self addRootInsertAttributedText1:@"昨日分成:元" andText2:@"0.00" andIndex:5 andColor1:[UIColor lightGrayColor] andColor2:[UIColor redColor] andFont1:15.0 andFont2:16.0];
    UILabel * cub2Label3 = [[UILabel alloc]initWithFrame:CGRectMake(0, ScreenWith*8/21, ScreenWith/2, ScreenWith*4/21)];
    cub2Label3.attributedText = cub2attStr2;
    cub2Label3.textAlignment = NSTextAlignmentCenter;
    cub2Label3.numberOfLines = 0;
    [cub2 addSubview:cub2Label3];
    self.yestodayAdvIncom = cub2Label3;
    
    [view addSubview:cub1];
    [view addSubview:cub2];
    
    
    UIView * line = [[UIView alloc]initWithFrame:CGRectMake(ScreenWith/2 - 0.5, CGRectGetMaxY(imageView.frame) + ScreenWith/15, 1, ScreenWith * 3 /7)];
    line.backgroundColor =[ UIColor blackColor];
    [view addSubview:line];
    
    
    return view;
}


- (UILabel *)dataDetail:(NSString *)title andMoney1:(NSString *)money andLabelFram:(CGRect)fram{

    
    UILabel * achive = [[UILabel alloc]initWithFrame:fram];

    return achive;
}




#pragma mark- tableViewDelegate
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell_zero"];
        if (cell == nil) {
            
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell_zero"];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
        
        cell.imageView.image = [UIImage imageNamed:@"ic_money"];
        
        cell.textLabel.text = @"赚钱技巧";
        cell.textLabel.font = [UIFont systemFontOfSize:16];
        
        return cell;

    }else{
        IncomeDetailCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
        if (cell == nil) {
            
            cell = [[IncomeDetailCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        
        ProfitDetailModel * model = self.dataArray[indexPath.row];
        
        cell.model = model;
        
        return cell;

    }
    
    
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
        return ScreenWith/8;
    
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (section == 0) {
        return 1;
    }else{
    
        return self.dataArray.count;
    }
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 2;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 0) {
        
        WKWebViewController * vc = [[WKWebViewController alloc]init];
        vc.isNewTeach = YES;
        vc.isPost = NO;
        vc.urlString = [NSString stringWithFormat:@"%@/App/Index/make_money",DomainURL];
        self.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }
    
    
//    [tableView beginUpdates];
//    [tableView endUpdates];
    
}

#pragma mark- 分组高度
//section头部间距
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    
    if (section == 0) {
        return 5;//section头部高度
        
    }else{
        return 40.0;//section头部高度
        
    }
}


//section头部视图
- (UIView * )tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    NSArray * titles = @[@"日常操作",@"金币/次",@"人民币"];
    
    if (section == 1){
        UIView * view=[[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWith, 40)];
        view.backgroundColor = [UIColor whiteColor];
        
        UILabel * label=[[UILabel alloc] initWithFrame:CGRectMake(0, 0, ScreenWith/2, 20)];
        label.backgroundColor = [UIColor whiteColor];
        label.text = @"     收支明细";
        label.font = [UIFont systemFontOfSize:14];
        label.textColor = [UIColor blackColor];
        [view addSubview:label];

        for (int i = 0; i < 3; i++) {
        UILabel * label2=[[UILabel alloc] initWithFrame:CGRectMake(ScreenWith/3 * i, 20, ScreenWith/3, 20)];
        label2.backgroundColor = [UIColor whiteColor];
        label2.text = titles[i];
        label2.font = [UIFont systemFontOfSize:13];
        label2.textColor = [UIColor blackColor];
        label2.textAlignment = NSTextAlignmentCenter;
        [view addSubview:label2];
        }
        return view ;
        
    }else{
        UIView * view=[[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWith, 5)];
        view.backgroundColor = [UIColor clearColor];
        return view ;
    }
    
}


//section底部间距
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
        return 5.0;
    
}
//section底部视图
- (UIView * )tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    
    UIView * view=[[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWith, 1)];
    view.backgroundColor = [UIColor clearColor];
    return view;
}





@end

