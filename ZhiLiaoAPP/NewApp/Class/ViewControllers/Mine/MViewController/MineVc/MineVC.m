//
//  MineVC.m
//  NewApp
//
//  Created by gxtc on 17/2/13.
//  Copyright © 2017年 gxtc. All rights reserved.
//

#import "MineVC.h"

@interface MineVC ()<UITableViewDelegate,UITableViewDataSource>

/**
 *cell的UI数组
 */
@property (nonatomic,strong)NSArray<NSArray *> * SectionsTitleArray;
@property (nonatomic,strong)NSArray<NSArray *> * SectionsIconArray;

/**
 *
 */
@property (nonatomic,strong)UIScrollView * loginOrUnLoginScrollView;


@property (nonatomic,strong)MineDataSourceModel * mineModel;
@property (nonatomic,strong)UILabel * goldLabel;
@property (nonatomic,copy)NSString * goldMoney;
@property (nonatomic,strong)UITableView * tableView;


@property (nonatomic,copy)NSString * uid;
@property (nonatomic,copy)NSString * token;
@property (nonatomic,copy)NSString * isLogin;

//邀请好友得**金币
@property (nonatomic,copy)NSString * inviateCoin;
@property (nonatomic,strong)UILabel * inviateCoinlb;


@property (nonatomic,assign)BOOL hiddenCell;

@end

@implementation MineVC



- (void)viewWillAppear:(BOOL)animated{

    [super viewWillAppear:animated];

    [self isLoginState];
    
    [self getTokenAndUid];
    
    [self MJReloadData];
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.hiddenCell = NO;
    
    
    [self addUI];
    [self dataSource];
    
//    [self getMineDataSourceFromNet];
    
}




- (void)getTokenAndUid{
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    NSDictionary * userInfo = [defaults objectForKey:@"userInfo"];
    self.uid = userInfo[@"uid"];
    self.token = userInfo[@"token"];
    self.isLogin = userInfo[@"login"];
}




#pragma mark- MJReloadData
/**下拉刷新*/
- (void)MJReloadData{

    [self getMineDataSourceFromNet];

}


#pragma mark- 我的信息
- (void)getMineDataSourceFromNet{

    
    NSDictionary * userDic = [[NSUserDefaults standardUserDefaults] objectForKey:@"userInfo"];
    
    NSString * login = userDic[@"login"];
    
    
    if (![login isEqualToString:@"1"]) {
        
        [self.tableView.mj_header endRefreshing];

        
        return;
    }
    NetWork * net = [NetWork shareNetWorkNew];
    
    [net getMineDataSource];
    
    __weak MineVC * weakSelf = self;
    
    net.mineDataSourceBK=^(NSString * code,NSString * message,NSString * str,NSArray * dataArray,NSArray * arr){
    
        if (dataArray.count > 0) {
            
            weakSelf.mineModel = dataArray[0];
            
            weakSelf.goldMoney = weakSelf.mineModel.residue_money;
            
        }
        
        if (weakSelf.mineModel) {
            
            /*
            if ([weakSelf.mineModel.type isEqualToString:@"1"]) {
                
                weakSelf.hiddenCell = NO;
                
            }else{
            
                weakSelf.hiddenCell = YES;
            }
             */
            
            
            weakSelf.inviateCoin = weakSelf.mineModel.prentice;
            
            CoreDataManger * CDManger = [CoreDataManger shareCoreDataManger];
            
            BOOL isDelete = [CDManger deleteMineDataSource];
            
            if (isDelete) {
                
                [CDManger insertMineDataWithMineDataModel:weakSelf.mineModel];
                
                [weakSelf checkMineDataFromCoreData];
            }
            
        }
        
        
        [weakSelf.tableView.mj_header endRefreshing];
        
    };

}


#pragma mark- 检查我的本地信息
/**检查我的本地信息*/
- (void)checkMineDataFromCoreData{

    CoreDataManger * CDManger = [CoreDataManger shareCoreDataManger];
    
    MineDataSourceModel * model = [CDManger checkMineDataSource];
    
    if (model) {
        
        self.goldMoney = model.residue_money;

        self.mineModel = model;
        
        [self.tableView reloadData];
        
        
    }else{
    
        [self getMineDataSourceFromNet];

    }
    
    
}

