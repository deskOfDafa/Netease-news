//
//  ResultMode.h
//  01-QYNews
//
//  Created by qingyun on 16/9/1.
//  Copyright © 2016年 qingyun. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ResultMode : NSObject
@property(nonatomic,strong)NSString *title;
@property(nonatomic,strong)NSString *date;
@property(nonatomic,strong)NSString *author_name;
@property(nonatomic,strong)NSString *url;
@property(nonatomic,strong)NSString *thumbnail_pic_s;
@property(nonatomic,strong)NSString *type;
+(instancetype)modeWithDictionary:(NSDictionary *)dic;
-(instancetype)initWithDictionary:(NSDictionary *)dic;
@end
