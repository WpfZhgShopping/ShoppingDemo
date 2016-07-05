//
//  zMatchTool.h
//  StarClosetDemo
//
//  Created by Mac on 16/7/4.
//  Copyright © 2016年 Mac. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^myBlock)(NSMutableArray *Array);

@interface zMatchTool : NSObject




+(void)getWtchMatch:(NSString *)url wtchBlock:(myBlock)block;


@end