#pragma mark- 登录状态
- (void)isLoginState{

    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    NSDictionary * dic = [defaults objectForKey:@"userInfo"];
    
    if ([dic[@"login"] isEqualToString:@"1"]) {
        self.loginOrUnLoginScrollView.userInteractionEnabled = NO;
        self.loginOrUnLoginScrollView.contentOffset = CGPointMake(0, 0);
        
        [self checkMineDataFromCoreData];
        
    }else{
        self.loginOrUnLoginScrollView.userInteractionEnabled = YES;
        self.loginOrUnLoginScrollView.contentOffset = CGPointMake(ScreenWith, 0);
        self.goldLabel.text = @"";
    }

}


- (void)addUI{
    
    self.navigationBarView = [self NavBarViewNew];
    self.navigationBarView.backgroundColor =[UIColor whiteColor];
    [self addTitleLabelNew];
    self.titleLabel.text = @"我的";
    [self addLineNew];
    [self tableViewNew];

}


- (void)dataSource{

    NSArray * titleArray0 = @[@"用户"];
    NSArray * titleArray1 = @[@"邀请好友",@"输入邀请码"];
    NSArray * titleArray2 = @[@"我的消息", @"我的收藏",@"历史阅读"];
    NSArray * titleArray3 = @[@"任务中心",@"收支明细",@"兑换中心"];
    NSArray * titleArray4 = @[@"新手指南", @"有奖反馈", @"设置"];
    
    NSArray * iconImageArray0=@[@""];
    NSArray * iconImageArray1=@[@"",@""];
    NSArray * iconImageArray2=@[@"",@"",@""];
    NSArray * iconImageArray3=@[@"",@"",@""];
    NSArray * iconImageArray4=@[@"",@"",@""];


    self.SectionsTitleArray = [NSArray arrayWithObjects:titleArray0,titleArray1, titleArray2,titleArray3,titleArray4,nil];
    
    self.SectionsIconArray = [NSArray arrayWithObjects:iconImageArray0,iconImageArray1,iconImageArray2,iconImageArray3,iconImageArray4, nil];
    
}

#pragma mark- tableViewNew

- (void)tableViewNew{
    UITableView * tableView = [[UITableView alloc]initWithFrame:CGRectMake(0,64, ScreenWith, ScreenHeight - 64 - 49) style:UITableViewStyleGrouped];
    tableView.showsVerticalScrollIndicator = NO;
    tableView.dataSource = self;
    tableView.delegate = self;
    
    [self.view addSubview:tableView];
    
    self.tableView = tableView;
    
    
//    tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(MJReloadData)];
    
    MJRefreshNormalHeader * MJ_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(MJReloadData)];
    
    MJ_header.stateLabel.textColor =[UIColor colorWithRed:0.0 green:207.0/255.0 blue:1.0 alpha:1.0];
    
    MJ_header.lastUpdatedTimeLabel.textColor = [UIColor colorWithRed:0.0 green:207.0/255.0 blue:1.0 alpha:1.0];
    
    tableView.mj_header = MJ_header;
    
    
//    [tableView.mj_header beginRefreshing];
}

/**
 *登录注册
 */
- (void)loginButtonAction{

    NSLog(@"登录注册");
    LoginViewController * vc = [[LoginViewController alloc]init];
    
    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
    self.hidesBottomBarWhenPushed = NO;
}

