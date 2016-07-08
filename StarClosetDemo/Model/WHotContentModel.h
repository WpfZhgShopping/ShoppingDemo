//
//  WHotContentModel.h
//  StarClosetDemo
//
//  Created by Mac on 16/7/7.
//  Copyright © 2016年 Mac. All rights reserved.
//

#import <Foundation/Foundation.h>
@class CommentsModel;
@class UserModel;
@interface WHotContentModel : NSObject
@property (nonatomic,copy) NSString *commentCount;
@property (nonatomic,strong) NSMutableArray *comments;
@property (nonatomic,copy) NSString *content;
@property (nonatomic,strong) NSMutableArray *pics;
@property (nonatomic,strong) NSMutableArray *tags;
@property (nonatomic,strong) UserModel *user;
@property (nonatomic,assign) float contentHeight;
@property (nonatomic,strong) NSMutableArray *users;
- (instancetype)initWHotContentModelWith:(NSDictionary *)dic;
@end

@interface CommentsModel : NSObject
@property (nonatomic,copy) NSString *contact;
@property (nonatomic,copy) NSString *usersname;
@property (nonatomic,assign) float contactHeight;
- (instancetype)initCommentsModelWith:(NSDictionary *)dic;
@end

@interface UserModel :NSObject
@property (nonatomic,copy) NSString *datatime;
@property (nonatomic,copy) NSString *userAvatar;
@property (nonatomic,copy) NSString *username;

- (instancetype)initUserModelWith:(NSDictionary *)dic;
@end








