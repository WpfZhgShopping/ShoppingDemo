//
//  WTitleModel.m
//  StarClosetDemo
//
//  Created by Mac on 16/7/7.
//  Copyright © 2016年 Mac. All rights reserved.
//

#import "WTitleModel.h"

@implementation WTitleModel

- (instancetype)initWTitleModelWith:(NSDictionary *)dic {
    self =[super init];
    if (self) {
        [self setValuesForKeysWithDictionary:dic];
    }
    return self;
}

@end
