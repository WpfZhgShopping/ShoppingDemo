//
//  MatchViewController.m
//  StarClosetDemo
//
//  Created by Mac on 16/7/3.
//  Copyright © 2016年 Mac. All rights reserved.
//

#import "MatchViewController.h"
#import "UICollectionViewFlowWaterLayout.h"
#import "zMatchTool.h"
#import "zMatchNodel.h"
#import "SDImageCache.h"
#import "MatchCell.h"
#import "zTableModel.h"





#define CELLWITCH kMainBoundsW / 2 - 4
#define TOPBUTTONTAG 100
#define CELLIMAGE (kMainBoundsW / 2 - 4) / [model.width floatValue] * [model.height floatValue]

@interface MatchViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,FlowWaterDelegate,UITableViewDelegate,UITableViewDataSource,UITableViewDelegate>{
    NSMutableArray *sfnArray;
    NSMutableArray *fnArray;
    UIView *bgview;
    UIView *BTView;
    UIView *_SlideView;
    CGFloat _cellFloat;
    NSMutableArray *_dataArray;
    UICollectionView *_collectView;
    UICollectionView *_rightCollectView;
    UITableView *_table;
    NSMutableArray *_tableDataArr;
    NSMutableArray *_urlArray;
    UILabel *_refresh;
    UIScrollView *scroll;
    UIView *_gengDuoView;
    
    
}
@property (nonatomic,retain) UIRefreshControl *refreshControl NS_AVAILABLE_IOS(9_0);

@end

@implementation MatchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBarHidden = YES;
    
    
    [self createNAV];
    [self createCollectionView];
    [self dataArray];
    [self createView];
    [self refresh];
    [self createScrollView];
    
    _dataArray = @[].mutableCopy;
    _tableDataArr = @[].mutableCopy;
  
   
    
    
}

#pragma mark -下拉刷新
-(void)refresh{
    UILabel *refresh = [[UILabel alloc] initWithFrame:CGRectMake(0, -50, kMainBoundsW, 50)];
    refresh.text  = @"下拉刷新";
   _refresh = refresh;
    _refresh.tag = 0;
    [_collectView addSubview:refresh];

}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    if (scrollView.contentOffset.y <= -50) {
        
        if (_refresh.tag == 0) {
            _refresh.text = @"松开刷新";
        }
        _refresh.tag = 1;
        
    }else{
        
        _refresh.tag = 0;
        _refresh.text = @"下拉刷新";
    }
}
- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset{
    
    if (_refresh.tag == 1)
        [UIView animateWithDuration:3 animations:^{
            _refresh.text = @"加载中";
            scrollView.contentInset = UIEdgeInsetsMake(50.0f, 0.0f, 0.0f, 0.0f);
            
            [self dataArray];
            
        }];
        
    
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 2 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
            
            [UIView animateWithDuration:.3 animations:^{
                
                _refresh.tag = 0;
                _refresh.text = @"下拉刷新";
                scrollView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
            }];
        });
    }




