//
//  NSString+statuses.m
//  01-WeiBo
//
//  Created by qingyun on 16/8/29.
//  Copyright © 2016年 qingyun. All rights reserved.
//

#import "NSString+statuses.h"

@implementation NSString (statuses)
//-(NSString *)soureWithHtml{
////<a href="http://app.weibo.com/t/feed/4cq1iX" rel="nofollow">微博活动</a>
//
//   // [htmlString componentsSeparatedByString:@"<>"]
//    
//    NSArray *strArr=[self componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"><"]];
//    
//    if (strArr.count<2) {
//        return nil;
//    }
//    return strArr[2];
//}

-(NSDate *)statusesDateWithString{
   
//    NSDateFormatter *inputFormatter = [[[NSDateFormatter alloc] init]autorelease];
//    [inputFormattersetDateFormat:@"yyyy-MM-dd HH:mm"];
//    NSDate* inputDate = [inputFormatter dateFromString:string];
    
    //时间格式
    NSString *formatter=@"yyyy-MM-dd HH:mm";
    //创建格式化对象
    NSDateFormatter *dataFormatter=[[NSDateFormatter alloc] init];
    dataFormatter.dateFormat=formatter;
    dataFormatter.locale=[NSLocale localeWithLocaleIdentifier:@"zh-CH"];
    return [dataFormatter dateFromString:self];
    
}
  // [NSStringstringWithFormat:@"%@",[selfgetNowDateFromatAnDate:self]];



@end
