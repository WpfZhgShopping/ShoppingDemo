//
//  PromotionModel.m
//  StarClosetDemo
//
//  Created by Mac on 16/7/4.
//  Copyright © 2016年 Mac. All rights reserved.
//

#import "PromotionModel.h"

@implementation PromotionModel

- (instancetype)initWithPromotionModel:(NSDictionary *)dic {
    self = [super init];
    if (self) {
        self.activity_time =dic[@"activity_time"];
        self.end_time = dic[@"end_time"];
        self.img_index = dic[@"img_index"];
        self.preheat_time =dic[@"preheat_time"];
        self.start_time = dic[@"start_time"];
    }
    return self;
}


@end






