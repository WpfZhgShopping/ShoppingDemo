//
//  Tool.m
//  StarClosetDemo
//
//  Created by Mac on 16/7/7.
//  Copyright © 2016年 Mac. All rights reserved.
//

#import "Tool.h"

@implementation Tool

+ (CGFloat)getHeightWithText:(NSString *)str {
    CGRect endRect =[str boundingRectWithSize:CGSizeMake(kMainBoundsW, 0) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} context:nil];
    return endRect.size.height;
}



@end
