//
//  MainVC.m
//  StarClosetDemo
//
//  Created by Mac on 16/7/3.
//  Copyright © 2016年 Mac. All rights reserved.
//

#import "MainVC.h"
#import "SearchVC.h"
#import "WPFHttpManager.h"
#import "WTopScrollModel.h"
@interface MainVC () <UIScrollViewDelegate>
{
    UIScrollView *_bgScrollView;
    UIScrollView *_topScrollView;
    NSTimer *_timer;
    UIPageControl *_pageControl;
     int speed ;
}
@property (nonatomic,strong) NSMutableArray *topDataArr;
@end

@implementation MainVC

#pragma mark - 懒加载数据源
- (NSMutableArray *)topDataArr {
    if (!_topDataArr) {
        _topDataArr = [NSMutableArray array];
    }
    return  _topDataArr;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self startTimer];

}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [_timer invalidate];
    _timer =nil;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationController.navigationBarHidden=YES;
    [self createNivagationBar];
     [self createView];
    [self getTopScrollViewData];
    speed =0;
}

#pragma mark -创建大滚动视图
- (void)createView {
    UIScrollView *bgScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 64, kMainBoundsW, kMainBoundsH)];
    bgScrollView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:bgScrollView];
    _bgScrollView = bgScrollView;
    
}

#pragma mark -创建限时购视图
- (void)createPromotionView {
  

}



#pragma mark -获取顶部滚动视图的数据
- (void)getTopScrollViewData {
 
    __block NSMutableArray * arr = self.topDataArr;
    [WPFHttpManager getMainVCTopScrollViewContent:^(NSArray *array) {
        if (array.count !=0) {
            [arr addObjectsFromArray:array];
            NSLog(@"%ld",arr.count);
            [self reloadScrollView];
        }
    }];
}

#pragma mark -刷新顶部滚动视图
- (void)reloadScrollView {
    NSLog(@"---%ld",self.topDataArr.count);
    UIScrollView *topScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, kMainBoundsW, 200)];
    for (int i=0; i<self.topDataArr.count+2; i++) {
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(kMainBoundsW * i, 0, kMainBoundsW, topScrollView.frame.size.height)];
        if (0==i) {
            WTopScrollModel *model = self.topDataArr[self.topDataArr.count-1];
            [imageView sd_setImageWithURL:[NSURL URLWithString:model.Obj.picUrl]];
        }else if (i==self.topDataArr.count + 1) {
            WTopScrollModel * model =self.topDataArr[0];
            [imageView sd_setImageWithURL:[NSURL URLWithString:model.Obj.picUrl]];
        }else {
            WTopScrollModel *model =self.topDataArr[i-1];
            [imageView sd_setImageWithURL:[NSURL URLWithString:model.Obj.picUrl]];
        }
        [topScrollView addSubview:imageView];
    }
    topScrollView.backgroundColor = [UIColor greenColor];
    topScrollView.pagingEnabled =YES;
    topScrollView.contentSize =CGSizeMake(kMainBoundsW*(self.topDataArr.count+2), 0);
    topScrollView.showsHorizontalScrollIndicator=NO;
    [_bgScrollView addSubview:topScrollView];
    topScrollView.delegate =self;
    _topScrollView = topScrollView;
    UIPageControl *pageControl = [UIPageControl createPageControlWithFrame:CGRectMake(0, 190, kMainBoundsW, 10) numberOfPages:self.topDataArr.count pageIndicatorTintColor:[UIColor redColor] currentPageIndicatorTintColor:[UIColor blueColor]];
    [_bgScrollView addSubview:pageControl];
    _pageControl =pageControl;
}


- (void)startTimer {
 NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:1.5 target:self selector:@selector(autoChangePage) userInfo:nil repeats:YES];
    _timer = timer;
//    [[NSRunLoop currentRunLoop]addTimer:timer forMode:NSRunLoopCommonModes];
//    [[NSRunLoop currentRunLoop]run];
}
- (void)autoChangePage {
    speed++;
    speed = speed%6;
    _topScrollView.contentOffset= CGPointMake(kMainBoundsW*(speed+1), 0);
    _pageControl.currentPage = _topScrollView.contentOffset.x/kMainBoundsW-1;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (_topScrollView == scrollView) {
        scrollView.contentOffset = _topScrollView.contentOffset;
        if (scrollView.contentOffset.x == kMainBoundsW *(self.topDataArr.count + 1)) {
            scrollView.contentOffset =CGPointMake(kMainBoundsW, 0);
            speed =2;
        }if (scrollView.contentOffset.x<0) {
            scrollView.contentOffset=CGPointMake(self.topDataArr.count*kMainBoundsW, 0);
            speed =-speed;
                   }
         _pageControl.currentPage =scrollView.contentOffset.x/kMainBoundsW-1;
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [_timer invalidate];
    _timer = nil;
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    [self startTimer];
}











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
    [search addTarget:self action:@selector(goSearch:) forControlEvents:UIControlEventEditingDidBegin];
    [bgView addSubview:search];
}

#pragma mark -分类按钮点击事件
- (void)classifyBtnClick:(UIButton*)sender {

}
#pragma mark -消息按钮点击事件
- (void)messageBtnClick:(UIButton*)sender {

}

#pragma mark -点击搜索框，进入搜索界面
- (void)goSearch:(UITextField*)sender {
    [sender resignFirstResponder];
    [self.navigationController pushViewController:[SearchVC new] animated:NO];
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
