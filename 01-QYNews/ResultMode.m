//
//  ResultMode.m
//  01-QYNews
//
//  Created by qingyun on 16/9/1.
//  Copyright © 2016年 qingyun. All rights reserved.
//

#import "ResultMode.h"

@implementation ResultMode



-(void)setValue:(id)value forUndefinedKey:(NSString *)key{
    if ([key isEqualToString:@"category"]) {
         [self setValue:value forKey:@"type"];
    }

}
+(instancetype)modeWithDictionary:(NSDictionary *)dic{


    return [[self alloc]initWithDictionary:dic];

}
-(instancetype)initWithDictionary:(NSDictionary *)dic{
    if (self=[super init]) {
        [self setValuesForKeysWithDictionary:dic];
    }
    return self;
}
@end
