//
//  DBHandelClass.h
//  01-QYNews
//
//  Created by qingyun on 16/9/27.
//  Copyright © 2016年 qingyun. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef void(^CallFinished) (BOOL result,NSString *errorMsg);
typedef void(^CallResult)(NSMutableArray *resuletArr,NSString  *errorMsg);

@interface DBHandelClass : NSObject

+(void)updateStatemsSql:(NSString *)sql withPrameters:(NSMutableDictionary *)parmaters block:(CallFinished)block;

+(void)selectStatmesSql:(NSString *)sql withParmerters:(NSMutableDictionary *)parmaters valuesForModes:(NSString *)mode block:(CallResult)block;



@end
