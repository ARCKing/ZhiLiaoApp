//
//  TabBarController.m
//  NewApp
//
//  Created by gxtc on 17/2/13.
//  Copyright © 2017年 gxtc. All rights reserved.
//

#import "TabBarController.h"
#import "NavigationController.h"

@interface TabBarController ()

@end

@implementation TabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}


- (instancetype)init{

    if (self = [super init]) {
        
        self.viewControllers = [self addViewControllers];
        //选中时标签栏字体颜色
        UIColor *titleHighlightedColor = [UIColor colorWithRed:20.0/255.0 green:140.0/255.0 blue:220.0/255.0 alpha:1];
        [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:titleHighlightedColor, NSForegroundColorAttributeName,nil] forState:UIControlStateSelected];
    }
    return  self;
}


- (NSArray<__kindof UIViewController *> *)addViewControllers{

    HomeVC * home = [[HomeVC alloc]init];
    NavigationController * homeNav = [[NavigationController alloc]initWithRootViewController:home];
    home.title = @"首页";
    home.navigationItem.title = @"";
    home.tabBarItem.image = [self norOrSltImageName:@"tab_home_no"];
    home.tabBarItem.selectedImage = [self norOrSltImageName:@"tab_home_sel"];
    
    VideoVC * video = [[VideoVC alloc]init];
    NavigationController * vdNav = [[NavigationController alloc]initWithRootViewController:video];
    video.title = @"视频";
    video.tabBarItem.image = [self norOrSltImageName:@"video_nor"];
    video.tabBarItem.selectedImage = [self norOrSltImageName:@"tab_video_slt"];
    
    RankVC * rank = [[RankVC alloc]init];
    NavigationController * rankNav = [[NavigationController alloc]initWithRootViewController:rank];
    rank.title = @"排行榜";
    rank.tabBarItem.image = [UIImage imageNamed:@"tab_rank_no"];
    rank.tabBarItem.selectedImage = [self norOrSltImageName:@"tab_rank_sel"];
    
    MineVC * mine = [[MineVC alloc]init];
    NavigationController * mineNav = [[NavigationController alloc]initWithRootViewController:mine];
    mine.title = @"我的";
    mine.tabBarItem.image = [self norOrSltImageName:@"tab_mine_nor"];
    mine.tabBarItem.selectedImage = [self norOrSltImageName:@"tab_mine_slt"];
    return @[homeNav,vdNav,rankNav,mineNav];
}


- (UIImage *)norOrSltImageName:(NSString *)norOrsltName{

    return [[UIImage imageNamed:norOrsltName] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
}



@end
