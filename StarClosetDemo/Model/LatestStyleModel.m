//
//  LatestStyleModel.m
//  StarClosetDemo
//
//  Created by Mac on 16/7/5.
//  Copyright © 2016年 Mac. All rights reserved.
//

#import "LatestStyleModel.h"

@implementation LatestStyleModel

- (instancetype)initLatestStyleModelWith:(NSDictionary *)dic {
    self = [super init];
    if (self) {
        self.descrip =dic[@"description"];
        self.nationalFlag =dic[@"nationalFlag"];
        self.price =dic[@"price"];
        self.origin_price =dic[@"origin_price"];
        self.country = dic[@"country"];
        self.picUrl =dic[@"picUrl"];
    }
    return self;
}

@end


@implementation WPFGoodsModel

- (instancetype)initWPFGoodsModelWithDic:(NSDictionary *)dic {
    self =[super init];
    if (self) {
        self.height = dic[@"height"];
        self.width = dic[@"width"];
        self.model =[[LatestStyleModel alloc]initLatestStyleModelWith:dic[@"component"]];
    }
    return self;
}

@end