#pragma mark- tableViewDelegate
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        
        SectionZeroUserCell * cell = [tableView dequeueReusableCellWithIdentifier:@"sectionZero"];
        if (cell == nil) {
            cell = [[SectionZeroUserCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"sectionZero"];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            [cell.loginBt addTarget:self action:@selector(loginButtonAction) forControlEvents:UIControlEventTouchUpInside];
            self.loginOrUnLoginScrollView = cell.scrollView;
            
            
            NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
            NSDictionary * dic = [defaults objectForKey:@"userInfo"];
            
            if ([dic[@"login"] isEqualToString:@"1"]) {
                //cell响应关键
                cell.scrollView.userInteractionEnabled = NO;
            }else{
                //cell响应关键
                cell.scrollView.userInteractionEnabled = YES;
                cell.scrollView.contentOffset = CGPointMake(ScreenWith, 0);
            }
            
        }
        
        if (self.mineModel) {
        
            [cell.userIconImage sd_setImageWithURL:[NSURL URLWithString:self.mineModel.headimgurl] placeholderImage:[UIImage imageNamed:@"head_icon"]];
            
            
            if ([self.mineModel.nickname isEqualToString:@"(null)"]) {
                
                cell.nameLabel.text = self.mineModel.username;
                
            }else{
                
                cell.nameLabel.text = self.mineModel.nickname;
            }
            
            if ([self.mineModel.sex isEqualToString:@"1"]) {
            
                cell.sex.image = [UIImage imageNamed:@"sex_male"];
            }else{
                cell.sex.image = [UIImage imageNamed:@"sex_woman"];

            }
            
            cell.lvLabel.text = [NSString stringWithFormat:@"LV%@",self.mineModel.level];
            [cell.lvLabel sizeToFit];
            
            NSString * redCount = self.mineModel.today_read;
            
            cell.todayReadLabel.attributedText = [cell addCellInsertAttributedText1:@"今日阅读篇" andText2:redCount andIndex:4 andColor1:[UIColor blackColor] andColor2:[UIColor cyanColor] andFont2:14.0 andFont2:14.0];
            [cell.todayReadLabel sizeToFit];
            
            cell.todayReadLabel.center = CGPointMake(25 + cell.todayReadLabel.bounds.size.width/2 + ScreenWith/4 - 30, ScreenWith/5 - 10);

            
            cell.totalReadLabel.text = [NSString stringWithFormat:@"总阅读%@篇",self.mineModel.sum_read];
            cell.totalReadLabel.center = CGPointMake(cell.todayReadLabel.center.x + ScreenWith/6 + 10 + cell.todayReadLabel.bounds.size.width/2,cell.todayReadLabel.center.y);
        }
        
        return cell;
        
    }else{
    
        
        NSArray * iconArray1 = @[@"index_invite",@"ic_edit_comment_grey"];
        NSArray * iconArray2 = @[@"ic_message",@"ic_collect",@"ic_history"];
        NSArray * iconArray3 = @[@"ic_task",@"ic_io_detail",@"index_exchange"];
        NSArray * iconArray4 = @[@"ic_tutorial",@"ic_question",@"ic_set_up"];

        
        
        MineOneCell * cell = [tableView dequeueReusableCellWithIdentifier:[NSString stringWithFormat:@"cell_%ld_%ld",indexPath.section,indexPath.row]];
        if (cell == nil) {
            cell = [[MineOneCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:[NSString stringWithFormat:@"cell_%ld_%ld",indexPath.section,indexPath.row]];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
            NSArray * title = self.SectionsTitleArray[indexPath.section];
            NSArray * image = self.SectionsIconArray[indexPath.section];
            
            [cell addIcon:image[indexPath.row] andTitle:title[indexPath.row]];
        
            if (indexPath.section == 3 && indexPath.row == 0) {
                
//                UIImageView * new = [self addCellLittleRightIcon];
//                [cell.contentView addSubview:new];
            }
            
            if (indexPath.section == 1 && indexPath.row == 0) {
                
                
                
                NSAttributedString * att = [self addAppandRootAttributedText:@"邀请好友获得" andArticleNum:@"*金币" andColor1:[UIColor orangeColor] andColor2:[UIColor redColor]];
                
                UILabel * label  = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 10, 10)];
                label.attributedText = att;
                [label sizeToFit];
                label.center = CGPointMake(ScreenWith - label.frame.size.width/2 - 30, ScreenWith/16);
                [cell.contentView addSubview:label];
                
                self.inviateCoinlb = label;
            }
            
            
            
            
            
            if (indexPath.section ==1) {
                
                cell.iconImageView.image =[ UIImage imageNamed:iconArray1[indexPath.row]];
            }else if (indexPath.section == 2){
                cell.iconImageView.image =[ UIImage imageNamed:iconArray2[indexPath.row]];

            
            }else if (indexPath.section == 3){
                cell.iconImageView.image =[ UIImage imageNamed:iconArray3[indexPath.row]];

            }else if (indexPath.section == 4){
                cell.iconImageView.image =[ UIImage imageNamed:iconArray4[indexPath.row]];
                
            }
            
        }
        
        
        if (indexPath.section == 1 && indexPath.row == 0) {
        
            
            NSString * moneyCoin = @"*金币";
            
            if (self.inviateCoin != nil) {
                
                moneyCoin = [NSString stringWithFormat:@"%@金币",self.inviateCoin];
            }
            
            
            self.inviateCoinlb.attributedText = [self addAppandRootAttributedText:@"邀请好友获得" andArticleNum:moneyCoin andColor1:[UIColor orangeColor] andColor2:[UIColor redColor]];
            
            [self.inviateCoinlb sizeToFit];
            self.inviateCoinlb.center = CGPointMake(ScreenWith - self.inviateCoinlb.frame.size.width/2 - 30, ScreenWith/16);
        }
        
        
        
        
        if (indexPath.section == 3 && indexPath.row == 1) {
            

            if (self.goldMoney) {
                [cell showUserGoldAmount:self.goldMoney];
                self.goldLabel = cell.goldLabel;
            }
            
        }

        return cell;
    }
}

