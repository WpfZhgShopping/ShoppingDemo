//
//  zMatchNodel.h
//  StarClosetDemo
//
//  Created by Mac on 16/7/4.
//  Copyright © 2016年 Mac. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface zMatchNodel : NSObject

@property (copy, nonatomic)NSString *picUrl;
@property (assign, nonatomic)NSNumber *height;
@property (assign, nonatomic)NSNumber *width;
@property (copy, nonatomic)NSString *weekDayBgUrl;
@property (assign, nonatomic)NSNumber *showTime;
@property (copy, nonatomic)NSString *xingQi;
@property (assign, nonatomic)NSNumber *collectionCount;
@property (assign, nonatomic)NSNumber *itemsCount;
@property (copy, nonatomic)NSString *biaoti;




-(instancetype)initWichComDic:(NSDictionary *)comDic;

+(instancetype)wichComDic:(NSDictionary *)comDic;

+(NSMutableArray *)dataAnalysis:(id)jison;


@end