#pragma mark -数据源
-(void)dataArray{

    [zMatchTool getWtchMatch:@"http://api-v2.mall.hichao.com/star/list?category=%E5%85%A8%E9%83%A8&lts=&pin=&flag=&gc=appstore&gf=iphone&gn=mxyc_ip&gv=6.6.3&gi=CBD795AD-1BFC-40FE-A351-407FEAC7219D&gs=640x1136&gos=8.4.1&access_token=" wtchBlock:^(NSMutableArray *Array) {
        _dataArray = Array;
        
        if (_dataArray != nil) {
            [_collectView reloadData];
        }
    }];
    
    [zMatchTool getWtchMatch:@"http://api-v2.mall.hichao.com/mix_topics?flag=&gc=appstore&gf=iphone&gn=mxyc_ip&gv=6.6.3&gi=CBD795AD-1BFC-40FE-A351-407FEAC7219D&gs=640x1136&gos=8.4.1&access_token=" wtchtableBlock:^(NSMutableArray *Array) {
        _tableDataArr = Array;
        if (_tableDataArr != nil) {
            [_table reloadData];
        }

    }];
    
    
}
#pragma mark -创建NAV
-(void)createNAV{
  
    sfnArray = [NSMutableArray arrayWithObjects:@"最新",@"热门",@"欧美",@"日韩",@"本土",@"型男", nil];
    fnArray = [NSMutableArray arrayWithObjects:@"轻熟",@"派对",@"运动",@"丰满",@"摩登",@"街头",@"高挑",@"OL",@"休闲",@"娇小",@"约会",@"逛街",@"出游",@"闺蜜",@"清新",@"典礼",@"优选",@"甜美",@"复古",@"混搭", nil];
    UIView *bjView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kMainBoundsW, 64)];
    bjView.backgroundColor = [UIColor greenColor];
    [self.view addSubview:bjView];
    [self.view bringSubviewToFront:bjView];
    NSArray * arr = @[@"搭配",@"专题"];
    for (NSInteger i = 0; i < 2; i++) {
        UIButton* Btn = [UIButton buttonWithType:UIButtonTypeCustom];
        Btn.frame = CGRectMake((kMainBoundsW/2 - 100) +100 * i , 20, 100, 44);
       [Btn setTitle:arr[i] forState:UIControlStateNormal];
        [Btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [Btn setTitleColor:[UIColor redColor] forState:UIControlStateSelected];
        Btn.tag = TOPBUTTONTAG +i;
        [Btn addTarget:self action:@selector(topButton:) forControlEvents:UIControlEventTouchUpInside];
        [bjView addSubview:Btn];
        
    }
    UIButton *messageBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    messageBtn.frame = CGRectMake(kMainBoundsW - 50, 20, 44, 44);
    [messageBtn setImage:[UIImage imageNamed:@"button_head_massage"] forState:UIControlStateNormal];
    [messageBtn addTarget:self action:@selector(messageBtn:) forControlEvents:UIControlEventTouchUpInside];
    [bjView addSubview:messageBtn];
    
    _SlideView = [[UIView alloc]initWithFrame:CGRectMake(kMainBoundsW/2 - 100, 59, 100, 5)];
    _SlideView.backgroundColor = [UIColor redColor];
    [self.view addSubview:_SlideView];
    

    
    
}

#pragma mark - NAV上Button上的点击事件

-(void)topButton:(UIButton *)sender{
    if (sender.tag == TOPBUTTONTAG) {
        _SlideView.frame = CGRectMake(kMainBoundsW/2 - 100, 59, 100, 5);
        
        _collectView.frame = CGRectMake(0, 64, kMainBoundsW, kMainBoundsH);
        _table.frame = CGRectMake( 0, 0, 0, 0);

        
    }else{
        _SlideView.frame = CGRectMake(kMainBoundsW/2 , 59, 100, 5);
    
        _collectView.frame = CGRectMake(0, 0, 0, 0);
        [self createTable];
    }
    
}

#pragma mark - 消息的点击事件

-(void)messageBtn:(UIButton *)sender{
    
}

