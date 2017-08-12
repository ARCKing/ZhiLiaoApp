//
//  HomeVC.m
//  NewApp
//
//  Created by gxtc on 17/2/13.
//  Copyright © 2017年 gxtc. All rights reserved.
//

#import "HomeVC.h"

#define channelBtWith ScreenWith/7
#define channelBtHeight ScreenWith/11

#define ArticleTableViewTag  1100

@interface HomeVC ()<UISearchBarDelegate,UITableViewDelegate,UITableViewDataSource>

/**分享窗口*/
@property (nonatomic,strong)MainShareView * shareView;

/**
 *频道标题数据源
 */
@property(nonatomic,strong)NSMutableArray * channelTitleDataArray;

/**
 *存放频道数组
 */
@property(nonatomic,strong)NSMutableArray * channelButtonSaveArray;


/**存放频道分类Model*/
@property(nonatomic,strong)NSMutableArray * articleChannelModelSaveArray;

/**存放频道c_id数组*/
@property(nonatomic,strong)NSMutableArray * articleChannelC_idSaveArray;
/**翻页*/
@property(nonatomic,strong)NSMutableArray * articleChannelPageIndex;

/**存放频道标题数组*/
@property(nonatomic,strong)NSMutableArray * articleChannelTitleSaveArray;


/**选中与否*/
@property(nonatomic,strong)NSMutableArray * selectChannelArray;
@property(nonatomic,strong)NSMutableArray * unselectChannelArray;


/**存放文章列表数据的字典*/
@property(nonatomic,strong)NSMutableDictionary * articleListAllDataDict;

/**当前文章列表*/
@property(nonatomic,strong)NSMutableArray * currentArticleListArray;

/**
 *频道
 */
@property (nonatomic,strong)UIView * channelTitleBackGroundView;
@property (nonatomic,strong)UIScrollView * channelTitleScrollView;
@property (nonatomic,strong)UIView * channelSellectLine;





/**
 *列表
 */
@property (nonatomic,strong)UIScrollView * tableScrollBackGroundView;
@property (nonatomic,strong)UITableView * firstTableView;

/**
 *四个按钮tableHeadView
 */
@property (nonatomic,strong)UIView * fourButtonTableHeadView;


/**
 *当前页
 */
@property (nonatomic,assign)NSInteger currentPage;

@property (nonatomic,assign)NSInteger pageIndex;

/**userInfo*/
@property (nonatomic,copy)NSString * uid;
@property (nonatomic,copy)NSString * token;
@property (nonatomic,copy)NSString * isLogin;
@property (nonatomic,copy)NSString * isShowFirstHongBao;

@property (nonatomic,strong)UIImageView * hongBaoImageView;

//新手任务
@property (nonatomic,strong)UIButton * peopleNewTestButton;


//邀请好友链接
@property (nonatomic,copy)NSString * shareLink;


/**推送消息*/
@property (nonatomic,strong)APNsModel * apnsMpdel;


/**是否完成新手任务*/
@property (nonatomic,assign)BOOL  hb_new_hbIsFinish;

/**是否审核隐藏*/
@property (nonatomic,assign)BOOL  hidenIs;

@property (nonatomic,strong)MBProgressHUD * HUD;

@property (nonatomic,strong)UILabel * withDrawLabel;

@end

@implementation HomeVC



- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];

    [self getTokenAndUid];

    
    self.navigationController.navigationBar.hidden = YES;

    if ([self.isLogin isEqualToString:@"1"]) {
        
        NSLog(@"xxxxxx");
        
        
//        [self checkMineDataFromCoreData];
        
        [self checkMineDataFromNet];
        
    }else{
    
        if (self.peopleNewTestButton) {
        
            [self.peopleNewTestButton removeFromSuperview];
        
        }
    }

}



#pragma mark- 网络检查我的信息
- (void)checkMineDataFromNet{

    NetWork * net = [NetWork shareNetWorkNew];

    [net getMineDataSource];
    
    __weak HomeVC * weakSelf = self;
    
    net.mineDataSourceBK = ^(NSString * code, NSString * message, NSString * str, NSArray * dataArray, NSArray * arr) {
        
        if ([code isEqualToString:@"1"]) {
            
            if (dataArray.count > 0) {
                
                MineDataSourceModel * model = dataArray[0];
                
                /*
                if ([model.type isEqualToString:@"1"]) {
                    
                    weakSelf.hidenIs = NO;
                    
                    
                }else{
                
                    weakSelf.hidenIs = YES;
                }
                */
                
                if ([model.hb_new_hb isEqualToString:@"1"]) {
                    
                    weakSelf.hb_new_hbIsFinish = YES;
                    
                    [self.peopleNewTestButton removeFromSuperview];

                }else{
                
                    weakSelf.hb_new_hbIsFinish = NO;
                    
                    [self newPeopleTestButtonNew];

                }
                
                
            }
            
        }
        
    };
}


#pragma mark- 检查我的本地信息
/**检查我的本地信息*/
- (void)checkMineDataFromCoreData{
    
    CoreDataManger * CDManger = [CoreDataManger shareCoreDataManger];
    
    MineDataSourceModel * model = [CDManger checkMineDataSource];

    if (model) {
        
        NSLog(@"新手任务:%@",model.hb_new_hb);
    
        if ([model.hb_new_hb isEqualToString:@"0"]) {
            
            [self newPeopleTestButtonNew];
        }else{
        
            [self.peopleNewTestButton removeFromSuperview];
            
        }
        
    }else{
    
    
    
    }


}



#pragma mark- 新手任务
/**
 *新手任务
 */
- (void)newPeopleTestButtonNew{
    
    if (self.peopleNewTestButton) {
        
        [self.view addSubview:self.peopleNewTestButton];
        
        return;
    }
    
    UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setImage:[UIImage imageNamed:@"HBbt"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(newPeopleTestButtonAction) forControlEvents:UIControlEventTouchUpInside];
    button.frame = CGRectMake(10, ScreenHeight - 49 - ScreenWith/8 - 20, ScreenWith/8, ScreenWith/8);
    self.peopleNewTestButton = button;
    button.backgroundColor = [UIColor clearColor];
    [self.view addSubview:button];
    
}

