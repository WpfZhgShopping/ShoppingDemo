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
#import "PromotionModel.h"
#import "RegionModel.h"
@implementation WPFHttpManager

+ (void)getMainVCTopScrollViewContent:(void(^)(NSArray *array))complete {
    [NetRequestClass netRequestGETWithRequestURL:@"http://api-v2.mall.hichao.com/mall/banner" WithParameter:@{GC:GC_VALUE,GF:GF_VALUE,GN:GN_VALUE,GV:GV_VALUE,GI:GI_VALUE,GS:GS_VALUE,GOS:GOS_VALUE,ACCESS_TOKEN:ACCESS_TOKEN_VALUE} WithReturnValeuBlock:^(NSDictionary *responseObject, NSError *error) {
        NSDictionary *dic =responseObject[@"data"];
        NSArray *itemsArr = dic[@"items"];
        NSMutableArray *resultArr = [NSMutableArray array];
        [itemsArr enumerateObjectsUsingBlock:^(NSDictionary *tempDic, NSUInteger idx, BOOL * _Nonnull stop) {
            tempDic = itemsArr[idx];
            WTopScrollModel *model = [[WTopScrollModel alloc]initWithTopScrollModel:tempDic];
            [resultArr addObject:model];
        }];
        if (complete) {
            complete(resultArr);
        }
    }];
}

+ (void)getPromotionViewContent:(void(^)(NSArray *array))complete {
    AFHTTPSessionManager *manager =[AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html", nil];
    [manager POST:@"http://api-v2.mall.hichao.com/active/flash/list?gc=appstore&gf=iphone&gn=mxyc_ip&gv=6.6.3&gi=CBD795AD-1BFC-40FE-A351-407FEAC7219D&gs=640x1136&gos=8.4.1&access_token=" parameters:@{@"app_uid":@"",@"method":@"/active/flash/list",@"sign":@"14d3698d12cf710e4e65a0ba8f541ac0",@"source":@"mxyc_ios",@"token":@"",@"version":@"6.6.3"} progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        NSLog(@"--%@---",responseObject);
        NSDictionary *dic =responseObject[@"response"];
        NSDictionary *dataDic =dic[@"data"];
//       NSLog(@"%@",dataDic);
        NSArray *itemArr = dataDic[@"items"];
        NSMutableArray *resultArr = [NSMutableArray array];
        [itemArr enumerateObjectsUsingBlock:^(NSDictionary *tempDic, NSUInteger idx, BOOL * _Nonnull stop) {
            tempDic = itemArr[idx];
            PromotionModel *model =[[PromotionModel alloc]initWithPromotionModel:tempDic[@"component"]];
            NSLog(@"++--%@",model.img_index);
            [resultArr addObject:model];
        }];
        if (complete) {
            complete(resultArr);
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"--error=%@",error.localizedDescription);

    }];

}

+ (void)getWaterFallViewContent:(void(^)(NSArray *array))complete {
  __block NSMutableArray *resultArr =[NSMutableArray array];
    for (int i=1; i<7; i++) {
//        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            [NetRequestClass netRequestGETWithRequestURL:@"http://api-v2.mall.hichao.com/mall/region/new" WithParameter:@{@"region_id":[NSString stringWithFormat:@"%d",i],GC:GC_VALUE,GF:GF_VALUE,GN:GN_VALUE,GV:GV_VALUE,GI:GI_VALUE,GS:GS_VALUE,GOS:GOS_VALUE,ACCESS_TOKEN:ACCESS_TOKEN_VALUE} WithReturnValeuBlock:^(id responseObject, NSError *error) {
                NSDictionary *dic =responseObject[@"data"];
                RegionModel *model =[[RegionModel alloc]initWithRegionModel:dic];
                [resultArr addObject:model];
                if (resultArr.count==6 &&complete) {
                    complete(resultArr);
                }
            }];
//        });
     
    }
}