/**
 *添加cell的小图+文字
 */
- (UILabel *)addAttributedText1:(NSString *)str1 andtext2:(NSString *)str2{
    
    NSString * str = [NSString stringWithFormat:@"%@%@",str1,str2];
    NSMutableAttributedString * attributrdString1 = [[NSMutableAttributedString alloc]initWithString:str];
    
    NSRange range1 = [str rangeOfString:str];
    
    [attributrdString1 addAttribute:NSForegroundColorAttributeName value:[UIColor lightGrayColor] range:NSMakeRange(0, range1.length - 2)];
    
    [attributrdString1 addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(range1.length - 2,2)];
    
    [attributrdString1 addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14] range:NSMakeRange(0, range1.length)];
   
    UILabel * label  = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 10, 10)];
    label.attributedText = attributrdString1;
    [label sizeToFit];
    label.center = CGPointMake(ScreenWith - label.frame.size.width/2 - 30, ScreenWith/16);
    return label;
}

- (UIImageView *)addCellLittleRightIcon{
    UIImageView * imageV = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"new"]];
    imageV.frame = CGRectMake(ScreenWith - 60, (ScreenWith/8 - 33)/2, 33, 33);
    return imageV;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    if (indexPath.row == 0 && indexPath.section == 0) {
        
        return ScreenWith/4;
    }else{
    
        return ScreenWith/8;
    }

}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{


    return self.SectionsTitleArray.count;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    
    if (self.hiddenCell == YES) {
        
        if (section == 1) {
            
            return 0;
            
        }else if (section == 3){
            
            return 0;
            
        }else{
            
            return self.SectionsTitleArray[section].count;

        }
        
    }else{
    
    
        return self.SectionsTitleArray[section].count;
        
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSLog(@"点击了section=%ld row=%ld",indexPath.section,indexPath.row);
    
    if (indexPath.section == 0 && indexPath.row == 0) {
    
        
        if (![self.isLogin isEqualToString:@"1"]) {
            
            [self goToLogineVC];
            
            return;
        }
        
        
        SetUserDataVC * vc = [[SetUserDataVC alloc]init];
        vc.title = @"我的资料";
        self.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
        self.hidesBottomBarWhenPushed = NO;
        
    }else if (indexPath.section == 1 && indexPath.row == 0) {
        
        if (![self.isLogin isEqualToString:@"1"]) {
            
            [self goToLogineVC];
            
            return;
        }
        
        InviateFriendTypeTwoVC * vc = [[InviateFriendTypeTwoVC alloc]init];
        self.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
        self.hidesBottomBarWhenPushed = NO;
        
    }else if (indexPath.section == 1 && indexPath.row == 1) {
        
        if (![self.isLogin isEqualToString:@"1"]) {
            
            [self goToLogineVC];
            
            return;
        }
        
        InviateCodeVC * vc = [[InviateCodeVC alloc]init];
        self.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
        self.hidesBottomBarWhenPushed = NO;
        
    }else if (indexPath.section == 2 && indexPath.row == 0) {
        
        MineMessageVC * vc = [[MineMessageVC alloc]init];
        vc.title = @"我的消息";
        self.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
        self.hidesBottomBarWhenPushed = NO;
        
    }else if (indexPath.section == 2 && indexPath.row == 1) {
        
        if (![self.isLogin isEqualToString:@"1"]) {
            
            [self goToLogineVC];
            
            return;
        }
        
        MyCollectionArticleVC * vc = [[MyCollectionArticleVC alloc]init];
        vc.title = @"我的消息";
        self.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
        self.hidesBottomBarWhenPushed = NO;

    }else if (indexPath.section == 2 && indexPath.row == 2) {
        
        HistoryReadVC * vc = [[HistoryReadVC alloc]init];
        self.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
        self.hidesBottomBarWhenPushed = NO;

    }else if (indexPath.section == 3 && indexPath.row == 0) {
        
        if (![self.isLogin isEqualToString:@"1"]) {
            
            [self goToLogineVC];
            
            return;
        }
        
        TestCenterVC * vc = [[TestCenterVC alloc]init];
        self.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
        self.hidesBottomBarWhenPushed = NO;

    }else if (indexPath.section == 3 && indexPath.row == 2) {
        ExchangeCenterVC * vc = [[ExchangeCenterVC alloc]init];
        self.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
        self.hidesBottomBarWhenPushed = NO;
    }else if (indexPath.section == 3 && indexPath.row == 1) {
        
        if (![self.isLogin isEqualToString:@"1"]) {
            
            [self goToLogineVC];
            
            return;
        }
        
        IncomeDetailVC * vc = [[IncomeDetailVC alloc]init];
        self.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
        self.hidesBottomBarWhenPushed = NO;
        
    }else if (indexPath.section == 4 && indexPath.row == 0) {
        
        WKWebViewController * vc = [[WKWebViewController alloc]init];
        
        vc.urlString = [NSString stringWithFormat:@"%@/App/Index/help",DomainURL];
        vc.isNewTeach = YES;
        self.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
        self.hidesBottomBarWhenPushed = NO;
        
    }else if (indexPath.section == 4 && indexPath.row == 1) {
        
        
        RespondGiftVC * vc = [[RespondGiftVC alloc]init];
        vc.mineModel = self.mineModel;
        
        self.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
        self.hidesBottomBarWhenPushed = NO;

    }else if (indexPath.section == 4 && indexPath.row == 2) {
        SetVC * vc = [[SetVC alloc]init];
        self.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
        self.hidesBottomBarWhenPushed = NO;

    }
    
    
}


- (void)goToLogineVC{

        LoginViewController * vc = [[LoginViewController alloc]init];
        self.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
        self.hidesBottomBarWhenPushed = NO;
    

}



#pragma mark- 分组高度
//section头部间距
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.1;//section头部高度
}


//section头部视图
- (UIView * )tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    UIView * view=[[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWith, 1)];
    view.backgroundColor = [UIColor clearColor];
    return view ;
}


//section底部间距
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    NSInteger index = self.SectionsTitleArray.count;
    
    if (index - 1 == section && index > 0) {
        
        return 0.1;
    }
    return 4.9;
}
//section底部视图
- (UIView * )tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView * view=[[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWith, 1)];
    view.backgroundColor = [UIColor clearColor];
    return view;
}

@end