- (void)newPeopleTestButtonAction{
    
    NewPeopleTestVC * vc = [[NewPeopleTestVC alloc]init];
    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
    self.hidesBottomBarWhenPushed = NO;
}




- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.hidenIs = NO;
    
    self.hb_new_hbIsFinish = YES;
    
    
    [self HomeNavBarViewNew];

    
    
    self.articleListAllDataDict = [NSMutableDictionary new];
    self.currentArticleListArray = [NSMutableArray new];
    self.articleChannelPageIndex = [NSMutableArray new];
    
    self.pageIndex = 1;
    
    [self getTokenAndUid];
    
    
    
    
//    [self getDataAndanalysis];
    
    [self checkSelectChannelFromCoreData];
    
    
    //推送跳转判断
    AppDelegate * app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    CGFloat f = [[[UIDevice currentDevice]systemVersion]floatValue];
    if (app.userInfo && f < 10.0) {
        [self pushJumpWithUserInfo:app.userInfo];
        
        app.userInfo = nil;
    }

    
    //审核隐藏检测
//    [self hidenWhenReview];
    
}


#pragma mark- 审核隐藏
/**审核隐藏*/
- (void)hidenWhenReview{

    NetWork * net = [NetWork shareNetWorkNew];
    
    [net hidenWhenReviewFromNet];
    
    __weak HomeVC * weakSelf = self;
    
    net.hidenWhenReviewBK = ^(NSString * code, NSString * data) {
        
        
        if ([data isEqualToString:@"1"]) {
            
            
            weakSelf.firstTableView.tableHeaderView = weakSelf.fourButtonTableHeadView;
            
            weakSelf.hidenIs = NO;
            
            weakSelf.withDrawLabel.text = @"兑换中心";
            
            [weakSelf showNewPeopleHongBao];
            
        }else{
        
            weakSelf.firstTableView.tableHeaderView = [[UIView alloc]init];
            
            weakSelf.hidenIs = YES;
            
            weakSelf.withDrawLabel.text = @"消息中心";
            
        }
        
        
    };
    
}






#pragma mark- 新手注册红包
/**新手注册红包*/
- (void)showNewPeopleHongBao{

    if (![self.isShowFirstHongBao isEqualToString:@"1"]) {
        
        [self addNewPeopleHongBaoImageViewNew];
    }
    
}


/**第一次登陆-显示新手红包*/
- (void)addNewPeopleHongBaoImageViewNew{

    
    if (self.hongBaoImageView) {
        
        [self.view addSubview: self.hongBaoImageView];
        
        return;
    }
    
    UIImageView * imageV = [[UIImageView alloc]initWithFrame:CGRectMake(30, ScreenHeight * 2/5 - 100, ScreenWith - 60, ScreenHeight * 3 /5)];
    imageV.userInteractionEnabled = YES;
    imageV.image = [UIImage imageNamed:@"red_packet"];
    [self.view addSubview:imageV];
    self.hongBaoImageView = imageV;
    
    
    UIButton * button = [self addRootButtonTypeTwoNewFram:CGRectMake(50, ScreenHeight * 3/5 - ScreenWith/10 - 30, ScreenWith - 60 - 100, ScreenWith/10) andImageName:@"" andTitle:@"确定" andBackGround:[UIColor orangeColor] andTitleColor:[UIColor whiteColor] andFont:16.0 andCornerRadius:5.0];
    [button addTarget:self action:@selector(removeHongBaoView) forControlEvents:UIControlEventTouchUpInside];
    [imageV addSubview:button];
}



- (void)removeHongBaoView{
    
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    NSMutableDictionary * dic = [NSMutableDictionary dictionaryWithDictionary:[defaults objectForKey:@"userInfo"]];
    dic[@"firstHongBao"] =@"1";
    NSDictionary * dicNew = [NSDictionary dictionaryWithDictionary:dic];
    [defaults setObject:dicNew forKey:@"userInfo"];
    [defaults synchronize];
    
    
    [UIView animateWithDuration:0.2 animations:^{
        
        self.hongBaoImageView.frame = CGRectMake( - (ScreenWith - 60), ScreenHeight * 2/5 - 100, ScreenWith - 60, ScreenHeight * 3 /5);
        
    } completion:^(BOOL finished) {
        
        [self.hongBaoImageView removeFromSuperview];

        
        LoginViewController * vc = [[LoginViewController alloc]init];
        
        self.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
        self.hidesBottomBarWhenPushed = NO;
        
        
    }];
    
}



/**推送跳转*/
- (void)pushJumpWithUserInfo:(NSDictionary *)userInfo{

    
    APNsModel * model = [self apnsModelWithUserInfo:userInfo];
    
    self.apnsMpdel = model;
    
    [self showPushMessageAlertViewWithContent:model];
    
}



/**推送消息提示框*/
- (void)showPushMessageAlertViewWithContent:(APNsModel *)model{
    
    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"新消息"
                                                     message:model.title
                                                    delegate:self
                                           cancelButtonTitle:@"忽略"
                                           otherButtonTitles:@"查看",nil];
    
    [alert show];
}



- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (buttonIndex == 1) {
        
        NSLog(@"查看");
        
        [self pushToWkWebViewControllWithUserInfo:self.apnsMpdel];
        
    }else{
        
        NSLog(@"忽略");
        
        
    }
    
    
}





//解析成模型
- (APNsModel *)apnsModelWithUserInfo:(NSDictionary *)userInfo{
    
    NSDictionary * aps = userInfo[@"aps"];
    NSString * alert = aps[@"alert"];
    
    NSDictionary * content_available = aps[@"content-available"];
    APNsModel * model = [[APNsModel alloc]initWithDictionary:content_available error:nil];
    model.alert = alert;
    NSLog(@"%@",model);
    
    return model;
}