#pragma mark - 创建副标题
-(void)createView{
    if (BTView) {
        [BTView removeFromSuperview];
        
    }
   _urlArray = [NSMutableArray arrayWithObjects:@"http://api-v2.mall.hichao.com/star/list?category=%E5%85%A8%E9%83%A8&lts=&pin=&flag=&gc=appstore&gf=iphone&gn=mxyc_ip&gv=6.6.3&gi=2EB93627-1BBD-40F0-B217-AC280C427C51&gs=640x1136&gos=9.3.2&access_token=",@"http://api-v2.mall.hichao.com/star/list?category=%E7%83%AD%E9%97%A8&lts=&pin=&flag=&gc=appstore&gf=iphone&gn=mxyc_ip&gv=6.6.3&gi=2EB93627-1BBD-40F0-B217-AC280C427C51&gs=640x1136&gos=9.3.2&access_token=",@"http://api-v2.mall.hichao.com/star/list?category=%E6%AC%A7%E7%BE%8E&lts=&pin=&flag=&gc=appstore&gf=iphone&gn=mxyc_ip&gv=6.6.3&gi=2EB93627-1BBD-40F0-B217-AC280C427C51&gs=640x1136&gos=9.3.2&access_token=",@"http://api-v2.mall.hichao.com/star/list?category=%E6%97%A5%E9%9F%A9&lts=&pin=&flag=&gc=appstore&gf=iphone&gn=mxyc_ip&gv=6.6.3&gi=2EB93627-1BBD-40F0-B217-AC280C427C51&gs=640x1136&gos=9.3.2&access_token=",@"http://api-v2.mall.hichao.com/star/list?category=%E6%9C%AC%E5%9C%9F&lts=&pin=&flag=&gc=appstore&gf=iphone&gn=mxyc_ip&gv=6.6.3&gi=2EB93627-1BBD-40F0-B217-AC280C427C51&gs=640x1136&gos=9.3.2&access_token=", @"http://api-v2.mall.hichao.com/star/list?category=%E5%9E%8B%E7%94%B7&lts=&pin=&flag=&gc=appstore&gf=iphone&gn=mxyc_ip&gv=6.6.3&gi=2EB93627-1BBD-40F0-B217-AC280C427C51&gs=640x1136&gos=9.3.2&access_token=",@"",nil];
    
    BTView = [[UIView alloc]initWithFrame:CGRectMake(0, 64, kMainBoundsW - 60, 40)];
    [self.view addSubview:BTView];
    UIScrollView *scor = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, kMainBoundsW - 60, 40)];
    scor.contentSize = CGSizeMake(kMainBoundsW/5*sfnArray.count, 40);
    scor.backgroundColor = [UIColor orangeColor];
    [BTView addSubview:scor];
    
    for (NSInteger i = 0; i < sfnArray.count; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(kMainBoundsW / 5 * i, 0, kMainBoundsW/5, 40);
        [btn setTitle:sfnArray[i] forState:UIControlStateNormal];
        btn.tag = 500 + i;
        [btn addTarget:self action:@selector(fuBiaoTi:) forControlEvents:UIControlEventTouchUpInside];
        [btn setTitleColor:[UIColor blueColor] forState:UIControlStateSelected];
        [scor addSubview:btn];
    }
    UIButton *gdBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    gdBtn.frame = CGRectMake(kMainBoundsW - 60, 64, 60, 40);
    gdBtn.backgroundColor = [UIColor orangeColor];
    [gdBtn setTitle:@"更多" forState:UIControlStateNormal];
    [gdBtn addTarget:self action:@selector(gengDuo:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:gdBtn];
}
-(void)gengDuo:(UIButton *)sender{
    [self createPinDaoDingZhi];
    
}

#pragma mark - 副标题上点击事件

