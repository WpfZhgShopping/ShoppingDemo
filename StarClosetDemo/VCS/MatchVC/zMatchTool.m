//
//  zMatchTool.m
//  StarClosetDemo
//
//  Created by Mac on 16/7/4.
//  Copyright © 2016年 Mac. All rights reserved.
//

#import "zMatchTool.h"
#import "AFNetworking.h"
#import "zMatchNodel.h"
#import "zTableModel.h"
@implementation zMatchTool

+(void)getWtchMatch:(NSString *)url wtchBlock:(myBlock)block{
    
   
    AFHTTPSessionManager *manger = [AFHTTPSessionManager manager];
    manger.responseSerializer =[AFHTTPResponseSerializer serializer];
    manger.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", nil];
    [manger GET:url parameters:self progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
       // NSLog(@"%@",responseObject);
       NSMutableArray *dataArray = [zMatchNodel dataAnalysis:responseObject];
        
        
        if (block) {
            block(dataArray);
        }
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
       // NSLog(@"%@",error.localizedDescription);
        if (block) {
            block(nil);
        }
        
    }];
}
+(void)getWtchMatch:(NSString *)url wtchtableBlock:(tableBlock)block{
    AFHTTPSessionManager *manger = [AFHTTPSessionManager manager];
    manger.responseSerializer =[AFHTTPResponseSerializer serializer];
    manger.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", nil];
    [manger GET:url parameters:self progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        // NSLog(@"%@",responseObject);
        NSMutableArray *dataArray = [zTableModel dataAnalysis:responseObject];
        
        
        
        if (block) {
            block(dataArray);
        }
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
         NSLog(@"%@",error.localizedDescription);
        if (block) {
            block(nil);
        }
        
    }];
}
+(void)getWtchMatch:(NSString *)url wtchtopBlock:(topBlock)block{
    AFHTTPSessionManager *manger = [AFHTTPSessionManager manager];
    manger.responseSerializer =[AFHTTPResponseSerializer serializer];
    manger.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", nil];
    [manger GET:url parameters:self progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSUTF8StringEncoding error:nil];
        NSDictionary *dataDic = dic[@"data"];
        NSMutableArray *dataArray = @[].mutableCopy;
        NSArray *arr = dataDic[@"items"];
        for (NSDictionary *Diccom in arr) {
            NSDictionary *componentDic = Diccom[@"component"];
            NSString *picUrl = componentDic[@"picUrl"];
            
            [dataArray addObject:picUrl];
        }
        if (block) {
            block(dataArray);
        }
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (block) {
            block(nil);
        }
    }];
}

@end