//提示框跳转
- (void)pushToWkWebViewControllWithUserInfo:(APNsModel *)model{
    
    
    ArticleListModel * article = [[ArticleListModel alloc]init];
    
    article.id = model.id;
    article.title = model.title;
    article.thumb = model.thumb;
    
    WKWebViewController * wk = [[WKWebViewController alloc]init];
    wk.isPost = NO;
    wk.isVideo = NO;
    wk.article_id = [NSString stringWithFormat:@"%d",model.id];
    wk.articleModel = article;
    wk.isPushAPNS = YES;
    
    self.hidesBottomBarWhenPushed = YES;
    
    [self.navigationController pushViewController:wk animated:YES];
    
    self.hidesBottomBarWhenPushed = NO;
}




#pragma mark- 查找本地数据
/**数据库查找频道-检查服务器是否添加频道*/
- (void)checkChannelListFromCoreData{

    CoreDataManger * CDManger = [CoreDataManger shareCoreDataManger];
    
    NSArray * list = [CDManger checkArticleList];
    
    NSLog(@"%@",list);

    
    
    NetWork * net = [NetWork shareNetWorkNew];
    
    [net getArticleChannelClassifyFromNet];
    
    
    net.articleClassifyBK=^(NSString * code,NSString * message,NSString * str,NSArray * dataArray,NSArray * arr){
        
        if ([code isEqualToString:@"1"]) {
            
            NSLog(@"%@",dataArray);
            
            if (dataArray.count > 0) {
                
                if (list.count > 0) {
                 
                
                    if (dataArray.count != list.count) {
                    
                        
                        [CDManger deleteAllArticleClassData];
                        
                        [CDManger insertIntoDataWithArticalClassTheSelect:dataArray andTheUnselect:nil];
                    }else{
                    
                        BOOL isFind = YES;
                        
                        for (ArticleClassifyModel * model0 in dataArray) {
                            
                            
                            
                            for (ArticleClassifyModel * model1 in list) {
                                
                                
                                if ([model0.title isEqualToString: model1.title]) {
                                    
                                    isFind = YES;
                                    
                                    break;
                                    
                                }else{
                                
                                    isFind = NO;
                                    
                                }
                
                            }
                            
                            
                            
                            if (isFind == NO) {
                                
                                NSLog(@"服务器更新了!");
                                
                                [CDManger deleteAllArticleClassData];
                                
                                [CDManger insertIntoDataWithArticalClassTheSelect:dataArray andTheUnselect:nil];
                                
                            }
                            
                        }
                    
                    }
                    
                }
            }
        }
    };
    
    
    
    
}


#pragma mark- 查找本地选中数据
- (void)checkSelectChannelFromCoreData{

    CoreDataManger * CDManger = [CoreDataManger shareCoreDataManger];

   NSArray * selectArray = [CDManger checkSelectArticleCharnel];
    
    if (selectArray.count > 0) {
        
        self.articleChannelModelSaveArray = [NSMutableArray arrayWithArray:selectArray];
        
        
        
        NSMutableArray * titles = [NSMutableArray new];
        NSMutableArray * c_ids = [NSMutableArray new];
        
        for (ArticleClassifyModel * model in self.articleChannelModelSaveArray) {
            
            [titles addObject:model.title];
            [c_ids addObject:model.c_id];
            
            
            [self.articleChannelPageIndex addObject:@"1"];
            
        }
        
        self.articleChannelTitleSaveArray = [NSMutableArray arrayWithArray:titles];
        self.articleChannelC_idSaveArray = [NSMutableArray arrayWithArray:c_ids];
        
        [self addUI];

        
        [self checkChannelListFromCoreData];
        
    }else{
    
        //从网络获取频道
        [self getDataAndanalysis];
        
    }
    
    
}


#pragma mark- 查找本地未选中数据
- (void)checkUnselectChannelFromCoreData{


}


- (void)getDataAndanalysis{

    [self getArticleClassifyFromNet];
}



- (void)addUI{

    
    [self channelTitleViewNew];
    
    [self tableScrollViewNew];
    
    [self showNewPeopleHongBao];

}


- (void)getTokenAndUid{
    
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    
    NSDictionary * userInfo = [defaults objectForKey:@"userInfo"];
    
    self.uid = userInfo[@"uid"];
    self.token = userInfo[@"token"];
    self.isLogin = userInfo[@"login"];
    self.isShowFirstHongBao = userInfo[@"firstHongBao"];
    
}




#pragma mark- channelTableViewScrollViewNew
- (void)tableScrollViewNew{
    
    [self tableScrollBackGroundViewNew];
    
//    self.fourButtonTableHeadView = [self fourButtonTableHeadViewNew];
}


/**
 *列表滚动视图
 */
- (void)tableScrollBackGroundViewNew{
    NSInteger channelCount = self.channelTitleDataArray.count;
    
    UIScrollView * scrollview = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 64 + ScreenWith/10, ScreenWith, ScreenHeight - 49 - (64 + ScreenWith/10))];
    scrollview.contentSize = CGSizeMake(ScreenWith * channelCount, 0);
    scrollview.showsHorizontalScrollIndicator = NO;
    scrollview.tag = 1002;
    scrollview.pagingEnabled = YES;
    scrollview.bounces = NO;
    scrollview.delegate = self;
    scrollview.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:scrollview];
    self.tableScrollBackGroundView = scrollview;
    
    self.currentPage = 0;
    
    //推荐的列表视图
    UITableView * tableView = [self channelArticleListTableViewNew:CGRectMake(0, 0, ScreenWith, ScreenHeight - 49 - (64 + ScreenWith/10)) andCurrentPageTag: self.currentPage];
    
//    self.firstTableView = tableView;
    
    tableView.tableHeaderView = [self fourButtonTableHeadViewNew];
    
    
}


/**
 *列表头部视图
 */
- (UIView *)fourButtonTableHeadViewNew{

    NSArray * images = @[@"phb",@"qd_h",@"dhzx_h",@"yqhy_h"];
    NSArray * titles = @[@"排行榜 ",@"签 到",@"兑换中心",@"邀请好友"];
    
    UIView * tableHeadView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWith, ScreenWith/5)];
    
    UIView * line = [[UIView alloc]initWithFrame:CGRectMake(0, ScreenWith/5-1, ScreenWith, 0.5)];
    line.backgroundColor = [UIColor lightGrayColor];
    [tableHeadView addSubview:line];
    
    for (int i = 0; i < 4; i++) {
        
        UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setImage:[UIImage imageNamed:images[i]] forState:UIControlStateNormal];
        
