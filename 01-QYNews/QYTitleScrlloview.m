//
//  QYTitleScrlloview.m
//  01-QYNews
//
//  Created by qingyun on 16/8/23.
//  Copyright © 2016年 qingyun. All rights reserved.
//

#import "QYTitleScrlloview.h"

#define screenWidth [UIScreen mainScreen].bounds.size.width
#define screenHeight [UIScreen mainScreen].bounds.size.height
#define SHeight 40
//按钮宽度
#define Kwidth  60
#define KSpace  5

@interface QYTitleScrlloview ()
@property(nonatomic,strong)UIView *lineView;

@end


@implementation QYTitleScrlloview

//懒加载
-(UIView *)lineView{
    if (!_lineView) {
        _lineView=[[UIView alloc] initWithFrame:CGRectMake(0,SHeight-2, Kwidth, 2)];
        _lineView.backgroundColor=[UIColor redColor];
    }
    return _lineView;
}

//返回标题视图
+(instancetype)titleScrollViewWithTitles:(NSArray *)titles{
    QYTitleScrlloview *scrollView=[[QYTitleScrlloview alloc] initWithFrame:CGRectMake(0, 0, screenWidth, SHeight)];
    //添加btn
    for (NSInteger i =0; i<titles.count; i++) {
         UIButton *btn=[UIButton buttonWithType:UIButtonTypeCustom];
         btn.frame=CGRectMake((Kwidth+KSpace)*i, 0, Kwidth, SHeight);
        //设置标题颜色
        [btn setTitleColor:[UIColor redColor] forState:UIControlStateSelected];
        [btn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        //设置标题
        [btn setTitle:titles[i] forState:UIControlStateNormal];
        //设置点击事件
        [btn addTarget:scrollView action:@selector(clickChange:) forControlEvents:UIControlEventTouchUpInside];
        //设置tag
        btn.tag=100+i;
        //设置btn的字体大小
        btn.titleLabel.font=[UIFont systemFontOfSize:15];
        //隐藏滑动条
        scrollView.showsHorizontalScrollIndicator=NO;
        
        //添加到当前视图
        [scrollView addSubview:btn];
        
    }
    //设置contentSize
    scrollView.contentSize=CGSizeMake((Kwidth+KSpace)*titles.count, SHeight);

    scrollView.backgroundColor=[UIColor clearColor];
    
    //添加到动画视图
    [scrollView addSubview:scrollView.lineView];
    
    //设置当前选中状态
    scrollView.selectIndex=0;
    
   
    return scrollView;
}
//btn 点击事件
-(void)clickChange:(UIButton *)sender{
    //判断当前选中的btn是否是同一个btn
    if (_selectIndex!=sender.tag-100) {
        //更改选中
        self.selectIndex=sender.tag-100;
        //回调当前选中的下标
        if (_titleBlock) {
           _titleBlock(self.selectIndex);
        }
       

    }
    
    
    
}

//重写set 更改选中状态
-(void)setSelectIndex:(NSInteger)selectIndex{
    //1.获取上一个选中btn
    UIButton *selectBtn=(UIButton *)[self viewWithTag:100+_selectIndex];
     //1.1 取消btn选中状态
      selectBtn.selected=NO;

   //2.获取当前选中btn
    UIButton *willSelectBtn=(UIButton *)[self viewWithTag:100+selectIndex];
      //2.1 设置当前btn为选中状态
    willSelectBtn.selected=YES;
    
   //3.把最新的值赋盖旧值
    _selectIndex=selectIndex;
   //4.lineView 滑动到选中视图
    CGPoint center=_lineView.center;
    center.x=willSelectBtn.center.x;
    [UIView animateWithDuration:.2 animations:^{
        _lineView.center=center;
    }];
    
    //5.计算偏移量 （scrollerView 滑动至中心算法）
    CGFloat detalValue=willSelectBtn.center.x-self.center.x;

    if (detalValue<0) {
        detalValue=0;
    }
    else if(detalValue>self.contentSize.width-self.frame.size.width){
        detalValue=self.contentSize.width-self.frame.size.width;
    }
    
    [self setContentOffset:CGPointMake(detalValue, 0) animated:YES];
    
}



@end
