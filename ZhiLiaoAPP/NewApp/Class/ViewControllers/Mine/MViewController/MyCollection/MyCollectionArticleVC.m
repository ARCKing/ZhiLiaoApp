//
//  MyCollectionArticleVC.m
//  NewApp
//
//  Created by gxtc on 17/2/22.
//  Copyright © 2017年 gxtc. All rights reserved.
//

#import "MyCollectionArticleVC.h"

@interface MyCollectionArticleVC ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong)NSMutableArray * dataArray;

@property (nonatomic,strong)UITableView * tableView;

@end

@implementation MyCollectionArticleVC


- (void)viewWillAppear:(BOOL)animated{

    [super viewWillAppear:animated];

}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.dataArray = [NSMutableArray new];
    
    [self addUI];
    
    [self getdataFromNet];
}


- (void)addUI{
    [super addUI];
    self.titleLabel.text = @"我的收藏";
    
    [self tableViewNew];
}


- (void)getdataFromNet{

    MBProgressHUD * hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
//    hud.mode = MBProgressHUDModeText;
//    hud.label.text = message;
//    [hud hideAnimated:YES afterDelay:2.f];
    
    NetWork * net = [NetWork shareNetWorkNew];
    
    [net userAllCollectionArticleList];
    
    __weak MyCollectionArticleVC * weakSelf = self;
    
    net.userArticleCollectionListBK = ^(NSString * code,NSString * message,NSString * str ,NSArray * dataArray,NSArray * data){
    
        weakSelf.dataArray = [NSMutableArray arrayWithArray:dataArray];
        
        [weakSelf.tableView reloadData];
        
        [hud hideAnimated:YES];
        

    };

}


- (void)tableViewNew{
    UITableView * tableView = [[UITableView alloc]initWithFrame:CGRectMake(0,64, ScreenWith, ScreenHeight - 64 ) style:UITableViewStylePlain];
    tableView.showsVerticalScrollIndicator = NO;
    tableView.rowHeight = ScreenWith/4 + 20;
    tableView.dataSource = self;
    tableView.delegate = self;
    tableView.tableFooterView = [[UIView alloc]init];
    self.tableView = tableView;
    [self.view addSubview:tableView];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    MineOneTypeCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    if (cell == nil) {
        
        cell = [[MineOneTypeCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        
    }
    
    ArticleListModel * model = self.dataArray[indexPath.row];
    
    cell.articleListModel = model;
    
    
    return cell;
    
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.dataArray.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    ArticleListModel * model = self.dataArray[indexPath.row];
    
    WKWebViewController * web = [[WKWebViewController alloc]init];
    web.article_id = [NSString stringWithFormat:@"%d",model.id];
    web.isPost = NO;
    web.articleModel = model;
    
    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:web animated:YES];

    
}


@end
