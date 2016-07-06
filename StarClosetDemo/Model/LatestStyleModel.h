//
//  LatestStyleModel.h
//  StarClosetDemo
//
//  Created by Mac on 16/7/5.
//  Copyright © 2016年 Mac. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LatestStyleModel : NSObject
@property (nonatomic,copy) NSString *descrip;
@property (nonatomic,copy) NSString *nationalFlag;
@property (nonatomic,copy) NSString *picUrl;
@property (nonatomic,copy) NSString *price;
@property (nonatomic,copy) NSString *origin_price;
@property (nonatomic,copy) NSString *country;

- (instancetype)initLatestStyleModelWith:(NSDictionary *)dic;
@end


@interface WPFGoodsModel : NSObject
@property (nonatomic,copy) NSString *height;
@property (nonatomic,copy) NSString *width;
@property (nonatomic,strong) LatestStyleModel *model;
- (instancetype)initWPFGoodsModelWithDic:(NSDictionary *)dic;
@end