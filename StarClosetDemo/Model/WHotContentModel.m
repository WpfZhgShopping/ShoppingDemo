//
//  WHotContentModel.m
//  StarClosetDemo
//
//  Created by Mac on 16/7/7.
//  Copyright © 2016年 Mac. All rights reserved.
//

#import "WHotContentModel.h"

@implementation WHotContentModel

- (instancetype)initWHotContentModelWith:(NSDictionary *)dic {
    self = [super init];
    if (self) {
        self.comments =[NSMutableArray array];
        self.commentCount =dic[@"commentCount"];
        NSArray *commentArr =dic[@"comments"];
        for (NSDictionary*tempDic in commentArr) {
            CommentsModel *model =[[CommentsModel alloc]initCommentsModelWith:tempDic];
            [self.comments addObject:model];
        }
        self.content =dic[@"content"];
        self.contentHeight =[Tool getHeightWithText:self.content];
        self.pics =[NSMutableArray array];
        [self.pics addObjectsFromArray:dic[@"pics"]];
        self.tags =[NSMutableArray array];
        NSArray *tagsArr = dic[@"tags"];
        for (NSDictionary *tempDic in tagsArr) {
            NSString *category = tempDic[@"category"];
            [self.tags addObject:category];
        }
        self.user =[[UserModel alloc]initUserModelWith:dic[@"user"]];
        self.users =[NSMutableArray array];
        NSArray *usersArr =dic[@"users"];
        for (NSDictionary *usDic in usersArr) {
            UserModel *model =[[UserModel alloc]initUserModelWith:usDic];
            [self.users addObject:model];
        }
       
    }
    return self;
}

@end

@implementation CommentsModel

- (instancetype)initCommentsModelWith:(NSDictionary *)dic {
    if (self =[super init]) {
        self.contact =dic[@"content"];
        self.usersname =dic[@"username"];
        self.contactHeight =[Tool getHeightWithText:self.contact];
    }
    return self;
}

@end

@implementation UserModel

- (instancetype)initUserModelWith:(NSDictionary *)dic {
    if (self =[super init]) {
        self.datatime =dic[@"datatime"];
        self.userAvatar=dic[@"userAvatar"];
        self.username =dic[@"username"];
        
    }
    return self;
}

@end


