//
//  RegionModel.h
//  StarClosetDemo
//
//  Created by Mac on 16/7/4.
//  Copyright © 2016年 Mac. All rights reserved.
//

#import <Foundation/Foundation.h>
@class SkusModel;
@interface RegionModel : NSObject
@property (nonatomic,strong) NSMutableArray *nameArr;
@property (nonatomic,strong) NSMutableArray *brandsArr;
@property (nonatomic,strong) NSMutableArray *pictureArr;
@property (nonatomic,strong) NSMutableArray *skusArr;
@property (nonatomic,strong) SkusModel *model;
- (instancetype)initWithRegionModel:(NSDictionary*)dic;
@end

@interface SkusModel : NSObject
@property (nonatomic,copy) NSString *origin_price;
@property (nonatomic,copy) NSString *price;
@property (nonatomic,copy) NSString *title;
@property (nonatomic,copy) NSString *picUrl;
- (instancetype)initSkusModelWith:(NSDictionary*)dic;
@end