//
//  UICollectionViewFlowWaterLayout.h
//  PullWater3.0
//
//  Created by Mac on 15/10/15.
//  Copyright (c) 2015年 罗炜翔. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol FlowWaterDelegate <NSObject>

- (CGFloat)getHeight:(NSIndexPath *)indexPath;


@end


@interface UICollectionViewFlowWaterLayout : UICollectionViewLayout


//声明列数
@property (nonatomic, assign) NSInteger columnCount;

//声明每一个item的宽度
@property (nonatomic, assign) CGFloat itemWith;

//设置section的大小
@property (nonatomic, assign) UIEdgeInsets sectionInset;


@property (nonatomic, assign) id<FlowWaterDelegate>delegate;

@end
