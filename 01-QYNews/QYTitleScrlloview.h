//
//  QYTitleScrlloview.h
//  01-QYNews
//
//  Created by qingyun on 16/8/23.
//  Copyright © 2016年 qingyun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QYTitleScrlloview : UIScrollView
//当前选中那个btn
@property(nonatomic,assign)NSInteger selectIndex;

@property(nonatomic,strong)void(^titleBlock)(NSInteger);


+(instancetype)titleScrollViewWithTitles:(NSArray *)titles;




@end
