//
//  NSDate+String.m
//  01-WeiBo
//
//  Created by qingyun on 16/8/29.
//  Copyright © 2016年 qingyun. All rights reserved.
//

#import "NSDate+String.h"

@implementation NSDate (String)
-(NSString *)stringWithNowDate{
   //1.当前时间和微博发送的差  秒计算
      double interval=-[self timeIntervalSinceDate:[NSDate date]];
    
   //2计算时间 60,60*60,60*60*24 ,显示时间
    if (interval<60) {//秒
        return [NSString stringWithFormat:@"刚刚 %d秒之前",(int)interval];
    }else if (interval<60*60){
        return [NSString stringWithFormat:@"刚刚 %d分之前",(int)interval/60];
    }else if(interval<60*60*24){
        return [NSString stringWithFormat:@" %d小时之前",(int)interval/(60*60)];
    }
    //显示日期
    //直接格式化时间
   /*  NSDateFormatterNoStyle    空白
       NSDateFormatterShortStyle  16/5/07 上午 3:54:00
      NSDateFormatterMediumStyle 2016年10月12日 上午 11：08:01
      NSDateFormatterLongStyle   2016年10月12日 GMT +8 上午 11：08:01
       NSDateFormatterFullStyle 
    */

     return [NSDateFormatter localizedStringFromDate:self dateStyle:NSDateFormatterMediumStyle timeStyle:NSDateFormatterNoStyle];
}
@end
