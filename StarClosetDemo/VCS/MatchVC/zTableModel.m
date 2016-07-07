//
//  zTableModel.m
//  StarClosetDemo
//
//  Created by Mac on 16/7/5.
//  Copyright © 2016年 Mac. All rights reserved.
//

#import "zTableModel.h"

@implementation zTableModel

+(NSMutableArray *)dataAnalysis:(id)jison{
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jison options:NSUTF8StringEncoding error:nil];
    NSMutableArray *dataArray = @[].mutableCopy;
    NSDictionary *dataDic = dic[@"data"];
    NSArray *temsArray = dataDic[@"items"];
    
    
    
    for (NSDictionary *dic1 in temsArray) {
        
      zTableModel *tableModel = [self wichComDic:dic1];
        [dataArray addObject:tableModel];
        
    }
    
    return dataArray;
}

-(instancetype)initWichComDic:(NSDictionary *)comDic{
    
    
    if (self) {
        self = [super init];
        self.width = comDic[@"width"];
        self.height = comDic[@"height"];
        
        
        NSDictionary *componentDic = comDic[@"component"];
     
        [self setValuesForKeysWithDictionary:componentDic];
        NSDictionary *actionDic = componentDic[@"action"];
        self.v = actionDic[@"v"];
        self.collectionCount = actionDic[@"collectionCount"];
        self.commentCount = actionDic[@"commentCount"];
        
        
    }
    
    return self;
}

+(instancetype)wichComDic:(NSDictionary *)comDic{
   
    return [[self alloc]initWichComDic:comDic];
}
-(void)setValue:(id)value forKey:(NSString *)key{
    if ([key isEqualToString:@"description"]) {
        self.biaoti = value;
    }else{
        [super setValue:value forKey:key];
    }
    
}
-(void)setValue:(id)value forUndefinedKey:(NSString *)key{
    
}







@end
