//
//  MytabBarVC.m
//  StarClosetDemo
//
//  Created by Mac on 16/7/3.
//  Copyright © 2016年 Mac. All rights reserved.
//

#import "MytabBarVC.h"
#import "CommunityViewController.h"
#import "HichaoVC/ManStoreViewController.h"
#import "MatchViewController.h"
#import "ShoppingCarViewController.h"
#import "PersonInfoVC.h"
#import "MainVC.h"
@interface MytabBarVC ()

@end

@implementation MytabBarVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.tabBar.tintColor = [UIColor redColor];
 [self createView];
}

- (void)createView {
    UINavigationController *mainNav = [[UINavigationController alloc]initWithRootViewController:[MainVC new]];
    UITabBarItem * mainItem = [[UITabBarItem alloc]initWithTitle:@"首页" image:[UIImage imageNamed:@"bottom_home_icon"] selectedImage:[UIImage imageNamed:@"bottom_home_icon_on"]];
    mainNav.tabBarItem = mainItem;
    [self setupAttributes:mainItem];
    
    UINavigationController *communityNav = [[UINavigationController alloc]initWithRootViewController:[CommunityViewController new]];
    UITabBarItem * communityItem = [[UITabBarItem alloc]initWithTitle:@"社区" image:[UIImage imageNamed:@"bottom_bbs_icon"] selectedImage:[UIImage imageNamed:@"bottom_bbs_icon_on"]];
    communityNav.tabBarItem = communityItem;
    [self setupAttributes:communityItem];
    
    UINavigationController *matchNav = [[UINavigationController alloc]initWithRootViewController:[MatchViewController new]];
    UITabBarItem * matchItem = [[UITabBarItem alloc]initWithTitle:@"搭配" image:[UIImage imageNamed:@"bottom_dapei_icon"] selectedImage:[UIImage imageNamed:@"bottom_dapei_icon_on"]];
    matchNav.tabBarItem = matchItem;
    [self setupAttributes:matchItem];
    
    UINavigationController *shoppingNav =[[UINavigationController alloc]initWithRootViewController:[ShoppingCarViewController new]];
    UITabBarItem *shoppingItem = [[UITabBarItem alloc]initWithTitle:@"购物车" image:[UIImage imageNamed:@"bottom_shopping_icon"] selectedImage:[UIImage imageNamed:@"bottom_shopping_icon_on"]];
    shoppingNav.tabBarItem = shoppingItem;
    [self setupAttributes:shoppingItem];
    
    UINavigationController *personNav = [[UINavigationController alloc]initWithRootViewController:[PersonInfoVC new]];
    UITabBarItem *personItem = [[UITabBarItem alloc]initWithTitle:@"我的" image:[UIImage imageNamed:@"bottom_like_icon"] selectedImage:[UIImage imageNamed:@"bottom_like_icon_on"]];
    personNav.tabBarItem = personItem;
    [self setupAttributes:personItem];
    self.viewControllers = @[mainNav,matchNav,communityNav,shoppingNav,personNav];
    
}

- (void)setupAttributes:(UITabBarItem*)item{
    NSMutableDictionary *SelectAttrs = [NSMutableDictionary dictionary];
    SelectAttrs[NSForegroundColorAttributeName] = [[UIColor alloc]initWithRed:252/255.0 green:13/255.0 blue:103/255.0 alpha:1];
    SelectAttrs[NSFontAttributeName] = [UIFont systemFontOfSize:16];
    [item setTitleTextAttributes:SelectAttrs forState:UIControlStateSelected];
    NSMutableDictionary *normalAttrs =[NSMutableDictionary dictionary];
    normalAttrs[NSForegroundColorAttributeName]= [[UIColor alloc]initWithRed:113/255.0 green:109/255.0 blue:104/255.0 alpha:1];
    normalAttrs[NSFontAttributeName] = [UIFont systemFontOfSize:16];
    [item setTitleTextAttributes:normalAttrs forState:UIControlStateNormal];
}






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
