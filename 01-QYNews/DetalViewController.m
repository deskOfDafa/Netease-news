//
//  DetalViewController.m
//  01-QYNews
//
//  Created by qingyun on 16/8/23.
//  Copyright © 2016年 qingyun. All rights reserved.
//

#import "DetalViewController.h"
#import "ResultMode.h"
#import "NewTableViewCell.h"
#import "AFNetworking.h"
#import "MJRefresh.h"
#import "WebViewController.h"
#import "DBHandelClass.h"
@interface DetalViewController ()<UITableViewDataSource,UITableViewDelegate>

@property(nonatomic,strong) UITableView *tablview;
@property(nonatomic,copy)NSMutableArray *dataArray;
@property(nonatomic,strong)NSString *type;
@property(nonatomic,strong)NSString *URL;
@end

@implementation DetalViewController
 static NSString *identfier=@"cell";

-(NSArray *)dataArray{

    if (!_dataArray) {
         _dataArray = [NSMutableArray new];
        [self fristLocad];
       
    }


    return _dataArray;
}

-(void)fristLocad{
    //首次初始化本地操作
    NSString *sql =@"select * from home where type=:type";
    NSMutableDictionary *dic=[NSMutableDictionary dictionary];
    [dic setObject:_type forKey:@"type"];
    
    [DBHandelClass selectStatmesSql:sql withParmerters:dic valuesForModes:nil block:^(NSMutableArray *resuletArr, NSString *errorMsg) {
        
    
        for (NSMutableDictionary *dic in resuletArr) {
//            //反序列化
//            [dic descSerialization];
            //mode kvc 赋值
            ResultMode *mode=[ResultMode modeWithDictionary:dic];
            //mode 存入数组
            [self.dataArray addObject:mode];
        }
        
    }];
}
-(void)request{
    DetalViewController *weakSelf = self;
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/plain", @"text/javascript", @"text/json", @"text/html", nil];
    
    [manager GET:_URL parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
         NSData * data = [NSData dataWithContentsOfURL:[NSURL URLWithString:_URL]];
        NSJSONSerialization *json = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
        NSDictionary *dic = [json valueForKey:@"result"];
        NSArray *array = [dic valueForKey:@"data"];
        
        
        
        [_dataArray removeAllObjects];
        //本地的数据也清空掉
        NSString *temsql = [NSString stringWithFormat:@"delete from home where type=%@",_type];
        [DBHandelClass updateStatemsSql:temsql withPrameters:nil block:^(BOOL result, NSString *errorMsg) {
    
            if (!result) {
                NSLog(@"====%@",errorMsg);
            }
        }];
        for (NSDictionary *dic in array) {
            
           NSMutableDictionary *temdic = [NSMutableDictionary new];
            NSDictionary *dic1 = [NSDictionary new];
            NSMutableDictionary *vDic = [NSMutableDictionary   new];
            if ([dic.allKeys containsObject:@"category"]) {
                 NSString*type = [dic valueForKey:@"category"];
                [temdic setDictionary:dic];
                [temdic removeObjectForKey:@"category"];
                [temdic setValue:type forKey:@"type"];
                dic1 = [temdic copy];
                
                
           ResultMode *mode = [ResultMode modeWithDictionary:dic];
            [_dataArray addObject:mode];
           vDic=[NSMutableDictionary dictionaryWithDictionary:dic1];
            }else{
                ResultMode *mode = [ResultMode modeWithDictionary:dic];
                
                [_dataArray addObject:mode];
              vDic =[NSMutableDictionary dictionaryWithDictionary:dic];
            }
//            NSMutableDictionary *dic=[NSMutableDictionary dictionary];
//            [dic setObject:_type forKey:@"type"];
            //2.2数据持久化到数据库里
            NSString *sql=@"insert into home values(:title,:date,:author_name,:url,:thumbnail_pic_s,:type)";
            //声明静态的数据库连接对象  title text,date text,author_name text,url tetx,thumbnail_pic_s text
            //进行序列化
           
       
            
            [DBHandelClass updateStatemsSql:sql withPrameters:vDic block:^(BOOL result, NSString *errorMsg) {
                
                if(!result)NSLog(@":::=====%@",errorMsg);
            }];
            [_tablview.mj_header endRefreshing];
            
        }
        if([NSThread isMainThread]) {
            //3.刷新tableview
            [weakSelf.tablview reloadData];
        }else{
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf.tablview reloadData];
                
            });
        }

    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"fdsfds");
        [_tablview.mj_header endRefreshing];
    }];

}




-(void)addsubView{
    //不透明
    
    self.tablview=[[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-104) style:UITableViewStylePlain];
    _tablview.estimatedRowHeight =80;
    _tablview.dataSource=self;
   _tablview.delegate=self;
    NSString *nibName = NSStringFromClass([NewTableViewCell class]);
    [_tablview registerNib:[UINib nibWithNibName:nibName bundle:nil] forCellReuseIdentifier:identfier];
   _tablview.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
       [self request];
   }];
    [self.view addSubview:_tablview];
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    WebViewController *webVC = [WebViewController new];
    ResultMode *resultMode = self.dataArray[indexPath.row];
    webVC.url =resultMode.url;
    
    [self.navigationController pushViewController:webVC animated:YES];


}
#pragma mark dataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
   
   
   NewTableViewCell*cell=[tableView dequeueReusableCellWithIdentifier:identfier];
    ResultMode *resultMode = self.dataArray[indexPath.row];
    cell.resultMode = resultMode;
    return cell;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.type = _temtype;
    self.URL=_temURL;
    [self request];
    [self addsubView];
   
    // Do any additional setup after loading the view.
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];

}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
