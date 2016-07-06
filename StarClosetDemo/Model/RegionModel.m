//
//  RegionModel.m
//  StarClosetDemo
//
//  Created by Mac on 16/7/4.
//  Copyright © 2016年 Mac. All rights reserved.
//

#import "RegionModel.h"

@implementation RegionModel

- (instancetype)initWithRegionModel:(NSDictionary*)dic {
    self = [super init];
    if (self) {
        self.nameArr =[NSMutableArray array];
        self.brandsArr =[NSMutableArray array];
        self.skusArr = [NSMutableArray array];
        self.pictureArr =[NSMutableArray array];
      NSArray *brandArr = dic[@"region_brands"];
        for (int i=0; i<brandArr.count; i++) {
            NSDictionary *dic2 =brandArr[i];
            NSDictionary *component =dic2[@"component"];
            NSString *picUrl = component[@"picUrl"];
            [self.brandsArr addObject:picUrl];
        }
        
        NSArray *nameArray =dic[@"region_name"];
        for (int j=0; j<nameArray.count; j++) {
            NSDictionary *dic1 =nameArray[j];
            NSDictionary *component =dic1[@"component"];
            NSString *picUrl =component[@"picUrl"];
            [self.nameArr addObject:picUrl];
        }
        NSArray *picArr =dic[@"region_pictures"];
        for (int n=0; n<picArr.count; n++) {
            NSDictionary *dic3 = picArr[n];
            NSDictionary *component =dic3[@"component"];
            NSString *picUrl = component[@"picUrl"];
            [self.pictureArr addObject:picUrl];
        }
        NSArray *skuArr =dic[@"region_skus"];
        for (int m=0; m<skuArr.count; m++) {
            NSDictionary *dic4 =skuArr[m];
            NSDictionary *component =dic4[@"component"];
            self.model =[[SkusModel alloc]initSkusModelWith:component];
            [self.skusArr addObject:self.model];
        }
    }
    return self;
}




@end



@implementation SkusModel

- (instancetype)initSkusModelWith:(NSDictionary*)dic {
    self =[super init];
    if (self) {
        self.price =dic[@"price"];
        self.origin_price=dic[@"origin_price"];
        self.picUrl =dic[@"picUrl"];
        self.title =dic[@"title"];
    }
    return  self;
}

@end



