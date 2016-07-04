//
//  WTopScrollModel.m
//  StarClosetDemo
//
//  Created by Mac on 16/7/4.
//  Copyright © 2016年 Mac. All rights reserved.
//

#import "WTopScrollModel.h"

@implementation WTopScrollModel

- (instancetype)initWithTopScrollModel:(NSDictionary*)dic {
    self = [super init];
    if (self) {
        self.width = dic[@"width"];
        self.height =dic[@"height"];
        self.Obj = [[WcomponentModel alloc]initWithComponentModel:dic[@"component"]];
    }
    return self;
}

@end


@implementation WcomponentModel

- (instancetype)initWithComponentModel:(NSDictionary*)dic {
    self = [super init];
    if (self) {
        self.picUrl = dic[@"picUrl"];
    }
    return self;
}

@end



