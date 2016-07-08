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
#import "PromotionModel.h"
typedef enum : NSUInteger {
    //顶部滚动视图
    TopScrollView = 100,
    //大滚动视图
    BackgroundScrollView,
    //各馆tableView
    BottomTableView,
    //瀑布流视图
    WaterFallCollectionView,
} MyScrollView;

typedef enum : NSUInteger {
    ChinaScrollView = 2000,
    JepanScrollView,
    EuropeScrollView,
    GlobalScrollView,
    KoreaScrollView,
    BeautyScrollView,
} PicScrollView;

@interface MainVC () <UIScrollViewDelegate,UITableViewDataSource,UITableViewDelegate,UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>
{
    UIScrollView *_bgScrollView;
    UIScrollView *_topScrollView;
    NSTimer *_timer;
    UIPageControl *_pageControl;
     int speed ;
    UIView *_bgView;
    UITableView *_myTableView;
    float _colHeight;
    UICollectionView *_collectionView;
    UIView *_headerView;
    NSInteger index;
}
@property (nonatomic,strong) NSMutableArray *topDataArr;
@property (nonatomic,strong) NSMutableArray *promotionDataArr;
@property (nonatomic,strong) NSMutableArray *regionDataArr;
@property (nonatomic,strong) NSMutableArray *latestStyleDataArr;
@end

@implementation MainVC

#pragma mark - 懒加载数据源
- (NSMutableArray *)topDataArr {
    if (!_topDataArr) {
        _topDataArr = [NSMutableArray array];
    }
    return  _topDataArr;
}

- (NSMutableArray *)promotionDataArr {
    if (!_promotionDataArr) {
        _promotionDataArr =[NSMutableArray array];
    }
    return  _promotionDataArr;
}

- (NSMutableArray *)regionDataArr {
    if (!_regionDataArr) {
        _regionDataArr =[NSMutableArray array];
    }
    return _regionDataArr;
}

- (NSMutableArray *)latestStyleDataArr {
    if (!_latestStyleDataArr) {
        _latestStyleDataArr =[NSMutableArray array];
    }
    return _latestStyleDataArr;
}

#pragma mark -视图将要出现时启动定时器
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden=YES;
    UIView *view =[self.view viewWithTag:20];
    [view removeFromSuperview];
    [self createNivagationBar];
    [self startTimer];
    [self refreshInfo];
}
#pragma mark -视图将要消失时销毁定时器
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [_timer invalidate];
    _timer =nil;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.automaticallyAdjustsScrollViewInsets=NO;
    self.navigationController.navigationBarHidden=YES;
    UIView *view =[self.view viewWithTag:20];
    [view removeFromSuperview];
    [self createNivagationBar];
     [self createView];
    [self getTopScrollViewDataWithBlock:nil];
    speed =0;
   [self getPromotionViewDataWithBlock:nil];
    [self getBottomViewDataWithBlock:nil];
    [self getNewStyleData:1 WithBlock:nil];
    [self creatNewStyleView];
}

#pragma mark -创建大滚动视图
- (void)createView {
    UIScrollView *bgScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 64, kMainBoundsW, kMainBoundsH)];
    bgScrollView.backgroundColor = [UIColor lightGrayColor];
    bgScrollView.tag=BackgroundScrollView;
    bgScrollView.delegate=self;
    [self.view addSubview:bgScrollView];
    _bgScrollView = bgScrollView;
    [self refreshInfo];
    
    }

#pragma mark -获取新款服装的数据
- (void)getNewStyleData:(NSInteger)tag WithBlock:(void(^)(void))block{
    [self.latestStyleDataArr removeAllObjects];
    __weak NSMutableArray *arr =self.latestStyleDataArr;
    [WPFHttpManager getNewStyleViewContent:tag withBlock:^(NSArray *array) {
        if (array.count!=0) {
            [arr addObjectsFromArray:array];
            UICollectionView *collectionView =[_bgScrollView viewWithTag:WaterFallCollectionView];
            [collectionView reloadData];
        }
    }];
}

