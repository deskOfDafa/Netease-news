//
//  DBHandelClass.m
//  01-QYNews
//
//  Created by qingyun on 16/9/27.
//  Copyright © 2016年 qingyun. All rights reserved.
//

#import "DBHandelClass.h"
#import "FMDB.h"

#define  CreatTable @"create table if not exists home(title text,date text,author_name text,url tetx,thumbnail_pic_s text,type text)"

static FMDatabaseQueue *baseQueue = nil;

@implementation DBHandelClass


+(FMDatabaseQueue *)getBaseQueue{
    // 获取数据库连接对象
    if (!baseQueue) {
        // 合并路径
        NSString *docPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
        //数据库路径
        NSString * filePatch = [docPath stringByAppendingPathComponent:@"home.db"];
        // 创建数据库连接对象
        baseQueue = [FMDatabaseQueue databaseQueueWithPath:filePatch];
    // 创建表
        [DBHandelClass creatTable];
        
    }
    return baseQueue;
}
+(void)creatTable{

    // 创建表]
    [[DBHandelClass getBaseQueue]inDatabase:^(FMDatabase *db) {
        // 线程保护
        if ([db  executeStatements:CreatTable]) {
            NSLog(@"=== creat table ok");
        }
    }];


}
+(void)updateStatemsSql:(NSString *)sql withPrameters:(NSMutableDictionary *)parmaters block:(CallFinished)block{

    // 执行更新操作
    [[DBHandelClass getBaseQueue]inDatabase:^(FMDatabase *db) {
        if (parmaters) {
            BOOL isok = [db executeUpdate:sql withParameterDictionary:parmaters];
            
            NSString *error = [db lastErrorMessage];
            
            block(isok,error);
        }else{
        
        
            block([db executeUpdate:sql],[db lastErrorMessage]);
        
        }
    }];

}





+(void)selectStatmesSql:(NSString *)sql withParmerters:(NSMutableDictionary *)parmaters valuesForModes:(NSString *)mode block:(CallResult)block{

    // 执行查询操作
    [[DBHandelClass getBaseQueue]inDatabase:^(FMDatabase *db) {
        FMResultSet *set = nil;
        if (parmaters) {
            set = [db executeQuery:sql withParameterDictionary:parmaters];
        }else{
        
            set = [db executeQuery:sql];
    
        }
        //循环读取 每行数据将数据存到数组
        NSMutableArray *dataArr = [NSMutableArray array];
        //set 转出字典
        while ([set next]) {
            NSDictionary *vdic = [set resultDictionary];
        //是否需要转换成Mode
            if(mode){
            //将字典转换成模型
                NSObject *newClass =[NSClassFromString(mode)new];
                
                [newClass setValuesForKeysWithDictionary:vdic];
                [dataArr addObject:newClass];
            
            
            }else{
            
                [dataArr addObject:vdic];
            }
            
        }
        
       block(dataArr,[db lastErrorMessage]);
    }];

}













@end
