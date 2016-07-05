//
//  zMatchNodel.m
//  StarClosetDemo
//
//  Created by Mac on 16/7/4.
//  Copyright © 2016年 Mac. All rights reserved.
//

#import "zMatchNodel.h"




@implementation zMatchNodel


+(NSMutableArray *)dataAnalysis:(id)jison{
    NSDictionary *Dic = [NSJSONSerialization JSONObjectWithData:jison options:NSUTF8StringEncoding error:nil];
    NSDictionary *dataDic = Dic[@"data"];
    NSArray *Array = dataDic[@"items"];
    NSMutableArray *dataArray = @[].mutableCopy;
    for (NSDictionary *comDic in Array) {
        
       zMatchNodel *model = [self wichComDic:comDic];
        
        [dataArray addObject:model];
    }
    zMatchNodel *damodel = dataArray[1];
//    NSLog(@"++++picUrl+++%@,++++height+++%@,+++width+++%@,++weekDayBgUrl+++%@,+++showTime++%@,++xingQi+++%@,+++collectionCount++%@",damodel.picUrl,damodel.height,damodel.width,damodel.weekDayBgUrl,damodel.showTime,damodel.xingQi,damodel.collectionCount);
    return dataArray;
    
}
-(void)setValue:(id)value forKey:(NSString *)key{
    if ([key isEqualToString:@"description"]) {
        self.biaoti = value;
    }else{
        [super setValue:value forKey:key];
    }
    
}
-(instancetype)initWichComDic:(NSDictionary *)comDic{
    if (self) {
        self = [super init];
        NSDictionary *dic = comDic[@"component"];
        
        [self setValuesForKeysWithDictionary:dic];
        self.height =comDic[@"height"];
        self.width = comDic[@"width"];
        
    }

    return self;
}
+(instancetype)wichComDic:(NSDictionary *)comDic{
    
    return [[self alloc]initWichComDic:comDic];
    
    
}
-(void)setValue:(id)value forUndefinedKey:(NSString *)key{
    
}



@end
