//
//  OkWebViewController.h
//  OkWebView
//
//  Created by qq on 2017/4/28.
//  Copyright © 2017年 fangxian. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OkWebViewController : UIViewController

@property (nonatomic, copy) NSString *url;

@property (nonatomic, assign) BOOL canDownRefresh;
@property (nonatomic, assign) BOOL hiddenNav;//OkWebViewController 中本身的位置决定

@end
