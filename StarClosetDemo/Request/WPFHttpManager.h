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


@end