//        button.frame = CGRectMake(i * (ScreenWith/9 + (ScreenWith - (ScreenWith *4/9))/5) + (ScreenWith - (ScreenWith * 4/9))/5, 8, ScreenWith/9, ScreenWith/9);
//        button.backgroundColor = [UIColor redColor];
        
        button.frame = CGRectMake(20 + ((ScreenWith - ScreenWith * 4/9 - 40)/3 + ScreenWith/9) * i, 8, ScreenWith/9, ScreenWith/9);
        
        [button setImageEdgeInsets:UIEdgeInsetsMake(-5,0, 0, 0)];
        [tableHeadView addSubview:button];
        
        button.tag = 22110 + i;
        
        [button addTarget:self action:@selector(tableHeadViewFourButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        
        UILabel * title = [[UILabel alloc]initWithFrame:CGRectMake(0,0, ScreenWith/4, 20)];
        title.center = CGPointMake(button.center.x, CGRectGetMaxY(button.frame) + 10);
        title.text = titles[i];
        
        NSInteger device = CurrentDeviceScreen;
        
        if (device == 0) {
            title.font = [UIFont systemFontOfSize:12];

        }else{
            title.font = [UIFont systemFontOfSize:14];
        }
        title.textAlignment = NSTextAlignmentCenter;
        title.textColor = [UIColor blackColor];
        [tableHeadView addSubview:title];
        
        /*
        if (i == 2) {
            
            self.withDrawLabel = title;
        }
        */
        
    }
    
    return tableHeadView;
}

//跳转登录
- (void)goToLogineVC{
    
    LoginViewController * vc = [[LoginViewController alloc]init];
    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
    self.hidesBottomBarWhenPushed = NO;
    
    
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    [self.HUD hideAnimated:YES];

}


