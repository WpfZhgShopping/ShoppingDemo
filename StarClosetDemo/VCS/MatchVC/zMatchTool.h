//
//  zMatchTool.h
//  StarClosetDemo
//
//  Created by Mac on 16/7/4.
//  Copyright © 2016年 Mac. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^myBlock)(NSMutableArray *Array);

typedef void(^tableBlock)(NSMutableArray *Array);

typedef void(^topBlock)(NSMutableArray *Array);

@interface zMatchTool : NSObject




+(void)getWtchMatch:(NSString *)url wtchBlock:(myBlock)block;

+(void)getWtchMatch:(NSString *)url wtchtableBlock:(tableBlock)block;

+(void)getWtchMatch:(NSString *)url wtchtopBlock:(topBlock)block;


@end
