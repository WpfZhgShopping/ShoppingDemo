//
//  UIPageControl+Extension.m
//  StarClosetDemo
//
//  Created by Mac on 16/7/4.
//  Copyright © 2016年 Mac. All rights reserved.
//

#import "UIPageControl+Extension.h"

@implementation UIPageControl (Extension)

+ (UIPageControl*)createPageControlWithFrame:(CGRect)frame numberOfPages:(NSInteger)number pageIndicatorTintColor:(UIColor*)color currentPageIndicatorTintColor:(UIColor*)currentColor {
    UIPageControl * page = [[UIPageControl alloc]initWithFrame:frame];
    page.numberOfPages =number;
    page.pageIndicatorTintColor = color;
    page.currentPageIndicatorTintColor = currentColor;
    return page;
}

@end
