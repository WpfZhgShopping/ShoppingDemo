//
//  MainVC.m
//  StarClosetDemo
//
//  Created by Mac on 16/7/3.
//  Copyright © 2016年 Mac. All rights reserved.
//

#import "MainVC.h"

@interface MainVC ()

@end

@implementation MainVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationController.navigationBarHidden=YES;
    [self createNivagationBar];
}

<<<<<<< HEAD
- (void)createView {



}





=======
#pragma mark -自定义导航条
- (void)createNivagationBar{
    UIView * bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kMainBoundsW, 64)];
    [self.view addSubview:bgView];
    
    UIButton* leftBtn =[UIButton buttonWithType:UIButtonTypeCustom];
    leftBtn.frame=CGRectMake(20, 22, 20, 20);
    [leftBtn setBackgroundImage:[UIImage imageNamed:@"bottom_head_sort"] forState:UIControlStateNormal];
    [leftBtn addTarget:self action:@selector(classifyBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [bgView addSubview:leftBtn];
    
    UILabel *leftLabel =[UILabel labelWithTitle:@"分类" color:SDColor(138, 138, 138, 1) fontSize:13 alignment:NSTextAlignmentCenter];
    leftLabel.frame=CGRectMake(leftBtn.frame.origin.x-10, 42, 40, 20);
    [bgView addSubview:leftLabel];
    
    UIButton* rightBtn =[UIButton buttonWithType:UIButtonTypeCustom];
    rightBtn.frame=CGRectMake(kMainBoundsW-40, 22, 20, 20);
    [rightBtn setBackgroundImage:[UIImage imageNamed:@"button_head_massage"] forState:UIControlStateNormal];
    [rightBtn addTarget:self action:@selector(messageBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [bgView addSubview:rightBtn];

    UILabel *rightLabel =[UILabel labelWithTitle:@"消息" color:SDColor(138, 138, 138, 1) fontSize:13 alignment:NSTextAlignmentCenter];
   rightLabel.frame =CGRectMake(rightBtn.frame.origin.x-10, 42, 40, 20);
    [bgView addSubview:rightLabel];
    
    UITextField *search = [[UITextField alloc]initWithFrame:CGRectMake(kMainBoundsW/2-150, 22, 300, 40)];
    
    search.placeholder = @"  🔍  单品/品牌/红人";
    search.backgroundColor = [UIColor colorWithRed:138/255.0 green:138/255.0 blue:138/255.0 alpha:0.3];
    search.clearButtonMode =UITextFieldViewModeWhileEditing;
    search.userInteractionEnabled = NO;
    [bgView addSubview:search];
    UIButton* searchBtn =[UIButton buttonWithType:UIButtonTypeSystem];
    searchBtn.frame=CGRectMake(kMainBoundsW/2-150, 22, 300, 40);
    [searchBtn addTarget:self action:@selector(searchBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [bgView addSubview:searchBtn];

    
    
}

#pragma mark -分类按钮点击事件
- (void)classifyBtnClick:(UIButton*)sender {

}
#pragma mark -消息按钮点击事件
- (void)messageBtnClick:(UIButton*)sender {

}

#pragma mark -点击搜索按钮
- (void)searchBtnClick:(UIButton *)sender {
   
}
>>>>>>> master





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
