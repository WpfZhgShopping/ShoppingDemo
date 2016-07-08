//
//  CommunityViewController.m
//  StarClosetDemo
//
//  Created by Mac on 16/7/3.
//  Copyright © 2016年 Mac. All rights reserved.
//

#import "CommunityViewController.h"
#define TopScrollViewHeight  topScrollView.frame.size.height

typedef enum : NSUInteger {
    TopScrollView =1000,
    BGScrollView,
    Chooselabel,
} CommunityView;

@interface CommunityViewController () <UIScrollViewDelegate,UITableViewDataSource,UITableViewDelegate>
{
    UIScrollView *_bgScrollView;
    UIScrollView *_topScrollView;
    int speed;
    NSTimer *_timer;
    UITableView *_contentTableView;
    UISegmentedControl *_segment;

}
@property (nonatomic,strong) NSMutableArray *topScrollViewArr;
@property (nonatomic,strong) NSMutableArray *tableDataArr;
@end

@implementation CommunityViewController

- (NSMutableArray *)topScrollViewArr {
    if (!_topScrollViewArr) {
        _topScrollViewArr =[NSMutableArray array];
    }
    return _topScrollViewArr;
}

- (NSMutableArray *)tableDataArr {
    if (!_tableDataArr) {
        _tableDataArr =[NSMutableArray array];
    }
    return _tableDataArr;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
 
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title =@"社区";
    self.automaticallyAdjustsScrollViewInsets=NO;
    [self createBgScrollView];
    [self getTopScrollViewData];
    [self getDataOfTableView];
    
    speed=0;
}

- (void)getTopScrollViewData {
    __weak NSMutableArray *arr =self.topScrollViewArr;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [WPFHttpManager getCommunityTopScrollViewContent:^(NSArray *array) {
            [arr addObjectsFromArray:array];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self reloadTopScrollView];
            });
        }];
    });
}

- (void)reloadTopScrollView {
    NSMutableArray *arr =[NSMutableArray array];
    for (int i=0; i<self.topScrollViewArr.count ; i++) {
        WcomponentModel *model =self.topScrollViewArr[i];
        NSString* picStr =[[model.picUrl componentsSeparatedByString:@"?"] firstObject];
        [arr addObject:picStr];
    }
   SDCycleScrollView *topScrollView =[SDCycleScrollView  cycleScrollViewWithFrame:CGRectMake(0, 0, kMainBoundsW, 200) imageURLStringsGroup:arr];

    [_bgScrollView addSubview:topScrollView];
}

- (void)createBgScrollView {
    UIScrollView *bgScrollView =[[UIScrollView alloc]initWithFrame:CGRectMake(0,64, kMainBoundsW, kMainBoundsH)];
    bgScrollView.delegate=self;
    bgScrollView.tag=BGScrollView;
    [self.view addSubview:bgScrollView];
    _bgScrollView =bgScrollView;

}


#pragma mark -获取tableview的数据
- (void)getDataOfTableView {
    __weak NSMutableArray *arr =self.tableDataArr;
        [WPFHttpManager getCommunityTableViewContent:^(NSArray *array) {
           
            [arr addObjectsFromArray:array];
             NSLog(@"--%ld",[[arr[0] commentCount]integerValue]);
            [self createTableView];
        }];
}


#pragma mark -创建热门/关注/红人的tableView视图
- (void)createTableView {
    UITableView *contentTableView =[[UITableView alloc]initWithFrame:CGRectMake(0, 200, kMainBoundsW, kMainBoundsH) style:UITableViewStylePlain];
    contentTableView.backgroundColor =[UIColor lightGrayColor];
    contentTableView.delegate=self;
    contentTableView.dataSource =self;
    contentTableView.scrollEnabled=NO;
    contentTableView.separatorStyle =UITableViewCellSeparatorStyleNone;
    [_bgScrollView addSubview:contentTableView];
    _contentTableView=contentTableView;
    [contentTableView registerClass:[HotCell class] forCellReuseIdentifier:@"contentCell"];
    _bgScrollView.contentSize =CGSizeMake(0, self.tableDataArr.count* 550+280);
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.tableDataArr.count;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HotCell *cell =[tableView dequeueReusableCellWithIdentifier:@"contentCell"];
    cell.obj=self.tableDataArr[indexPath.row];
    NSLog(@"%@",cell.obj.pics);
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 550;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 42;
}

- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view =[UIView new];
    view.backgroundColor =[UIColor whiteColor];
        NSArray *titleArr =@[@"热门",@"关注",@"红人"];
        UISegmentedControl *segment =[[UISegmentedControl alloc]initWithItems:titleArr];
        segment.frame=CGRectMake(0, 0, kMainBoundsW, 40);
        segment.momentary=YES;
        [segment addTarget:self action:@selector(changeFrame:) forControlEvents:UIControlEventValueChanged ];
        [view addSubview:segment];
        _segment=segment;
        segment.tintColor =[UIColor magentaColor];
        UILabel *label =[[UILabel alloc]initWithFrame:CGRectMake(kMainBoundsW/3,40, kMainBoundsW/3, 2)];
        label.tag =Chooselabel;
        label.backgroundColor =[UIColor redColor];
        [view addSubview:label];
        [view bringSubviewToFront:label];

    return view;
}


- (void)changeFrame:(UISegmentedControl*)sender {
    UILabel *label =[_bgScrollView viewWithTag:Chooselabel];
    switch (sender.selectedSegmentIndex) {
        case 0:
            label.frame=CGRectMake(0, label.frame.origin.y, kMainBoundsW/3, 2);
            break;
        case 1:
            label.frame=CGRectMake(kMainBoundsW/3, label.frame.origin.y, kMainBoundsW/3, 2);
            break;
        case 2:
            label.frame=CGRectMake(kMainBoundsW*2/3, label.frame.origin.y, kMainBoundsW/3, 2);
            break;
        default:
            break;
    }
    
    
}


#pragma mark -实现滚动视图代理方法
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (_topScrollView ==scrollView) {
        scrollView.contentOffset =_topScrollView.contentOffset;
    }
    if (_bgScrollView==scrollView) {
        if (_bgScrollView.contentOffset.y<200) {
            _contentTableView.contentOffset=CGPointMake(0, 0);
        }
        if (_bgScrollView.contentOffset.y>200) {
            _contentTableView.center =CGPointMake(_contentTableView.center.x, scrollView.contentOffset.y+self.view.center.y);
            CGPoint offset =CGPointMake(scrollView.contentOffset.x, scrollView.contentOffset.y-200);
            _contentTableView.contentOffset=offset;
        }
        
    }
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
