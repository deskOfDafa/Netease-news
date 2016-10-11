//
//  WebViewController.m
//  01-QYNews
//
//  Created by qingyun on 16/9/27.
//  Copyright © 2016年 qingyun. All rights reserved.
//

#import "WebViewController.h"

@interface WebViewController ()<WKUIDelegate,WKNavigationDelegate>
@property(nonatomic,strong)WKWebView *webView;
@end

@implementation WebViewController

- (void)viewDidLoad {
    [self loadWebView];
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
-(void)loadWebView{
    
    WKWebView *webView = [[WKWebView alloc]initWithFrame:self.view.bounds];
    webView.UIDelegate = self;
    webView.navigationDelegate = self;

    [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:_url]]];
    _webView = webView;
    
    [self.view addSubview:_webView];
    
}
//加载失败
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error{
    
    UIView *view = (UIView*)[self.view viewWithTag:108];
    
    [view removeFromSuperview];
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"加载失败" preferredStyle:(UIAlertControllerStyleAlert)];
    
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"重新连接" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
        
        [self loadWebView];
    }];
    
    [alert addAction:action];
    
    UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"返回" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
        
        
        int index = (int)[[self.navigationController viewControllers]indexOfObject:self];
        [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:(index -1)] animated:YES];
    }];
    [alert addAction:action2];
    
    [self presentViewController:alert animated:YES completion:nil];
    
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
