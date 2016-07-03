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
   UINavigationController *mainNav =[self setTabItem:[MainVC class] withTitle:@"首页" withImage:@"bottom_home_icon" selectedImage:@"bottom_home_icon_on"];
    
    UINavigationController *matchNav = [self setTabItem:[MatchViewController class] withTitle:@"搭配" withImage:@"bottom_dapei_icon" selectedImage:@"bottom_dapei_icon_on"];
    
    UINavigationController *communityNav = [self setTabItem:[CommunityViewController class] withTitle:@"社区" withImage:@"bottom_bbs_icon" selectedImage:@"bottom_bbs_icon_on"];
    
     UINavigationController *shoppingNav = [self setTabItem:[ShoppingCarViewController class] withTitle:@"购物车" withImage:@"bottom_shopping_icon" selectedImage:@"bottom_shopping_icon_on"];
    
    UINavigationController *personNav = [self setTabItem:[PersonInfoVC class] withTitle:@"我的" withImage:@"bottom_like_icon" selectedImage:@"bottom_like_icon_on"];

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

- (UINavigationController*)setTabItem:(Class)VC withTitle:(NSString *)title withImage:(NSString*)image selectedImage:(NSString*)selectImage{
    UINavigationController *Nav = [[UINavigationController alloc]initWithRootViewController:[VC new]];
    UITabBarItem * Item = [[UITabBarItem alloc]initWithTitle:title  image:[UIImage imageNamed:image] selectedImage:[UIImage imageNamed:selectImage]];
    Nav.tabBarItem = Item;
    [self setupAttributes:Item];
    return Nav;
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
