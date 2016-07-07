//
//  zTableModel.h
//  StarClosetDemo
//
//  Created by Mac on 16/7/5.
//  Copyright © 2016年 Mac. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface zTableModel : NSObject

@property (copy, nonatomic)NSString *title;
@property (assign, nonatomic)NSNumber *year;
@property (assign, nonatomic)NSNumber *month;
@property (assign, nonatomic)NSNumber *day;
@property (copy, nonatomic)NSString *category;
@property (copy, nonatomic)NSString *picUrl;
@property (assign, nonatomic)NSNumber *v;
@property (assign, nonatomic)NSNumber *collectionCount;
@property (assign, nonatomic)NSNumber *commentCount;
@property (assign, nonatomic)NSNumber *width;
@property (assign, nonatomic)NSNumber *height;
@property (copy, nonatomic)NSString *biaoti;


-(instancetype)initWichComDic:(NSDictionary *)comDic;

+(instancetype)wichComDic:(NSDictionary *)comDic;

+(NSMutableArray *)dataAnalysis:(id)jison;



@end