+ (void)getNewStyleViewContent:(NSInteger)tag withBlock:(void(^)(NSArray *array))complete {

    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer =[AFHTTPResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes =[NSSet setWithObject:@"application/json"];
    NSArray *httpArr =@[@"http://api-v2.mall.hichao.com/sku/list?more_items=1&type=selection&flag=&gc=appstore&gf=iphone&gn=mxyc_ip&gv=6.6.3&gi=CBD795AD-1BFC-40FE-A351-407FEAC7219D&gs=640x1136&gos=8.4.1&access_token=",@"http://api-v2.mall.hichao.com/sku/list?more_items=1&type=selection&flag=&category_ids=38,33,34&gc=appstore&gf=iphone&gn=mxyc_ip&gv=6.6.3&gi=CBD795AD-1BFC-40FE-A351-407FEAC7219D&gs=640x1136&gos=8.4.1&access_token=",@"http://api-v2.mall.hichao.com/sku/list?more_items=1&type=selection&flag=&category_ids=39,40&gc=appstore&gf=iphone&gn=mxyc_ip&gv=6.6.3&gi=CBD795AD-1BFC-40FE-A351-407FEAC7219D&gs=640x1136&gos=8.4.1&access_token=",@"http://api-v2.mall.hichao.com/sku/list?more_items=1&type=selection&flag=&category_ids=49,45,48,46,44&gc=appstore&gf=iphone&gn=mxyc_ip&gv=6.6.3&gi=CBD795AD-1BFC-40FE-A351-407FEAC7219D&gs=640x1136&gos=8.4.1&access_token="];
    
    
    [manager GET:httpArr[tag-1] parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        NSDictionary *dic1 =dic[@"data"];
        NSArray *itemArr = dic1[@"items"];
        NSMutableArray *relustArr =[NSMutableArray array];
        for (NSDictionary *tempDic in itemArr) {
            WPFGoodsModel *obj =[[WPFGoodsModel alloc]initWPFGoodsModelWithDic:tempDic];
            [relustArr addObject:obj];
        }
        if (complete) {
            complete(relustArr);
        }

    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"-==error==%@",error.localizedDescription);
    }];
    
}

+ (void)getCommunityTopScrollViewContent:(void(^)(NSArray *array))complete {
    [NetRequestClass netRequestGETWithRequestURL:@"http://api-v2.mall.hichao.com/forum/banner?gc=appstore&gf=iphone&gn=mxyc_ip&gv=6.6.3&gi=CBD795AD-1BFC-40FE-A351-407FEAC7219D&gs=640x1136&gos=8.4.1&access_token=" WithParameter:nil WithReturnValeuBlock:^(NSDictionary *responseObject, NSError *error) {
        NSDictionary *dic =responseObject[@"data"];
        NSArray *itemsArr =dic[@"items"];
        NSMutableArray * resultArr =[NSMutableArray array];
        for (NSDictionary *tempDic in itemsArr) {
            NSDictionary *componentDic =tempDic[@"component"];
            WcomponentModel *model =[[WcomponentModel alloc]initWithComponentModel:componentDic];
            [resultArr addObject:model];
        }
        if (complete) {
            complete(resultArr);
        }
    }];
}

+ (void)getBtnTitle:(void(^)(NSArray *array))complete {
    [NetRequestClass netRequestGETWithRequestURL:@"http://api-v2.mall.hichao.com/forum/navigator?gc=appstore&gf=iphone&gn=mxyc_ip&gv=6.6.3&gi=CBD795AD-1BFC-40FE-A351-407FEAC7219D&gs=640x1136&gos=8.4.1&access_token=" WithParameter:nil WithReturnValeuBlock:^(id responseObject, NSError *error) {
        NSDictionary *dataDic =responseObject[@"data"];
        NSArray *itemsArr = dataDic[@"items"];
        NSMutableArray *resultArr =[NSMutableArray array];
        for (NSDictionary *tempDic in itemsArr) {
            WTitleModel *model =[[WTitleModel alloc]initWTitleModelWith:tempDic];
            [resultArr addObject:model];
        }
        if (complete) {
            complete(resultArr);
        }
    }];
}


+ (void)getCommunityTableViewContent:(void(^)(NSArray *array))complete {

    [NetRequestClass netRequestGETWithRequestURL:@"http://api-v2.mall.hichao.com/forum/timeline?nav_id=5&nav_name=%E7%83%AD%E9%97%A8&flag=&user_id=&gc=appstore&gf=iphone&gn=mxyc_ip&gv=6.6.3&gi=CBD795AD-1BFC-40FE-A351-407FEAC7219D&gs=640x1136&gos=8.4.1&access_token=" WithParameter:nil WithReturnValeuBlock:^(id responseObject, NSError *error) {
//        NSLog( @">>>>>>>>>+++>>>>%@",responseObject);
        NSDictionary *dataDic =responseObject[@"data"];
        NSMutableArray *resultArr =[NSMutableArray array];
        NSArray *itemsArr =dataDic[@"items"];
        for (NSDictionary *tempDic in itemsArr) {
            WHotContentModel *obj =[[WHotContentModel alloc]initWHotContentModelWith:tempDic[@"component"]];
            [resultArr addObject:obj];
        }
        if (complete) {
            complete(resultArr);
        }
    }];

}




@end