#pragma mark -刷新最新款服饰视图
- (void)creatNewStyleView {
    XLPlainFlowLayout *layout =[XLPlainFlowLayout new];
    layout.naviHeight =0;
    layout.scrollDirection =UICollectionViewScrollDirectionVertical;
    UICollectionView *collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0,585*6+490, kMainBoundsW, kMainBoundsH) collectionViewLayout:layout];
    collectionView.delegate= self;
    collectionView.dataSource =self;
    collectionView.tag=WaterFallCollectionView;
    collectionView.backgroundColor =[UIColor lightGrayColor];
    collectionView.scrollEnabled=NO;
    collectionView.backgroundColor =[UIColor greenColor];
    _collectionView.scrollsToTop=YES;
    [_bgScrollView addSubview:collectionView];
    
    _collectionView =collectionView;
    [collectionView registerClass: [UICollectionViewCell class] forCellWithReuseIdentifier:@"cellIdentify"];
    [collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"headerIdentify"];
    
    _bgScrollView.contentSize=CGSizeMake(0, 490+_myTableView.contentSize.height+_collectionView.contentSize.height);
    
}


#pragma mark -获取限时购视图数据
- (void)getPromotionViewDataWithBlock:(void(^)(void))block{
    [self.promotionDataArr removeAllObjects];
    __weak NSMutableArray *arr = self.promotionDataArr;
    [WPFHttpManager getPromotionViewContent:^(NSArray *array) {
        if (array.count !=0) {
            [arr addObjectsFromArray:array];
            [self reloadPromotionView];
        }
    }];
}

#pragma mark -刷新限时购视图
- (void)reloadPromotionView {
    UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 250, kMainBoundsW, 230)];
    for (int i=0; i<2; i++) {
        PromotionModel *model =self.promotionDataArr[i];
        UIButton *button =[UIButton buttonWithType:UIButtonTypeCustom];
        button.frame=CGRectMake(10+(i%2)*(kMainBoundsW-10)/2, 0, (kMainBoundsW-30)/2, bgView.frame.size.height);
        [button sd_setBackgroundImageWithURL:[NSURL URLWithString:model.img_index] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(GoodsDetail:)];
        [bgView addSubview:button];
    }
    [_bgScrollView addSubview:bgView];
    _bgView=bgView;
    
}

- (void)GoodsDetail:(UIButton*)sender {
    
    
}


#pragma mark -获取各国馆的视图数据
- (void)getBottomViewDataWithBlock:(void(^)(void))block {
    [self.regionDataArr removeAllObjects];
    __weak NSMutableArray *arr =self.regionDataArr;
    [WPFHttpManager getWaterFallViewContent:^(NSArray *array) {
        [arr addObjectsFromArray:array];
        dispatch_async(dispatch_get_main_queue(), ^{
           [self createVenuesView];
        });
    }];
}
#pragma mark -刷新各国馆视图
- (void)createVenuesView {
 _bgScrollView.contentSize=CGSizeMake(0, 7000);
    UITableView *myTableView =[[UITableView alloc]initWithFrame:CGRectMake(0,CGRectGetMaxY(_bgView.frame)+10, kMainBoundsW, kMainBoundsH) style:UITableViewStyleGrouped];
    myTableView.autoresizesSubviews = NO;
    myTableView.delegate=self;
    myTableView.dataSource =self;
    myTableView.tag =BottomTableView;
    myTableView.backgroundColor =[UIColor blueColor];
    [_bgScrollView addSubview:myTableView];
    _myTableView = myTableView;
    myTableView.showsHorizontalScrollIndicator=NO;
    myTableView.scrollEnabled=NO;
    [_myTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    NSLog(@"-==%f",_myTableView.contentSize.height);

}

#pragma mark -获取顶部滚动视图的数据
- (void)getTopScrollViewDataWithBlock:(void(^)(void))block {
 
    [self.topDataArr removeAllObjects];
    __block NSMutableArray * arr = self.topDataArr;
    [WPFHttpManager getMainVCTopScrollViewContent:^(NSArray *array) {
        if (array.count !=0) {
            [arr addObjectsFromArray:array];
            [self reloadScrollView];
        }
    }];
}


#pragma mark -刷新顶部滚动视图
- (void)reloadScrollView {
    UIScrollView *topScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, kMainBoundsW, 240)];
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
    UIPageControl *pageControl = [UIPageControl createPageControlWithFrame:CGRectMake(0, 230, kMainBoundsW, 10) numberOfPages:self.topDataArr.count pageIndicatorTintColor:[UIColor redColor] currentPageIndicatorTintColor:[UIColor blueColor]];
    [_bgScrollView addSubview:pageControl];
    _pageControl =pageControl;
    
}


