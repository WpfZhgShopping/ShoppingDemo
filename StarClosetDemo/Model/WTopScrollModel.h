//
//  WTopScrollModel.h
//  StarClosetDemo
//
//  Created by Mac on 16/7/4.
//  Copyright © 2016年 Mac. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@class  WcomponentModel;
@interface WTopScrollModel : NSObject
@property (nonatomic,strong) WcomponentModel *Obj;
@property (nonatomic,copy) NSString *height;
@property (nonatomic,copy) NSString *width;
- (instancetype)initWithTopScrollModel:(NSDictionary*)dic;
@end

@interface WcomponentModel : NSObject
@property (nonatomic,copy) NSString *picUrl;
- (instancetype)initWithComponentModel:(NSDictionary*)dic;




@end