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



#define CELLWITCH kMainBoundsW / 2 - 4
#define TOPBUTTONTAG 100
#define CELLIMAGE (kMainBoundsW / 2 - 4) / [model.width floatValue] * [model.height floatValue]

@interface MatchViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,FlowWaterDelegate,UITableViewDelegate,UITableViewDataSource,UITableViewDelegate>{
    
    UIView *_SlideView;
    
    CGFloat _cellFloat;
    
    NSMutableArray *_dataArray;
    
    UICollectionView *_collectView;
    
    UICollectionView *collectView;
   
}

@end

@implementation MatchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBarHidden = YES;
    
    
    [self createNAV];
    [self createCollectionView];
    [self dataArray];
    
    _dataArray = @[].mutableCopy;
    
}
#pragma mark -数据源
-(void)dataArray{

    [zMatchTool getWtchMatch:@"http://api-v2.mall.hichao.com/star/list?category=%E5%85%A8%E9%83%A8&lts=&pin=&flag=&gc=appstore&gf=iphone&gn=mxyc_ip&gv=6.6.3&gi=CBD795AD-1BFC-40FE-A351-407FEAC7219D&gs=640x1136&gos=8.4.1&access_token=" wtchBlock:^(NSMutableArray *Array) {
        _dataArray = Array;
        
        if (_dataArray != nil) {
            [_collectView reloadData];
        }
    }];
    
    
}
#pragma mark -定义NAV
-(void)createNAV{
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
-(void)topButton:(UIButton *)sender{
    if (sender.tag == TOPBUTTONTAG) {
        _SlideView.frame = CGRectMake(kMainBoundsW/2 - 100, 59, 100, 5);
        NSLog(@"1");
        collectView.frame = CGRectMake(0, 64, kMainBoundsW, kMainBoundsH);

        
    }else{
        _SlideView.frame = CGRectMake(kMainBoundsW/2 , 59, 100, 5);
    
        collectView.frame = CGRectMake(0, 0, 0, 0);
        [self createTable];
    }
    
}

-(void)messageBtn:(UIButton *)sender{
    
}
#pragma mark -创建瀑布流
-(void)createCollectionView{
    UICollectionViewFlowWaterLayout *layout = [UICollectionViewFlowWaterLayout new];
    layout.delegate = self;
    
    layout.itemWith = CELLWITCH;
    layout.columnCount = 2;
    layout.sectionInset = UIEdgeInsetsMake(0, 0, 5, 0);
    
    
    collectView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 64, kMainBoundsW, kMainBoundsH)  collectionViewLayout:layout];
    
    collectView.delegate = self;
    
    collectView.dataSource = self;
    
    collectView.backgroundColor = [UIColor whiteColor];
    
    [collectView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cellID"];
    
    [self.view addSubview:collectView];
    _collectView = collectView;
    
    
}
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
    NSString *picURL = [model.picUrl componentsSeparatedByString:@"?"][0];
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
    UITableView *table = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, kMainBoundsW, kMainBoundsH) style:UITableViewStylePlain];
    table.delegate = self;
    table.dataSource = self;
    [self.view addSubview:table];
    [table registerNib:[UINib nibWithNibName:@"MatchCell" bundle:nil] forCellReuseIdentifier:@"CELL"];
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 200;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 20;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MatchCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CELL"];
    
    return cell;
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