-(void)fuBiaoTi:(UIButton *)sender{
    
    if (sender.tag - 500) {
        NSLog(@"%ld",sender.tag - 500);
        
        [zMatchTool getWtchMatch:_urlArray[sender.tag-500] wtchBlock:^(NSMutableArray *Array) {
            _dataArray = Array;
            
            if (_dataArray != nil) {
                [_collectView reloadData];
            }
        }];
    }
  

    
    
}
#pragma mark - 频道订制
-(void)createPinDaoDingZhi{
    if (bgview) {
        [bgview removeFromSuperview];
    }
    _collectView.frame = CGRectMake(0, 0, kMainBoundsW, 0.001);
    bgview = [[UIView alloc]initWithFrame:CGRectMake(0, 64,kMainBoundsW, kMainBoundsH)];
    [bgview removeFromSuperview];
    bgview.backgroundColor = [UIColor redColor];
    [self.view addSubview:bgview];
    UIView *topView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kMainBoundsW, 40)];
    topView.backgroundColor = [UIColor blueColor];
    [bgview addSubview:topView];
    UILabel *topLable = [UILabel new];
    topLable.center = topView.center;
    topLable.bounds = CGRectMake(0, 0, 200, 40);
    topLable.text = @"频道订制";
    topLable.font = [UIFont systemFontOfSize:25];
    topLable.textAlignment = 1;
    [topView addSubview:topLable];
    UIButton *GDBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    GDBtn.frame = CGRectMake(kMainBoundsW -100, 0, 50, 40);
    [GDBtn setTitle:@"更多" forState:UIControlStateNormal];
    [GDBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [GDBtn addTarget:self action:@selector(gengDuoFanHui:) forControlEvents:UIControlEventTouchUpInside];
    [topView addSubview:GDBtn];
    UIView *zhongJView = [[UIView alloc]initWithFrame:CGRectMake(0, 40, kMainBoundsW, bgview.frame.size.height - 40)];
    [bgview addSubview:zhongJView];
    UILabel *myLable = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, kMainBoundsW - 100, 30)];
    myLable.text = @"我的分类";
    [zhongJView addSubview:myLable];
    UIButton *bjBtn = [[UIButton alloc]initWithFrame:CGRectMake(kMainBoundsW - 100, 0, 40, 40)];
 
    [bjBtn setTitle:@"编辑" forState:UIControlStateNormal];
    [bjBtn setTitle:@"完成" forState:UIControlStateSelected];
    [bjBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [bjBtn addTarget:self action:@selector(compile:) forControlEvents:UIControlEventTouchUpInside];
    [zhongJView addSubview:bjBtn];
    
    for (NSInteger i = 0; i < sfnArray.count; i++) {
        UIButton *XBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        XBtn.frame = CGRectMake((10 + ((kMainBoundsW - 30)/4 + 10)*(i%4)), 40 + 40*(i/4), kMainBoundsW/4, 40);
        XBtn.tag = 2000 + i;
        [XBtn addTarget:self action:@selector(wodefenlei:) forControlEvents:UIControlEventTouchUpInside];
        [XBtn setTitle:[NSString stringWithFormat:@"%@",sfnArray[i]] forState:UIControlStateNormal];
        [zhongJView addSubview:XBtn];
    }

    
    UIView *xView = [[UIView alloc]initWithFrame:CGRectMake(0,120 + sfnArray.count/4 * 40, kMainBoundsW, kMainBoundsH - 160)];
    xView.backgroundColor = [UIColor greenColor];
    [bgview addSubview:xView];
    UILabel *qtjLable = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, kMainBoundsW, 40)];
    qtjLable.text = @"点击添加分类";
    [xView addSubview:qtjLable];

    for (NSInteger i = 0; i < fnArray.count; i++) {
        UIButton *XBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        XBtn.frame = CGRectMake((10 + ((kMainBoundsW - 30)/4 + 10)*(i%4)), 40 + 40*(i/4), kMainBoundsW/4, 40);
        XBtn.tag = 3000 + i;
        [XBtn addTarget:self action:@selector(addFenLei:) forControlEvents:UIControlEventTouchUpInside];
        [XBtn setTitle:[NSString stringWithFormat:@"%@",fnArray[i]] forState:UIControlStateNormal];
        [xView addSubview:XBtn];
    }
    
    
    
    
    
}
#pragma mark - 返回主界面
-(void)gengDuoFanHui:(UIButton *)sender{
    _collectView.frame = CGRectMake(0, 0, kMainBoundsW, kMainBoundsH);
    if (bgview) {
        [bgview removeFromSuperview];
    }
    [self createView];
    
    
}
#pragma mark - 我的分类
-(void)wodefenlei:(UIButton *)sender{
    NSLog(@"%ld",sender.tag);
    NSInteger num = sender.tag - 2000;
    [fnArray addObject:sfnArray[num]];
    [sfnArray removeObjectAtIndex:num];
    [self createPinDaoDingZhi];
}
#pragma mark - 添加分类

-(void)addFenLei:(UIButton *)sender{
    NSLog(@"%ld",sender.tag);
    NSInteger num = sender.tag - 3000;
    [sfnArray addObject:fnArray[num]];
    [fnArray removeObjectAtIndex:num];
    [self createPinDaoDingZhi];
}


-(void)compile:(UIButton *)sender{
    
    
    
}

#pragma mark -创建瀑布流
-(void)createCollectionView{
    UICollectionViewFlowWaterLayout *layout = [UICollectionViewFlowWaterLayout new];
    layout.delegate = self;
    
    layout.itemWith = CELLWITCH;
    layout.columnCount = 2;
    layout.sectionInset = UIEdgeInsetsMake(0, 0, 5, 0);
    
   
        
    
    UICollectionView *collectView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, kMainBoundsW, kMainBoundsH)  collectionViewLayout:layout];
    collectView.delegate = self;
    collectView.dataSource = self;
    collectView.backgroundColor = [UIColor whiteColor];
    [collectView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cellID"];
    _collectView = collectView;
    
    UICollectionView *collectView1 = [[UICollectionView alloc]initWithFrame:CGRectMake(kMainBoundsW, 0, kMainBoundsW, kMainBoundsH)  collectionViewLayout:layout];
    collectView1.delegate = self;
    collectView1.dataSource = self;
    collectView1.backgroundColor = [UIColor whiteColor];
    [collectView1 registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cellID"];
    _rightCollectView = collectView1;
   
    
    
    
}

#pragma mark - collectionView的方法
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return _dataArray.count;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cellID" forIndexPath:indexPath];
    
    for (UIView *view in cell.contentView.subviews) {
            [view removeFromSuperview];
    }
    
    UIView *bjView = [[UIView alloc]initWithFrame:cell.contentView.frame];
    
    [cell.contentView addSubview:bjView];
   
    
    zMatchNodel *model = _dataArray[indexPath.row];
    UIImageView *image = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, CELLWITCH, CELLIMAGE)];
    
    NSString *picURL = model.picUrl;
    if ([model.picUrl containsString:@"?"]) {
        picURL = [model.picUrl componentsSeparatedByString:@"?"][0];
        
    }
    [image sd_setImageWithURL:[NSURL URLWithString:picURL]];
    [bjView addSubview:image];
    
    UILabel *lable = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(image.frame) + 2, CELLWITCH, 20)];
    lable.text = model.biaoti;
    [bjView addSubview:lable];
    UILabel *itemsLable = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(lable.frame) + 2, cell.width/2, 20)];
   itemsLable.text = [NSString stringWithFormat:@"🔗%@",model.itemsCount];
   

    [bjView addSubview:itemsLable];
    UIButton *btn2 = [UIButton buttonWithType:UIButtonTypeCustom];
    btn2.frame = CGRectMake(cell.width/2 - 50, image.height+lable.height + 5, CELLWITCH/2, 20);
    [btn2 setTitle:[NSString stringWithFormat:@"❤️%@",model.collectionCount]  forState:UIControlStateNormal];
    [btn2 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//    NSLog(@"=======>>>>>%@",model.collectionCount);
    [bjView addSubview:btn2];
   
    
    cell.backgroundColor = [UIColor whiteColor];
    
    return cell;
}


