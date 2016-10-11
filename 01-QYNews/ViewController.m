//
//  ViewController.m
//  01-QYNews
//
//  Created by qingyun on 16/8/23.
//  Copyright © 2016年 qingyun. All rights reserved.
//

#import "ViewController.h"
#import "QYTitleScrlloview.h"
#import "DetalViewController.h"



@interface ViewController ()<UIPageViewControllerDelegate,UIPageViewControllerDataSource>
//声明标题视图
@property(nonatomic,strong)QYTitleScrlloview *titleView;
//pageViewController 分页视图 控制视图的滑动
@property(nonatomic,strong)UIPageViewController *pageViewController;

@property(nonatomic,strong)NSArray *titleArr;

@property(nonatomic,strong)NSArray *urlArr;
@property(nonatomic,strong)NSMutableArray *dataArr;
@end

@implementation ViewController

//懒加载
-(NSArray*)titleArr{
    if (!_titleArr) {
        _titleArr=@[@"头条",@"社会",@"国内",@"国际",@"娱乐",@"体育",@"军事",@"科技",@"财经",@"时尚"];
    }
    return _titleArr;
}

-(NSArray *)urlArr{
    if (!_urlArr) {
        _urlArr = @[@"http://v.juhe.cn/toutiao/index?type=top&key=5a3210b0acbaa187235a9936ec9a28ce",
                    @"http://v.juhe.cn/toutiao/index?type=shehui&key=5a3210b0acbaa187235a9936ec9a28ce",
                    @"http://v.juhe.cn/toutiao/index?type=guonei&key=5a3210b0acbaa187235a9936ec9a28ce",
                    @"http://v.juhe.cn/toutiao/index?type=guoji&key=5a3210b0acbaa187235a9936ec9a28ce",
                    @"http://v.juhe.cn/toutiao/index?type=yule&key=5a3210b0acbaa187235a9936ec9a28ce",
                    @"http://v.juhe.cn/toutiao/index?type=tiyu&key=5a3210b0acbaa187235a9936ec9a28ce",
                    @"http://v.juhe.cn/toutiao/index?type=junshi&key=5a3210b0acbaa187235a9936ec9a28ce",
                    @"http://v.juhe.cn/toutiao/index?type=keji&key=5a3210b0acbaa187235a9936ec9a28ce",
                    @"http://v.juhe.cn/toutiao/index?type=caijing&key=5a3210b0acbaa187235a9936ec9a28ce",
                    @"http://v.juhe.cn/toutiao/index?type=shishang&key=5a3210b0acbaa187235a9936ec9a28ce"];
    }
    return _urlArr;

}
-(QYTitleScrlloview *)titleView{
    if (!_titleView) {
       //初始化
        _titleView=[QYTitleScrlloview titleScrollViewWithTitles:self.titleArr];
        //接受回调参数
        __weak ViewController *vc=self;
        _titleView.titleBlock=^(NSInteger index){
          //更新pageViewController的视图
            [vc changeViewControllerWithIndex:index];
        };
    }
    return _titleView;
}

-(void)changeViewControllerWithIndex:(NSInteger)index{
   //获取当前一个视图
    DetalViewController *detailVc=[[DetalViewController alloc] init];
    detailVc.temtype=self.titleArr[index];
    detailVc.temURL = self.urlArr[index];
    
   //显示当前控制器
    [self.pageViewController setViewControllers:@[detailVc] direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:nil];
}


-(UIPageViewController *)pageViewController{
    if (!_pageViewController) {
       //初始化
        _pageViewController=[[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:nil];
        //设置delegate ，dataSource
        _pageViewController.delegate=self;
        _pageViewController.dataSource=self;
        
    }
    return _pageViewController;
}
//添加视图
-(void)addSubView
{
    //1.添加PageViewController;
    [self addChildViewController:self.pageViewController];
    self.pageViewController.view.frame=CGRectMake(0,40, self.view.frame.size.width, self.view.frame.size.height-40);
    [self.view addSubview:self.pageViewController.view];
    //2.添加titleView
   [self.view addSubview:self.titleView];
    //self.navigationItem.titleView=self.titleView;
    //3.设置要显示的视图
//    [self.pageViewController setViewControllers:@[[DetalViewController new]] direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:nil];
    [self changeViewControllerWithIndex:0];
//    
  // ViewController *vc=[NSClassFromString(@"ViewController") new];
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    //设置导航栏为不透明
    self.navigationController.navigationBar.translucent=NO;
    [self addSubView];
    // Do any additional setup after loading the view, typically from a nib.
}

//返回控制器type对应数组的下标
-(NSUInteger)viewControllerOfIndex:(DetalViewController *)vc{
    return [self.titleArr indexOfObject:vc.temtype];
}
//给一个下标获取一个控制器对象
-(DetalViewController *)getViewControllerOfIndex:(NSInteger)index{
    DetalViewController *vc=[DetalViewController new];
    //type
    vc.temtype=self.titleArr[index];
    vc.temURL=self.urlArr[index];
    return vc;
}

#pragma mark PageViewController DataSource
//上一个控制器
-(UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController{
   //1.找到PageViewController显示的当前控制器对象
      DetalViewController *detalVc = self.pageViewController.viewControllers.firstObject;
    //2.找到detalVc.type 对应数组中的下标
    NSInteger currentIndex=[self viewControllerOfIndex:detalVc];
    if (currentIndex==0) {
        return nil;
    }
    //3.初始化上一个控制器
    return [self getViewControllerOfIndex:currentIndex-1];
    
}
//下一个控制器
-(UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController{
    //1.获取当前选中的控制器对象
    DetalViewController *vc=self.pageViewController.viewControllers.firstObject;
    //2.找到当前控制器type值对应titleArr的下标
       NSInteger currentIndex=[self viewControllerOfIndex:vc];
    //3.判断 下标是否等于titleArr.count-1
    if (currentIndex==self.titleArr.count-1) {
        return nil;
    }
    //4.初始化下一个控制器对象
    return [self getViewControllerOfIndex:currentIndex+1];
}

#pragma mark pageViewControllerDelegate
//当动画完成后调用
-(void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray<UIViewController *> *)previousViewControllers transitionCompleted:(BOOL)completed{
    //1.获取当前显示的控制器对象
    DetalViewController *showVc=pageViewController.viewControllers.firstObject;
    //获取当前显示的下边
    NSInteger currentIndex=[self viewControllerOfIndex:showVc];
    //2.获取上个控制器对象
    DetalViewController *previousVc=(DetalViewController *)previousViewControllers.firstObject;
    //获取上个控制器下标
    NSInteger preIndex=[self viewControllerOfIndex:previousVc];
    
    if(preIndex!=currentIndex){
    //设置选中的标题
    _titleView.selectIndex=currentIndex;
    }
    
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
