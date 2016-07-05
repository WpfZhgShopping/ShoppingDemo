//
//  UICollectionViewFlowWaterLayout.m
//  PullWater3.0
//
//  Created by Mac on 15/10/15.
//  Copyright (c) 2015年 罗炜翔. All rights reserved.
//

#import "UICollectionViewFlowWaterLayout.h"

@interface UICollectionViewFlowWaterLayout ()

//记录当前的item个数
@property (nonatomic, assign) NSInteger itemsCount;

//记录间隙
@property (nonatomic, assign) CGFloat interiteSpacing;

//记录每一列的高度
@property (nonatomic, strong) NSMutableArray *columnHeights;

//记录每一个item的attribute
@property (nonatomic, strong) NSMutableArray *attributes;

@end


@implementation UICollectionViewFlowWaterLayout

- (instancetype)init {
    self = [super init];
    
    if (self) {
        
        [self initData];
    }
    
    return self;
}



- (void)initData {
    
    self.columnCount = 2;
    self.itemWith = 140;
    self.sectionInset = UIEdgeInsetsMake(5, 5, 5, 5);
}


#pragma mark - Override重写
//首先会调用该方法初始化
- (void)prepareLayout {
    [super prepareLayout];
    
    //首先要获取collection view当前section上的item的个数
    NSInteger items = [[self collectionView] numberOfItemsInSection:0];
    
    _itemsCount = items;
    //断言不足1列，就报错
    NSAssert(_columnCount > 1, @"当前瀑布流的列数必需大于1");
    
    
    //开始布局 要设置每一个item的位置坐标和属性绘画
    //会在当前的collection view 的内容上（宽度）
    CGFloat width = self.collectionView.frame.size.width - _sectionInset.left - _sectionInset.right;
    
    //计算一个间隙的宽度
    CGFloat iSpacing = floor(width - _columnCount * _itemWith)/(_columnCount - 1);
    
    _interiteSpacing = iSpacing;
    
    NSLog(@"%f",iSpacing);
    
    self.columnHeights = [[NSMutableArray alloc] initWithCapacity:_columnCount];
    
    self.attributes = [[NSMutableArray alloc] initWithCapacity:_itemsCount];
    
    
    //初始化高度
    for (NSInteger index = 0; index < _columnCount; index++) {
            [_columnHeights addObject:@(_sectionInset.top)];
    }
    
    
    for (NSInteger idx = 0; idx < _itemsCount; idx++) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:idx inSection:0];
        
        //首先要拿到item的高度
        CGFloat itemHeight = [self.delegate getHeight:indexPath];
        
        //找最低
        NSInteger minCol = [self getMinHeightColIndex];
        
        //设置每一个item的xy
        CGFloat xOffset = _sectionInset.left + (_itemWith + _interiteSpacing)*minCol;
        
        CGFloat yOffset = [(_columnHeights[minCol]) floatValue];
        
        //设置每一个item的绘画属性
        UICollectionViewLayoutAttributes *a = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
        
        a.frame = CGRectMake(xOffset, yOffset, _itemWith, itemHeight);
        
        [_attributes addObject:a];
        
        _columnHeights[minCol] = @(yOffset + itemHeight + _sectionInset.bottom);
        
        
    }
    
}
//获取collection的内容尺寸
- (CGSize)collectionViewContentSize {
    if (0 == _itemsCount) {
        
        return CGSizeZero;
    }
    
    CGSize contentSize = self.collectionView.frame.size;
    NSInteger maxCol = [self getMaxHeightColIndex];
    contentSize.height = [self.columnHeights[maxCol] floatValue] + self.sectionInset.bottom - self.interiteSpacing;
    
    return contentSize;
}

//返回对应的indexPath位置的cell的布局属性
- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath {
    return (self.attributes)[indexPath.item];
}

//返回rect
- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect {
    
    return [self.attributes filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *bindings) {
       
        return CGRectIntersectsRect(rect, ((UICollectionViewLayoutAttributes*)evaluatedObject).frame);
        
    }]];
}


//当边界发生改变时，是否需要刷新布局,如果是YES，则在边界变化时(一般情况是scroll到其他位置) 将重新计算
- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds {
    
    return NO;
}

- (NSInteger)getMinHeightColIndex {
    
    __block NSInteger index = 0;
    
    __block CGFloat tempIndex = MAXFLOAT;
    
    [self.columnHeights enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
       
        CGFloat temp = [obj floatValue];
        
        if (temp < tempIndex) {
            
            tempIndex = temp;
            
            index = idx;
        }
        
    }];
    
    return index;
    
}


- (NSInteger)getMaxHeightColIndex {
    
    __block NSInteger index = 0;
    
    __block CGFloat tempIndex = 0;
    
    [self.columnHeights enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        
        CGFloat temp = [obj floatValue];
        
        if (temp > tempIndex) {
            
            tempIndex = temp;
            
            index = idx;
        }
        
    }];
    
    return index;
    
}


@end
