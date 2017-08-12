//
//  FriendListVC.m
//  NewApp
//
//  Created by gxtc on 17/3/14.
//  Copyright © 2017年 gxtc. All rights reserved.
//

#import "FriendListVC.h"
#import "myPrenticeCell.h"

#define SCREEN_H [UIScreen mainScreen].bounds.size.height
#define SCREEN_W [UIScreen mainScreen].bounds.size.width

@interface FriendListVC ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong)UITableView * tableView;

@property(nonatomic,strong)NSMutableArray * dataArray;

@property(nonatomic,assign)NSInteger page;


@property(nonatomic,assign)BOOL isRefresh;

@end

@implementation FriendListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor =[UIColor whiteColor];
    self.page = 1;
    
    self.dataArray = [NSMutableArray new];
    
    [self addUI];
    
    [self tableViewCreat];
    
}



- (void)addUI{

    [super addUI];

    self.titleLabel.text = @"徒弟列表";
}




- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
}

- (void)MJ_refreshData{
    
    self.isRefresh = YES;
    self.page = 1;
    
    [self myPrenticeListFromNet:self.page];
    
}


- (void)MJ_loadMoreData{
    
    self.isRefresh = NO;
    self.page ++;
    [self myPrenticeListFromNet:self.page];
    
    
}



- (void)myPrenticeListFromNet:(NSInteger)page{
    
    NetWork * net = [NetWork shareNetWorkNew];
    
    [net fiendListFromNetWithPage:page];
    
    __weak FriendListVC * weakSelf = self;
    
    net.frientListBK=^(NSString * code,NSString * message,NSString * str,NSArray * dataArray,NSArray * arr){
    
        if (dataArray.count > 0) {
           
            if (self.isRefresh) {
                
                weakSelf.dataArray = [NSMutableArray arrayWithArray:dataArray];
                
            }else{
            
            
                [weakSelf.dataArray addObjectsFromArray:dataArray];
                

            }
            
            [weakSelf.tableView reloadData];

            
           
            
        }
        
        [weakSelf.tableView.mj_header endRefreshing];
        [weakSelf.tableView.mj_footer endRefreshing];
    
    };
}



- (void)tableViewCreat{
    
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, SCREEN_W, SCREEN_H-64) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.rowHeight = SCREEN_W/5;
    self.tableView.tableFooterView = [[UIView alloc]init];
    self.tableView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.tableView];
    
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(MJ_refreshData)];
    
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(MJ_loadMoreData)];

    [self.tableView.mj_header beginRefreshing];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.dataArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    myPrenticeCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    if (cell == nil) {
        
        cell = [[myPrenticeCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    FriendListModel * model = self.dataArray[indexPath.row];
    
    cell.model = model;
    return cell;
}

@end
