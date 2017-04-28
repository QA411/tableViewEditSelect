//
//  ViewController.m
//  OkWebView
//
//  Created by qq on 2017/4/28.
//  Copyright © 2017年 fangxian. All rights reserved.
//

#import "ViewController.h"
#import "OkWebViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (IBAction)enterWebViewController:(id)sender {
    OkWebViewController *okVc = [[OkWebViewController alloc]init];
    okVc.url = @"https://www.baidu.com";
    okVc.canDownRefresh = YES;
    okVc.hiddenNav = YES;
    [self.navigationController pushViewController:okVc animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
