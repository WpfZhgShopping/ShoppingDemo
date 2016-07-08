//
//  WTitleModel.h
//  StarClosetDemo
//
//  Created by Mac on 16/7/7.
//  Copyright © 2016年 Mac. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WTitleModel : NSObject
@property (nonatomic,copy) NSString *nav_name;
@property (nonatomic,copy) NSString *nav_id;
- (instancetype)initWTitleModelWith:(NSDictionary *)dic;
@end