- (void)startTimer {
 NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(autoChangePage) userInfo:nil repeats:YES];
    _timer = timer;
}
- (void)autoChangePage {
    speed++;
    speed = speed%self.topDataArr.count;
 _topScrollView.contentOffset= CGPointMake(kMainBoundsW*(speed+1), 0);
    _pageControl.currentPage = _topScrollView.contentOffset.x/kMainBoundsW-1;
}

#pragma mark -实现滚动视图的代理方法
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
    if (scrollView.tag ==BackgroundScrollView) {
        UITableView *tableView = [scrollView viewWithTag:BottomTableView];
        if (scrollView.contentOffset.y<=490) {
            tableView.contentOffset=CGPointMake(0, 0);
            tableView.frame=CGRectMake(0, 490, kMainBoundsW, kMainBoundsH);
            return;
        }
            if(scrollView.contentOffset.y>490 && scrollView.contentOffset.y<=585*6+490-kMainBoundsH){
            tableView.center =CGPointMake(tableView.center.x, scrollView.contentOffset.y+self.view.center.y);
            CGPoint offset = CGPointMake(scrollView.contentOffset.x, scrollView.contentOffset.y-490);
            _collectionView.frame=CGRectMake(0, 585*6+490, kMainBoundsW, kMainBoundsH);
//                [_bgScrollView bringSubviewToFront:_collectionView];
            tableView.contentOffset = offset;
//               KSLog(@"AAA%@---%@",NSStringFromCGRect(_myTableView.frame),NSStringFromCGRect(_collectionView.frame));
        }
            if (scrollView.contentOffset.y>3257)
        {
            _myTableView.center = CGPointMake(tableView.center.x, _myTableView.center.y);
            _collectionView.center =CGPointMake(_collectionView.center.x,3257+kMainBoundsH+kMainBoundsH/2);
//KSLog(@"BBB%@---%@",NSStringFromCGRect(_myTableView.frame),NSStringFromCGRect(_collectionView.frame));
        }
        
//        KSLog(@"------%f",scrollView.contentOffset.y);
        }
    if (scrollView.contentOffset.y>=3992) {
        _collectionView.center = CGPointMake(self.view.center.x, scrollView.contentOffset.y+self.view.center.y);
        CGPoint offset =CGPointMake(scrollView.contentOffset.x, scrollView.contentOffset.y-3992);
        _collectionView.contentOffset=offset;
    }
    
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [_timer invalidate];
    _timer = nil;
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    [self startTimer];
}

#pragma mark -实现tableView的代理方法
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.regionDataArr.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return  3;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.row) {
        case 0:
            return 100;
            break;
        case 1:
            return 220;
            break;
        case 2:
            return 180;
            break;
        default:
            return 0;
            break;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 80;
}


- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    cell.selectionStyle =UITableViewCellSelectionStyleNone;
    
    UIView * view =[cell.contentView.subviews firstObject];
    [view removeFromSuperview];
    
    UIView *backView = [[UIView alloc]initWithFrame:cell.contentView.frame];
    [cell.contentView addSubview:backView];
    RegionModel *model =self.regionDataArr[indexPath.section];
    switch (indexPath.row) {
        case 0:
        {
            UIScrollView *brandScorllView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, kMainBoundsW, backView.frame.size.height)];
            for (int i=0; i<model.brandsArr.count; i++) {
                UIButton *brandBtn = [UIButton buttonWithType:UIButtonTypeCustom];
                brandBtn.frame=CGRectMake((kMainBoundsW/4)* i, 0, kMainBoundsW/4, backView.frame.size.height);
                [brandBtn sd_setBackgroundImageWithURL:[NSURL URLWithString:model.brandsArr[i]] forState:UIControlStateNormal];
                [brandScorllView addSubview:brandBtn];
            }
            [backView addSubview:brandScorllView];
            brandScorllView.contentSize=CGSizeMake((kMainBoundsW/4)*model.brandsArr.count, 0);
            brandScorllView.showsHorizontalScrollIndicator=NO;
            brandScorllView.delegate=self;
            break;
        }
        case 1:
        {
            UIScrollView *pictureScorllView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, kMainBoundsW, backView.frame.size.height)];
            for (int i=0; i<model.pictureArr.count; i++) {
                UIButton *picBtn = [UIButton buttonWithType:UIButtonTypeCustom];
                picBtn.frame=CGRectMake(kMainBoundsW* i, 0, kMainBoundsW, backView.frame.size.height);
                [picBtn sd_setBackgroundImageWithURL:[NSURL URLWithString:model.pictureArr[i]] forState:UIControlStateNormal];
                [pictureScorllView addSubview:picBtn];
            }
            [backView addSubview:pictureScorllView];
            pictureScorllView.contentSize=CGSizeMake(kMainBoundsW*model.pictureArr.count, 0);
            pictureScorllView.pagingEnabled=YES;
            pictureScorllView.showsHorizontalScrollIndicator=NO;
            pictureScorllView.delegate=self;
            break;
        }
        case 2:
        {
            UIScrollView *skuScorllView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, kMainBoundsW, backView.frame.size.height)];
            for (int i=0; i<model.skusArr.count; i++) {
                UIButton *skuBtn = [UIButton buttonWithType:UIButtonTypeCustom];
               skuBtn.frame=CGRectMake((kMainBoundsW/4)* i, 5, kMainBoundsW/4, backView.frame.size.height*3/5);
                [skuBtn sd_setBackgroundImageWithURL:[NSURL URLWithString:[model.skusArr[i] picUrl]] forState:UIControlStateNormal];
                [skuScorllView addSubview:skuBtn];
                
                UILabel *titleLabel =[[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMinX(skuBtn.frame), CGRectGetMaxY(skuBtn.frame), skuBtn.frame.size.width, 20)];
                titleLabel.text = [model.skusArr[i] title];
                titleLabel.textAlignment =NSTextAlignmentCenter;
                titleLabel.font =[UIFont systemFontOfSize:12];
                [skuScorllView addSubview:titleLabel];
                UILabel *priceLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMinX(skuBtn.frame), CGRectGetMaxY(titleLabel.frame)-3, skuBtn.frame.size.width, 30)];
                priceLabel.text = [NSString stringWithFormat:@"¥%@",[model.skusArr[i] price]] ;
                priceLabel.textColor =BXColor(255, 75, 65);
                priceLabel.textAlignment=NSTextAlignmentCenter;
                priceLabel.font =[UIFont systemFontOfSize:15];
                [skuScorllView addSubview:priceLabel];
                UILabel *originPriceLabel = [UILabel labelWithTitle:[NSString stringWithFormat:@"¥%@",[model.skusArr[i] origin_price]] color:BXColor(255, 75, 65) fontSize:12 alignment:NSTextAlignmentCenter];
                originPriceLabel.frame=CGRectMake(CGRectGetMinX(skuBtn.frame), CGRectGetMaxY(priceLabel.frame)-8, skuBtn.frame.size.width, 20);
                [skuScorllView addSubview:originPriceLabel];
                
            }
            [backView addSubview:skuScorllView];
            skuScorllView.contentSize=CGSizeMake((kMainBoundsW/4)*model.skusArr.count, 0);
            skuScorllView.showsHorizontalScrollIndicator=NO;
            skuScorllView.delegate=self;
            break;
        }
        default:
            break;
    }
    
    
    return cell;

}

- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
       UIButton *topBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    topBtn.frame= CGRectMake(0, 0, kMainBoundsW, 80);
    RegionModel *model =self.regionDataArr[section];
        [topBtn sd_setBackgroundImageWithURL:[NSURL URLWithString:[model.nameArr firstObject]] forState:UIControlStateNormal];
    return topBtn;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 5;
}


#pragma mark -实现collectionView的代理方法
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.latestStyleDataArr.count;
}

- (UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell =[collectionView dequeueReusableCellWithReuseIdentifier:@"cellIdentify" forIndexPath:indexPath];
    for (UIView *view in cell.contentView.subviews) {
        [view removeFromSuperview];
    }
    UIView *diskView =[[UIView alloc]initWithFrame:cell.contentView.frame];
    [cell.contentView addSubview:diskView];
    WPFGoodsModel *obj =self.latestStyleDataArr[indexPath.row];
    UIButton* button =[UIButton buttonWithType:UIButtonTypeCustom];
    button.frame=CGRectMake(0, 0, cell.frame.size.width, cell.frame.size.height*18/28.0);
    NSString *picStr =[[obj.model.picUrl componentsSeparatedByString:@"?"]firstObject];
    [button sd_setBackgroundImageWithURL:[NSURL URLWithString:picStr] forState:UIControlStateNormal];
    [diskView addSubview:button];

    UIImageView *countryImage =[[UIImageView alloc]initWithFrame:CGRectMake(5, CGRectGetMaxY(button.frame)+10, cell.frame.size.height*1/28, cell.frame.size.height*1/28)];
    [countryImage sd_setImageWithURL:[NSURL URLWithString:obj.model.nationalFlag] placeholderImage:[UIImage imageNamed:@"icon_information_ok"]];
    [diskView addSubview:countryImage];
    
    UILabel *countryLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(countryImage.frame), CGRectGetMaxY(button.frame), cell.frame.size.width-CGRectGetMaxX(countryImage.frame), cell.frame.size.height*3/28)];
    countryLabel.text=obj.model.country;
    countryLabel.font =[UIFont systemFontOfSize:12];
    [diskView addSubview:countryLabel];
    
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMinX(countryImage.frame), CGRectGetMaxY(countryLabel.frame), cell.frame.size.width-10, cell.frame.size.height*3/28)];
    titleLabel.text =obj.model.descrip;
    [diskView addSubview:titleLabel];
    
    UILabel *priceLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMinX(countryImage.frame), CGRectGetMaxY(titleLabel.frame), cell.frame.size.width, cell.frame.size.height*4/28)];
    NSString *str =[NSString stringWithFormat:@"¥%@ ¥%@",obj.model.price,obj.model.origin_price];
    priceLabel.attributedText =[self setTextStyleWith:str with:obj.model.price.length+1 with:obj.model.origin_price.length+2];
    [diskView addSubview:priceLabel];
    
    
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake((kMainBoundsW-10)/2, 280);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    return CGSizeMake(kMainBoundsW, 100);
}

