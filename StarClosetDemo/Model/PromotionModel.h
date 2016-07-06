//
//  PromotionModel.h
//  StarClosetDemo
//
//  Created by Mac on 16/7/4.
//  Copyright © 2016年 Mac. All rights reserved.
//

#import <Foundation/Foundation.h>
@interface PromotionModel : NSObject
@property (nonatomic,copy) NSString *activity_time;
@property (nonatomic,copy) NSString *end_time;
@property (nonatomic,copy) NSString *img_index;
@property (nonatomic,copy) NSString *preheat_time;
@property (nonatomic,copy) NSString *start_time;
- (instancetype)initWithPromotionModel:(NSDictionary *)dic;
@end

