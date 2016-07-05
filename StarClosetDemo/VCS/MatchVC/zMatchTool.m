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
@implementation zMatchTool

+(void)getWtchMatch:(NSString *)url wtchBlock:(myBlock)block{
    
   
    NSMutableArray *dataArr = @[].mutableCopy;
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

@end