- (void)tableHeadViewFourButtonAction:(UIButton *)bt{

    
    if (bt.tag == 22110) {
        
        NSLog(@"排行榜");

        self.tabBarController.selectedIndex = 2;
        
    }else if (bt.tag == 22111){

        NSLog(@"签到");

        
        if (![self.isLogin isEqualToString:@"1"]) {
            
            [self goToLogineVC];
            
            return;
        }
        
        
        
        if (self.hidenIs == YES) {
            
            MBProgressHUD * hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            
            self.HUD = hud;
            
            NetWork * net = [NetWork shareNetWorkNew];
            
            [net userRegisterEveryDay];
            
            __weak HomeVC * weakSelf = self;
            
            net.registerEveryDayBK = ^(NSString * code, NSString * message, NSString *amount, NSArray * arr1, NSArray * arr2) {
                
                [hud hideAnimated:YES];
                
                    
                    [weakSelf rootShowMBPhudWith:message andShowTime:0.5];
                
                
            };
            
            
            NSLog(@"签到!");
            
        }else{
        
            TestCenterVC * vc = [[TestCenterVC alloc]init];
            self.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController: vc animated:YES];
            self.hidesBottomBarWhenPushed = NO;
        
        }
        
    }else if (bt.tag == 22112){

        NSLog(@"兑换中心");

        if (![self.isLogin isEqualToString:@"1"]) {
            
            [self goToLogineVC];
            
            return;
        }
        
        ExchangeCenterVC * vc = [[ExchangeCenterVC alloc]init];
        self.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
        self.hidesBottomBarWhenPushed = NO;
        
    }else {

        NSLog(@"邀请好友");
        if (![self.isLogin isEqualToString:@"1"]) {
            
            [self goToLogineVC];
            
            return;
        }
        
        NetWork * net = [NetWork shareNetWorkNew];
        __weak HomeVC * weakSelf = self;
        
        [net mineInviateCodeAndInviateLink];
        
        net.mineInviateCodeAndInviteLinkBK=^(NSString * code,NSString * inviter,NSString * url,NSArray * data,NSArray * arr){
        
            if ([code isEqualToString:@"1"]) {
                
                weakSelf.shareLink = url;
            }
        
        };

        MainShareView * shareView = [[MainShareView alloc]initWithFrame:CGRectMake(0, 0, ScreenWith, ScreenHeight)];
        
        self.shareView = shareView;
        
        [shareView addMiddelShareViewNew];
        
        [shareView.WeiXinShareButton addTarget:self action:@selector(rootWeiXinShareButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        shareView.WeiXinShareButton.tag = 1110;
        
        [shareView.WeiXinFriendShareButton addTarget:self action:@selector(rootWeiXinShareButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        shareView.WeiXinFriendShareButton.tag = 2220;
        
        [shareView.QQShareButton addTarget:self action:@selector(rootQQShareButtonAction) forControlEvents:UIControlEventTouchUpInside];
        
        [shareView.QzoneShareButton addTarget:self action:@selector(rootQzoneShareButtonAction) forControlEvents:UIControlEventTouchUpInside];

        UIWindow *window = [UIApplication sharedApplication].keyWindow;

        [shareView.cancleButton addTarget:self action:@selector(rootCancleButtonAction) forControlEvents:UIControlEventTouchUpInside];

        [shareView.shareLinkCopyButton addTarget:self action:@selector(rootCopyLinkButtonAction) forControlEvents:UIControlEventTouchUpInside];

        
        
//        [self.view addSubview:shareView];
        

        [window addSubview:shareView];
    }
    

}

#pragma mark- 分享按钮
- (void)rootWeiXinShareButtonAction:(UIButton *)bt{
    
    [self.shareView.shareMiddleView removeFromSuperview];
    [self.shareView.cancleButton removeFromSuperview];
    
    [self.shareView addAdvertisementViewNew];
    
    [self.shareView.advCancleButton addTarget:self action:@selector(rootAdvCancleButtonAction) forControlEvents:UIControlEventTouchUpInside];
    
    [self.shareView.shareEnterButton addTarget:self action:@selector(rootShareEnterButtonAction) forControlEvents:UIControlEventTouchUpInside];

    self.shareView.shareType = WeiXinShareType;

    
}

- (void)rootQQShareButtonAction{

    [self.shareView.shareMiddleView removeFromSuperview];
    [self.shareView.cancleButton removeFromSuperview];
    
    [self.shareView addAdvertisementViewNew];
    
    [self.shareView.advCancleButton addTarget:self action:@selector(rootAdvCancleButtonAction) forControlEvents:UIControlEventTouchUpInside];

    [self.shareView.shareEnterButton addTarget:self action:@selector(rootShareEnterButtonAction) forControlEvents:UIControlEventTouchUpInside];

    self.shareView.shareType = QQShareType;

}


- (void)rootQzoneShareButtonAction{

    [self.shareView.shareMiddleView removeFromSuperview];
    [self.shareView.cancleButton removeFromSuperview];
    
    [self.shareView addAdvertisementViewNew];
    
    [self.shareView.advCancleButton addTarget:self action:@selector(rootAdvCancleButtonAction) forControlEvents:UIControlEventTouchUpInside];
    
    [self.shareView.shareEnterButton addTarget:self action:@selector(rootShareEnterButtonAction) forControlEvents:UIControlEventTouchUpInside];

    self.shareView.shareType = QzoneShareType;

}


- (void)rootCopyLinkButtonAction{

    [self.shareView.shareMiddleView removeFromSuperview];
    [self.shareView.cancleButton removeFromSuperview];
    
    [self.shareView addAdvertisementViewNew];
    
    [self.shareView.advCancleButton addTarget:self action:@selector(rootAdvCancleButtonAction) forControlEvents:UIControlEventTouchUpInside];

    [self.shareView.shareEnterButton addTarget:self action:@selector(rootShareEnterButtonAction) forControlEvents:UIControlEventTouchUpInside];

    self.shareView.shareType = LinkCopyType;

}

- (void)rootCancleButtonAction{
    [self.shareView removeFromSuperview];

}

- (void)rootAdvCancleButtonAction{
    
    [self.shareView removeFromSuperview];

}

- (void)rootShareEnterButtonAction{

    NSString * advString;
    
    if (self.shareView.selectAdvString) {
        
        advString = self.shareView.selectAdvString;
    }
    
    
    if (advString == nil) {
    
        advString = @"不能提现的红包，都是耍流氓，下载送5元现金红包，能提现，绝对真实，不忽悠!!！";
    }
    
    
    if (self.shareLink == nil) {
        
        self.shareLink = [NSString stringWithFormat:@"http://zqw.2662126.com/App/Share/index/uid/%@",self.uid];
    }
    
    NSLog(@"self.shareLink = %@",self.shareLink);

    
    [self.shareView removeFromSuperview];

    NSInteger shareType = self.shareView.shareType;
    
    if (shareType == WeiXinShareType || shareType == WeiXinFriendShareType) {
        NSLog(@"微信--");
        
        
        [self rootLocationWeiXinShareWithImage:[UIImage imageNamed:@"lg"] andImageUrl:nil andString:advString andUrl:self.shareLink];
        
        
    }else if (shareType == QQShareType){
        NSLog(@"QQ--");

        if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"mqq://"]]) {

        [self shareWebPageToPlatformType:UMSocialPlatformType_QQ andTitle:advString andContent:advString andUrl:self.shareLink andThumbImage:[UIImage imageNamed:@"lg"]];
            
        }else{
        
            [self rootLocationWeiXinShareWithImage:[UIImage imageNamed:@"lg"] andImageUrl:nil andString:advString andUrl:self.shareLink];

        }
        
    }else if (shareType == QzoneShareType){
        NSLog(@"QQ空间--");

        if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"mqq://"]]) {

        [self shareWebPageToPlatformType:UMSocialPlatformType_Qzone andTitle:advString andContent:advString andUrl:self.shareLink andThumbImage:[UIImage imageNamed:@"lg"]];
            
        }else{
            
            [self rootLocationWeiXinShareWithImage:[UIImage imageNamed:@"lg"] andImageUrl:nil andString:advString andUrl:self.shareLink];

        }
    
    }else {
        NSLog(@"复制链接--");

        [self copyLink];
    }
    

}

- (void)copyLink{
    
    
    if (self.shareLink == nil) {
        
        self.shareLink = [NSString stringWithFormat:@"http://zqw.2662126.com/App/Share/index/uid/%@",self.uid];
    }
    
    NSLog(@"self.shareLink = %@",self.shareLink);

    
    
    NSLog(@"复制分享链接");
    
    NSString * url = self.shareLink;
    
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = url;
    
    if (pasteboard.string != nil) {
        
        UIAlertController * alertControll = [UIAlertController alertControllerWithTitle:@"复制成功" message:nil preferredStyle: UIAlertControllerStyleAlert];
        
        [self presentViewController:alertControll animated:YES completion:^{
            
            NSLog(@"提示框来了!");
            
        }];
        
        [self performSelector:@selector(removeAlerateFromSuperView:) withObject:self afterDelay:1];
        
        
    }else {
        UIAlertController * alertControll = [UIAlertController alertControllerWithTitle:@"复制失败" message:nil preferredStyle: UIAlertControllerStyleAlert];
        
        [self presentViewController:alertControll animated:YES completion:^{
            
            NSLog(@"提示框来了!");
            
        }];
        
        [self performSelector:@selector(removeAlerateFromSuperView:) withObject:self afterDelay:1];
        
    }
    
}

//提示框消失
- (void)removeAlerateFromSuperView:(UIAlertController *)alertControll{
    
    [alertControll dismissViewControllerAnimated:YES completion:nil];
    
}

#pragma mark- 翻页创建tableView
/**
 *创建文章列表
 */
