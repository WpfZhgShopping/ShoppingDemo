//
//  WPFHttpManager.h
//  StarClosetDemo
//
//  Created by Mac on 16/7/4.
//  Copyright © 2016年 Mac. All rights reserved.
//

#import <Foundation/Foundation.h>
@interface WPFHttpManager : NSObject

+ (void)getMainVCTopScrollViewContent:(void(^)(NSArray *array))complete;
//获取限时购内容
+ (void)getPromotionViewContent:(void(^)(NSArray *array))complete;
//获取各国馆内容
+ (void)getWaterFallViewContent:(void(^)(NSArray *array))complete;
//获取今日上新内容
+ (void)getNewStyleViewContent:(NSInteger)tag withBlock:(void(^)(NSArray *array))complete;

+ (void)getCommunityTopScrollViewContent:(void(^)(NSArray *array))complete;

//获取三个button的标题
+ (void)getBtnTitle:(void(^)(NSArray *array))complete;

+ (void)getCommunityTableViewContent:(void(^)(NSArray *array))complete;
@end
