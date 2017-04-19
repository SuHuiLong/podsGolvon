//
//  UserDetailViewController.h
//  Golvon
//
//  Created by shiyingdong on 16/4/19.
//  Copyright © 2016年 李盼盼. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UserDetailViewController : UIViewController
@property (copy, nonatomic) UIWebView *webView;
@property (copy, nonatomic) NSString *picUrl;
@property(nonatomic,copy)NSString *urlStr;
@property(nonatomic,copy)NSString *titleStr;
@property(nonatomic,copy)NSString *loginStyle;
@property (copy, nonatomic) NSString *isShare;
@property (copy, nonatomic) NSString *despStr;
@end
