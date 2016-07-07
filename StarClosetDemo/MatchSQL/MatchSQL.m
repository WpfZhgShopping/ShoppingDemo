//
//  MatchSQL.m
//  StarClosetDemo
//
//  Created by Mac on 16/7/5.
//  Copyright © 2016年 Mac. All rights reserved.
//

#import "MatchSQL.h"
#import "FMDB.h"

static FMDatabase *__db;

@implementation MatchSQL

-(void)createTableIsTableViewAndCollectView{
    
    NSString *path = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/data.sqlite"];
//    NSLog(@"%@",path);
    __db = [FMDatabase databaseWithPath:path];
    [__db open];
    NSString *tableStr = @"create table if not exists tableView (id integer primary key autoincrement,image text,title text,collectionCount number,itemsCount number,with number,height number)";
    if ([__db open]) {
        if ([__db executeUpdate:tableStr]) {
//            NSLog(@"tableViewiew表格创建成功");
        }
    }
    NSString *collectViewStr = @"create table if not exists collectView (id integer primary key autoincrement,image text,title text,commentCount number,collectionCount number,v number,day bunber,category text)";
    if ([__db open]) {
        if ([__db executeUpdate:collectViewStr]) {
//            NSLog(@"collectView表格创建成功");
        }
    }
    
}



@end