- (CGFloat)getHeight:(NSIndexPath *)indexPath {
    
    zMatchNodel *model = _dataArray[indexPath.row];
    CGFloat h = CELLIMAGE + 40;
    
    return h;
}
#pragma make - 创建专题的tableView
-(void)createTable{
    _table = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, kMainBoundsW, kMainBoundsH) style:UITableViewStylePlain];
    _table.delegate = self;
    _table.dataSource = self;
    [self.view addSubview:_table];
    [_table registerNib:[UINib nibWithNibName:@"MatchCell" bundle:nil] forCellReuseIdentifier:@"CELL"];
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 360;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return _tableDataArr.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MatchCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CELL"];
    zTableModel *model = _tableDataArr[indexPath.row];
    
    cell.title.text = model.title;
    cell.day.text = [NSString stringWithFormat:@"%@.%@.%@",model.year ,model.month,model.day];
    
    cell.biaoqian.text = model.category;
    NSString *picURL = model.picUrl;
    if ([model.picUrl containsString:@"?"]) {
        picURL = [model.picUrl componentsSeparatedByString:@"?"][0];
    }
    [cell.image sd_setImageWithURL:[NSURL URLWithString:picURL]];
    
    [cell.liftBTN setTitle:[NSString stringWithFormat:@"%@",model.commentCount] forState:UIControlStateNormal];
    [cell.liftBTN setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    [cell.rightBTN setTitle:[NSString stringWithFormat:@"%@",model.collectionCount] forState:UIControlStateNormal];
    [cell.rightBTN setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
   [cell.zhongBTN setTitle:[NSString stringWithFormat:@"%@",model.v] forState:UIControlStateNormal];
   [cell.zhongBTN setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    return cell;
}
#pragma mark - 创建ScrollView
-(void)createScrollView{
    scroll = [[UIScrollView alloc] init];
    scroll.frame = CGRectMake(0, 104, kMainBoundsW, kMainBoundsH);
    scroll.backgroundColor = [UIColor yellowColor];
    [scroll addSubview:_collectView];
    [scroll addSubview:_rightCollectView];
    scroll.delegate=self;
    [self.view addSubview:scroll];
    
    scroll.contentSize = CGSizeMake(scroll.width * _urlArray.count, scroll.height);
    scroll.pagingEnabled = YES;

    
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    NSInteger index = scroll.contentOffset.x / kMainBoundsW;
    if (index % 2 == 0) {
        _collectView.frame =CGRectMake(kMainBoundsW * index, 0, kMainBoundsW, kMainBoundsH);
    }else if(index % 2 == 1){
        _rightCollectView.frame = CGRectMake(kMainBoundsW * index, 0, kMainBoundsW, kMainBoundsH);
    }
    
    [zMatchTool getWtchMatch:_urlArray[index] wtchBlock:^(NSMutableArray *Array) {
        _dataArray = Array;
        
        if (_dataArray != nil) {
            [_collectView reloadData];
        }
    }];

    
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