- (UITableView *)channelArticleListTableViewNew:(CGRect)frame andCurrentPageTag:(NSInteger)tag{
    
    UITableView * currentTableView = (UITableView *)[self.tableScrollBackGroundView viewWithTag: tag + 22220];
    
    if (currentTableView == nil) {
        
        UITableView * tableView = [[UITableView alloc]initWithFrame:frame style:UITableViewStylePlain];
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.showsVerticalScrollIndicator = NO;
        tableView.rowHeight = ScreenWith/4 + 20;
        tableView.tag = tag + 22220;
        currentTableView = tableView;
        tableView.tableFooterView = [[UITableView alloc]init];
        
        [self.tableScrollBackGroundView addSubview:currentTableView];
    
        MJRefreshNormalHeader * MJ_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(MJdataReload)];
        
        MJ_header.stateLabel.textColor =[UIColor colorWithRed:0.0 green:207.0/255.0 blue:1.0 alpha:1.0];
        
        MJ_header.lastUpdatedTimeLabel.textColor = [UIColor colorWithRed:0.0 green:207.0/255.0 blue:1.0 alpha:1.0];
        
        tableView.mj_header = MJ_header;
        
//        tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(MJdataReload)];
        
        
        
        
        tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(MJdataLoadMore)];
        
        
        
        
        [tableView.mj_header beginRefreshing];

    }
    
    return currentTableView;
}



#pragma mark- channelTitleViewNew
/**
 *文章频道
 */
-(void)channelTitleViewNew{
    
    [self channelTitleDataSourceNew];
    
    [self channelTitleBackGroundViewNew];

    [self channelTitleScrollViewNew];
    
    [self addChannelButtonNew];
    
    [self channelSelectLineNew];
    
    [self channelMangerButtonNew];
}


- (void)channelTitleDataSourceNew{
    
    
    if (self.articleChannelTitleSaveArray.count > 0) {
       
        
        self.channelTitleDataArray = [NSMutableArray arrayWithArray:self.articleChannelTitleSaveArray];

        
    }else{
        
        NSArray * array = @[@"爱上",@"是的",@"无法",@"二恶",@"儿童",@"二人",@"营业",@"回个",@"回好",@"呵呵",@"将要",@"具有",@"让他",@"二二",@"玩儿",@"太容",@"应用",@"好人",@"我问",@"特尔"];

       self.channelTitleDataArray = [NSMutableArray arrayWithArray:array];
    }
}


- (void)channelTitleBackGroundViewNew{

    UIView * bgview = [[UIView alloc]initWithFrame:CGRectMake(0, 64, ScreenWith, ScreenWith/10)];
    bgview.backgroundColor = [UIColor colorWithRed:239/255.0 green:239/255.0 blue:239/255.0 alpha:1.0];
    [self.view addSubview:bgview];
    
    self.channelTitleBackGroundView = bgview;
}

- (void)channelTitleScrollViewNew{

    NSInteger channelCount = self.channelTitleDataArray.count;
    
    UIScrollView * scrView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, ScreenWith - ScreenWith/10, ScreenWith/10)];
//    scrView.backgroundColor = [UIColor redColor];
    scrView.contentSize = CGSizeMake(channelBtWith * channelCount, 0);
    scrView.showsHorizontalScrollIndicator = NO;
    scrView.bounces = NO;
    scrView.tag = 1001;
    scrView.delegate = self;
    [self.channelTitleBackGroundView addSubview:scrView];
    self.channelTitleScrollView = scrView;

}

/**
 *创建频道按钮
 */
- (void)addChannelButtonNew{

    NSMutableArray * array = [NSMutableArray new];
    
    for (int i = 0; i < (int)self.channelTitleDataArray.count; i++) {
        UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setTitle:self.channelTitleDataArray[i] forState:UIControlStateNormal];
        button.frame = CGRectMake(i*channelBtWith, 0, channelBtWith, channelBtHeight);
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor colorWithRed:0.0 green:210.0/255.0 blue:1.0 alpha:1] forState:UIControlStateSelected];
        button.tag = i + 11110;
        [button addTarget:self action:@selector(channelButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.channelTitleScrollView addSubview:button];
        [array addObject:button];
        button.titleLabel.font = [UIFont systemFontOfSize:16];
        if (i == 0) {
            button.selected = YES;
        }
    }

    self.channelButtonSaveArray = [NSMutableArray arrayWithArray:array];
}

/**
 *频道按钮SEL
 */
- (void)channelButtonAction:(UIButton *)bt{

    self.currentPage = bt.tag - 11110;
    
    [self achiveCurrentChannelButton:bt andCharnnelTitleScrollView:self.channelTitleScrollView];
    
}


/**
 *改变title scrollView line位置 + 创建tableview
 */
- (void)setChannelTitlePositionAndSelectBtLinePositionWithButton:(UIButton * )bt
                                       andChannelTitleScrollWidth:(CGFloat)channelTitleScrollWidth
                                       andThreeButtonWidth:(CGFloat)threeButtonWidth
                                       andscrollWidth:(CGFloat)scrollWidth{

    [UIView animateWithDuration:0.2 animations:^{
        
        self.channelSellectLine.frame = CGRectMake(bt.frame.origin.x, channelBtHeight, channelBtWith, ScreenWith/10 - channelBtHeight);
    }];

    
    //频道滑条位置调整
    //可以滑动
    if (channelTitleScrollWidth > 0) {
        
        if ((float)(bt.tag - 11110) * channelBtWith > threeButtonWidth && channelTitleScrollWidth >(float)(bt.tag - 11110) * channelBtWith - threeButtonWidth){
            
            
            [self.channelTitleScrollView setContentOffset:CGPointMake(scrollWidth, 0) animated:YES];
            
        }else{
            
            if (channelTitleScrollWidth <(float)(bt.tag - 11110) * channelBtWith - threeButtonWidth) {
                
                //最右端
                [self.channelTitleScrollView setContentOffset:CGPointMake(channelTitleScrollWidth, 0) animated:YES];
                
            }else{
                //最左端
                [self.channelTitleScrollView setContentOffset:CGPointMake(0, 0) animated:YES];
                
            }
        }
    }

    //创建tableview
    [self channelArticleListTableViewNew:CGRectMake(ScreenWith * self.currentPage, 0, ScreenWith,ScreenHeight - 64 - 49) andCurrentPageTag:  self.currentPage];

    

}