- (UICollectionReusableView*)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {

    UICollectionReusableView *reuseView =[collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"headerIdentify" forIndexPath:indexPath];
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSArray *titleArr =@[@"今日上新",@"上装",@"裙装",@"裤装"];
        for (UIView *view in reuseView.subviews) {
            [view removeFromSuperview];
        }
        UIView* view =[[UIView alloc]initWithFrame:reuseView.frame];
        for (int i=0; i<4; i++) {
            UIButton* button =[UIButton buttonWithType:UIButtonTypeSystem];
            button.frame=CGRectMake(kMainBoundsW/4*i, 20, kMainBoundsW/4, 60);
            [button setTitle:titleArr[i] forState:UIControlStateNormal];
            [button setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];//设置button上label的字体颜色
            button.tag=i+1;
            [button addTarget:self action:@selector(changeDress:) forControlEvents:UIControlEventTouchUpInside];
            view.backgroundColor=[UIColor whiteColor];
            [view insertSubview:button atIndex:i];
        }
        
        UIImageView *imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"矩形-15-副本-4"]];
        imageView.frame=CGRectMake(0, 80, kMainBoundsW, 1);
        [view addSubview:imageView];
        UILabel *label =[[UILabel alloc]initWithFrame:CGRectMake(0, 78, kMainBoundsW/4, 2)];
        label.backgroundColor =[UIColor redColor];
        label.tag=10;
        [view addSubview:label];
        _headerView =view;
        [reuseView addSubview:view];

    });
    
    
    return reuseView;
}

- (void)changeDress: (UIButton *)sender {
   
    UILabel *label =[_headerView viewWithTag:10];
    label.frame=CGRectMake(kMainBoundsW/4*(sender.tag-1), 78, kMainBoundsW/4, 2);
       switch (sender.tag) {
        case 1:
           {
               index=1;
               [self getNewStyleData:1 WithBlock:nil];
              
           }
            break;
        case 2:
           {
               index=2;
            [self getNewStyleData:2 WithBlock:nil];
            break;
           }
        case 3:
           {
               index=3;
            [self getNewStyleData:3 WithBlock:nil];
            break;
           }
        case 4:
           {
               index=4;
            [self getNewStyleData:4 WithBlock:nil];
            break;
           }
        default:
            break;
    }
}




#pragma mark -下拉刷新
- (void)refreshInfo {
  
    _bgScrollView.mj_header =[MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self getTopScrollViewDataWithBlock:nil];
        [self getPromotionViewDataWithBlock:nil];
        [self getNewStyleData:1 WithBlock:nil];
         [_bgScrollView.mj_header endRefreshing];
    }];

       [_bgScrollView.mj_header beginRefreshing];

    _collectionView.mj_footer =[MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [self getNewStyleData:index WithBlock:^{
            [WPFHttpManager getNewStyleViewContent:index withBlock:^(NSArray *array) {
                [_latestStyleDataArr addObjectsFromArray:array];
                [_collectionView reloadData];
            }];
        }];
        _bgScrollView.contentSize =CGSizeMake(kMainBoundsW, 3257+_collectionView.contentSize.height);
        [_collectionView.mj_footer endRefreshing];
    }];
    
}

#pragma mark -富文本
- (NSMutableAttributedString *)setTextStyleWith:(NSString*)str with:(NSInteger)range1 with:(NSInteger)range2{
    NSMutableAttributedString * attributeStr=[[NSMutableAttributedString alloc]initWithString:str];
    [attributeStr addAttribute:NSForegroundColorAttributeName value: BXColor(255, 75, 65) range:NSMakeRange(0, range1)];
    [attributeStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:17] range:NSMakeRange(0, range1)];
    [attributeStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:13] range:NSMakeRange(range1, range2)];
     [attributeStr addAttribute:NSForegroundColorAttributeName value:BXColor(255, 75, 65) range:NSMakeRange(range1, range2)];
    return attributeStr;
}

#pragma mark -自定义导航条
- (void)createNivagationBar{
    UIView * bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kMainBoundsW, 64)];
    bgView.backgroundColor =[UIColor whiteColor];
    bgView.tag=20;
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
