//
//  WebTableViewCell.m
//  ZhuanFang
//
//  Created by 李盼盼 on 16/4/6.
//  Copyright © 2016年 李盼盼. All rights reserved.
//

#import "WebTableViewCell.h"

@interface WebTableViewCell () <UIWebViewDelegate> {
    UIWebView *_webView;
    UIActivityIndicatorView *_loadingView;
    BOOL _loadedHtml; // 判断是否已经加载过HTML
}
@end
@implementation WebTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (!(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])) return nil;
    
    self.backgroundColor = [UIColor whiteColor];
    self.contentView.backgroundColor = self.backgroundColor;
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    [self setupSubviews];
    return self;
}
- (void)setupSubviews {
    _loadedHtml = NO; // default is NO.
    // webView
    _webView = [[UIWebView alloc] init];
    _webView.backgroundColor = [UIColor whiteColor];
    _webView.hidden   = YES;
    _webView.delegate = self;
    _webView.scrollView.scrollEnabled = NO;
    _webView.userInteractionEnabled = NO;
    // 使用AutoLayout布局
    _webView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.contentView addSubview:_webView];
    NSArray *webViewConstraints1 = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_webView]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_webView)];
    NSArray *webViewConstraints2 = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_webView]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_webView)];
    [self.contentView addConstraints:webViewConstraints1];
    [self.contentView addConstraints:webViewConstraints2];
    
    // 加载动画
    _loadingView = [[UIActivityIndicatorView alloc] init];
    _loadingView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
    _loadingView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.contentView addSubview:_loadingView];
    // X轴居中
    NSLayoutConstraint *constraintX = [NSLayoutConstraint constraintWithItem:_loadingView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeCenterX multiplier:1 constant:0];
    // y轴居中
    NSLayoutConstraint *constraintY = [NSLayoutConstraint constraintWithItem:_loadingView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeCenterY multiplier:1 constant:0];
    [self.contentView addConstraints:@[constraintX, constraintY]];
}

#pragma mark - setter

- (void)setHtmlString:(NSString *)htmlString {
    if (_loadedHtml) return; // 加载过HTML就不再加载
    [_webView loadHTMLString:htmlString baseURL:nil];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:[htmlString copy]]];
    [_webView loadRequest:request];
}

// UIWebViewDelegate
- (void)webViewDidStartLoad:(UIWebView *)webView {
    NSLog(@"开始加载时间%@",[NSDate date]);
    _loadedHtml = YES; // 标记开始加载HTML
    [_loadingView startAnimating];
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    _loadedHtml = NO; // 加载HTML失败, 允许重新加载
    [_loadingView stopAnimating];
    NSLog(@"网页加载失败");
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    NSLog(@"结束加载时间%@",[NSDate date]);
    if (!webView.isLoading) {
        // 加载完成后回收loading动画
        [_loadingView stopAnimating];
        [_loadingView removeFromSuperview];
        _loadingView = nil;
        
        _loadedHtml     = YES; // 标记已经完成HTML的加载
        _webView.hidden = NO;
        
        // 获取webView内容实际高度
        float height = [[webView stringByEvaluatingJavaScriptFromString:@"document.documentElement.scrollHeight"] floatValue];
        if ([self.delegate respondsToSelector:@selector(webViewCell:loadedHTMLWithHeight:)]) {
            [self.delegate webViewCell:self loadedHTMLWithHeight:height];
        }
    }
}

@end