//频道滑条滑动范围
- (CGFloat)channelTitleScrollViewScrollWidth{

    CGFloat  contentSize_Width = self.channelTitleScrollView.contentSize.width;
    
    CGFloat  bounds_Width = self.channelTitleScrollView.bounds.size.width;


    return contentSize_Width - bounds_Width;
}


/**
 *滑条
 */
- (void)channelSelectLineNew{
    UIView * line = [[UIView alloc]initWithFrame:CGRectMake(0, channelBtHeight, channelBtWith, ScreenWith/10 - channelBtHeight)];
    line.backgroundColor = [UIColor colorWithRed:0.0 green:210.0/255.0 blue:1.0 alpha:1];
    line.layer.cornerRadius = (ScreenWith/10 - channelBtHeight)/2;
    
//    [self.channelTitleBackGroundView addSubview:line];
    
    [self.channelTitleScrollView addSubview:line];
    
    self.channelSellectLine = line;
}


/**
 *频道管理按钮
 */
- (void)channelMangerButtonNew{

    UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(ScreenWith - ScreenWith/10  , 0, ScreenWith/10, ScreenWith/10);
    button.backgroundColor = [UIColor clearColor];
    [button setImage:[UIImage imageNamed:@"jia"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(channelMangerButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [self.channelTitleBackGroundView addSubview:button];
}

- (void)channelMangerButtonAction{

    NSLog(@"频道管理");
    
    
    ChannelMangerVC * vc = [[ChannelMangerVC alloc]init];
    
    __weak HomeVC * weakSelf = self;
    vc.channelMangerFinishBK=^{
    
    
        [weakSelf checkSelectChannelFromCoreData];

        
    };
    
    
    
    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
    self.hidesBottomBarWhenPushed = NO;

}


#pragma mark- navgationViewNew
/**
 *自定义导航栏
 */
- (void)HomeNavBarViewNew{
    
    self.navigationBarView = [self NavBarViewNew];
    [self searchBarButtonNew];
    [self rightNavBarButtonNew];
    [self leftLabelTitleNew];
}

/**
 *我的消息(铃铛)
 */
- (void)rightNavBarButtonNew{
    UIButton * bt = [UIButton buttonWithType:UIButtonTypeCustom];
    bt.frame = CGRectMake(ScreenWith - ScreenWith/15 - 5, 30, ScreenWith/15, ScreenWith/15);
    [bt setImage:[UIImage imageNamed:@"ring"] forState:UIControlStateNormal];
    [bt addTarget:self action:@selector(rightNavBarButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [self.navigationBarView addSubview:bt];
    
}


- (void)rightNavBarButtonAction{

    NSLog(@"我的消息");
    
    MineMessageVC * vc = [[MineMessageVC alloc]init];
    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController  pushViewController:vc animated:YES];
    self.hidesBottomBarWhenPushed = NO;
    
}

/**
 *左边App名称
 */
- (void)leftLabelTitleNew{
    UILabel * title = [[UILabel alloc]initWithFrame:CGRectMake(0, 30, ScreenWith/5, ScreenWith/15)];
    title.text = @"知了";
    
    [title setFont:[UIFont fontWithName:@"HiraKakuProN-w6" size:25.0]];
    
    title.textColor = [UIColor whiteColor];
    title.textAlignment = NSTextAlignmentCenter;
    [self.navigationBarView addSubview:title];
}

/**
 *搜索框
 */
- (void)searchBarButtonNew{
    UISearchBar * searchBar = [[UISearchBar alloc]initWithFrame:CGRectMake(ScreenWith/5, 30, ScreenWith * 2/3, ScreenWith/15)];
    searchBar.placeholder = @"资讯搜索";
    [searchBar setBackgroundImage:[[UIImage alloc]init]];
    searchBar.delegate = self;
    [self.navigationBarView addSubview:searchBar];
}

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar{

    NSLog(@"点击搜索框");
    
    SearchBarVC * vc = [[SearchBarVC alloc]init];
    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
    self.hidesBottomBarWhenPushed = NO;
    
    return NO;
}

#pragma mark- scrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{

    NSLog(@"滚动结束");
    
    if (scrollView.tag == 1001) {
        
        
    }else if(scrollView.tag == 1002){
    
        self.currentPage = scrollView.contentOffset.x / ScreenWith;
        UIButton * bt = self.channelButtonSaveArray[self.currentPage];

        [self achiveCurrentChannelButton:bt andCharnnelTitleScrollView:scrollView];
        
    }
    
}


#pragma mark- 调整title line tableScrollview位置
- (void)achiveCurrentChannelButton:(UIButton *)bt andCharnnelTitleScrollView:(UIScrollView *)scrollView{

    //频道总共滑动距离
    CGFloat channelTitleScrollWidth = [self channelTitleScrollViewScrollWidth];
    
    //中间位置
    CGFloat threeButtonWidth = channelBtWith * 3.0;
    
    //频道滑动距离
    CGFloat scrollWidth = (bt.tag - 11110) * channelBtWith - threeButtonWidth;
    
    [self setChannelTitlePositionAndSelectBtLinePositionWithButton:bt andChannelTitleScrollWidth:channelTitleScrollWidth andThreeButtonWidth:threeButtonWidth andscrollWidth:scrollWidth];
    
    
    //频道选中状态
    for (UIButton * button in self.channelButtonSaveArray) {
        
        if (button.tag == bt.tag) {
            button.selected = YES;
            
            if (scrollView == self.channelTitleScrollView) {
                
                [self.tableScrollBackGroundView setContentOffset:CGPointMake((bt.tag - 11110) * ScreenWith, 0) animated:YES];

            }
            
        }else{
            button.selected = NO;
        }
    }

}



#pragma mark- tableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    NSString * keyC_id = self.articleChannelC_idSaveArray[self.currentPage];
    NSLog(@"%@",keyC_id);
    
    NSArray * currentArrayList = [self.articleListAllDataDict objectForKey:keyC_id];
    
    return currentArrayList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    
    MineOneTypeCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil) {
        
        cell = [[MineOneTypeCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        
    }
    
    NSString * keyC_id = self.articleChannelC_idSaveArray[self.currentPage];
    NSLog(@"%@",keyC_id);
    
    NSArray * currentArrayList = [self.articleListAllDataDict objectForKey:keyC_id];
    
    ArticleListModel * model = currentArrayList[indexPath.row];
    
    
    NSLog(@"%@",model);
    
    cell.articleListModel = model;

    
    return cell;

    
    
    
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSLog(@"点击了:%ld",indexPath.row);
    
    NSString * keyC_id = self.articleChannelC_idSaveArray[self.currentPage];
    NSLog(@"%@",keyC_id);
    
    NSArray * currentArrayList = [self.articleListAllDataDict objectForKey:keyC_id];
    
    ArticleListModel * model = currentArrayList[indexPath.row];
    
    
    WKWebViewController * web = [[WKWebViewController alloc]init];
    web.article_id = [NSString stringWithFormat:@"%d",model.id];
    
    web.isPost = NO;
    web.isVideo = NO;
    
    web.articleModel = model;
    
    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:web animated:YES];
    self.hidesBottomBarWhenPushed = NO;

    

}


#pragma mark- 数据解析

/**获取文章分类*/
- (void)getArticleClassifyFromNet{

    NetWork * net = [NetWork shareNetWorkNew];
    
    [net getArticleChannelClassifyFromNet];
    
    __weak HomeVC * weakSelf = self;
    
    net.articleClassifyBK=^(NSString * code,NSString * message,NSString * str,NSArray * dataArray,NSArray * arr){
    
        if ([code isEqualToString:@"1"]) {
            
            NSLog(@"%@",dataArray);
            
            
            if (dataArray.count > 0) {
            
                CoreDataManger * CDManger = [CoreDataManger shareCoreDataManger];
                
                [CDManger insertIntoDataWithArticalClassTheSelect:dataArray andTheUnselect:nil];
                
            }
            
            
            weakSelf.articleChannelModelSaveArray = [NSMutableArray arrayWithArray:dataArray];
            
            
            NSMutableArray * titles = [NSMutableArray new];
            NSMutableArray * c_ids = [NSMutableArray new];
            
            for (ArticleClassifyModel * model in dataArray) {
                
                [titles addObject:model.title];
                [c_ids addObject:model.c_id];
                
                
                [weakSelf.articleChannelPageIndex addObject:@"1"];
                
            }

            weakSelf.articleChannelTitleSaveArray = [NSMutableArray arrayWithArray:titles];
            weakSelf.articleChannelC_idSaveArray = [NSMutableArray arrayWithArray:c_ids];
            
            [weakSelf addUI];
        }
        
    };
}

/**获取文章列表*/

- (void)getArticleListWithC_id:(NSString *)c_id andpageIndex:(NSString *)pageIndex andUid:(NSString *)uid andIsReload:(BOOL)isReload{

    
    NSString * keyC_id = self.articleChannelC_idSaveArray[self.currentPage];
    NSLog(@"%@=%ld=",keyC_id,self.currentPage);
    
    NSLog(@"%@,%@,%@",c_id,pageIndex,uid);
    
    NetWork * net = [NetWork shareNetWorkNew];
    
    NSString * type;
    
    if (isReload) {
        
        type = @"1";
    }else{
    
        type = nil;
    }
    
    [net getArticleListFromNetWithC_id:c_id andPageIndex:pageIndex andUid:uid andType:type];
    
    __weak HomeVC * weakSelf = self;
    
    net.articleListBK=^(NSString * code,NSString * message,NSString * str,NSArray * data1,NSArray * data2){
    
        UITableView * tableView = (UITableView *)[weakSelf.tableScrollBackGroundView viewWithTag:weakSelf.currentPage + 22220];

        if (isReload) {
            
            weakSelf.currentArticleListArray = [NSMutableArray arrayWithArray:data1];
            
        
            [weakSelf.articleListAllDataDict setObject:data1 forKey:keyC_id];
            
            
            [tableView reloadData];
            
            [tableView.mj_header endRefreshing];
            
        }else{
            
            
            NSString * keyC_id = weakSelf.articleChannelC_idSaveArray[weakSelf.currentPage];
            
            NSLog(@"%@",keyC_id);
            
            NSArray * currentArrayList = [self.articleListAllDataDict objectForKey:keyC_id];
            

            NSMutableArray * newArray = [NSMutableArray arrayWithArray:currentArrayList];
            
            [newArray addObjectsFromArray:data1];
        
            
            weakSelf.currentArticleListArray = [NSMutableArray arrayWithArray:newArray];
            
            [weakSelf.articleListAllDataDict setObject:weakSelf.currentArticleListArray forKey:keyC_id];
            [tableView reloadData];
            [tableView.mj_footer endRefreshing];

        }
    
        
        

    };
    
}


#pragma mark- 下拉刷新
- (void)MJdataReload{
    
    [self.articleChannelPageIndex replaceObjectAtIndex:self.currentPage withObject:@"1"];
    
    [self getArticleListWithC_id:self.articleChannelC_idSaveArray[self.currentPage] andpageIndex:@"1" andUid:self.uid andIsReload:YES];

    
//    [self hidenWhenReview];
}


#pragma mark- 上拉加载
- (void)MJdataLoadMore{

    NSLog(@"%@",self.articleChannelPageIndex);
    
    NSString * currentPageIndex = self.articleChannelPageIndex[self.currentPage];
    
    NSInteger page = [currentPageIndex integerValue];
    
    page ++;
 
    
    NSString * pageIndex = [NSString stringWithFormat:@"%ld",page];
    
    
    [self.articleChannelPageIndex replaceObjectAtIndex:self.currentPage  withObject:pageIndex];
    
    
    NSLog(@"%@",self.articleChannelPageIndex);

    
    [self getArticleListWithC_id:self.articleChannelC_idSaveArray[self.currentPage] andpageIndex:pageIndex andUid:self.uid andIsReload:NO];

}




@end
