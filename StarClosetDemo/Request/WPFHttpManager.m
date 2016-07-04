//
//  WPFHttpManager.m
//  StarClosetDemo
//
//  Created by Mac on 16/7/4.
//  Copyright © 2016年 Mac. All rights reserved.
//

#import "WPFHttpManager.h"
#import "NetRequestClass.h"
#import "WTopScrollModel.h"
@implementation WPFHttpManager

+ (void)getMainVCTopScrollViewContent:(void(^)(NSArray *array))complete {
    [NetRequestClass netRequestGETWithRequestURL:@"http://api-v2.mall.hichao.com/mall/banner" WithParameter:@{@"gc":@"appstore",@"gf":@"iphone",@"gn":@"mxyc_ip",@"gv":@"6.6.3",@"gi":@"CBD795AD-1BFC-40FE-A351-407FEAC7219D",@"gs":@"640x1136",@"gos":@"8.4.1",@"access_token":@""} WithReturnValeuBlock:^(NSDictionary *responseObject, NSError *error) {
       NSLog(@"%@",responseObject);
        NSDictionary *dic =responseObject[@"data"];
        NSArray *itemsArr = dic[@"items"];
        NSMutableArray *resultArr = [NSMutableArray array];
        [itemsArr enumerateObjectsUsingBlock:^(NSDictionary *tempDic, NSUInteger idx, BOOL * _Nonnull stop) {
            tempDic = itemsArr[idx];
            WTopScrollModel *model = [[WTopScrollModel alloc]initWithTopScrollModel:tempDic];
            [resultArr addObject:model];
//            NSLog(@"%@",model.Obj.picUrl);
        }];
        if (complete) {
            complete(resultArr);
        }
    }];
}






@end
