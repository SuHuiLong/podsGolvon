//
//  InterviewWebviewCell.m
//  podsGolvon
//
//  Created by apple on 2016/12/28.
//  Copyright © 2016年 suhuilong. All rights reserved.
//

#import "InterviewWebviewCell.h"

@interface InterviewWebviewCell ()<UIWebViewDelegate>
{
    
    UIWebView *_webView;
    UIActivityIndicatorView *_loadingView;
    BOOL _loadedHtml; // 判断是否已经加载过HTML
}
@end
@implementation InterviewWebviewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self createCell];
        self.backgroundColor = WhiteColor;
    }
    return self;
}

-(void)createCell{
    
    _loadedHtml = NO; // default is NO.
    // webView
    _webView = [[UIWebView alloc] init];
    _webView.backgroundColor = [UIColor whiteColor];
    _webView.hidden   = YES;
    _webView.delegate = self;
    _webView.scrollView.scrollEnabled = NO;
    _webView.userInteractionEnabled = YES;
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
    
    _thumbUp = [[UILabel alloc] init];
    _thumbUp.frame = CGRectMake(0, _webView.bottom+kHvertical(23), kWvertical(79), kHvertical(23));
    _thumbUp.textColor = deepColor;
    _thumbUp.hidden = true;
    _thumbUp.font = [UIFont systemFontOfSize:kHorizontal(12)];
    [self.contentView addSubview:_thumbUp];
    
    _readNum = [[UILabel alloc] initWithFrame:CGRectMake(kWvertical(79), _webView.bottom+kHvertical(23), kWvertical(100), kHvertical(23))];
    _readNum.textColor = textTintColor;
    _readNum.hidden = true;
    _readNum.font = [UIFont systemFontOfSize:kHorizontal(12)];
    _readNum.font = [UIFont systemFontOfSize:kHorizontal(12)];
    [self.contentView addSubview:_readNum];
}


#pragma mark - setter

- (void)setHtmlString:(NSString *)htmlString {

    if (_loadedHtml) return; // 加载过HTML就不再加载
    [_webView loadHTMLString:htmlString baseURL:nil];
    NSString *str = [htmlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:[str copy]]];
    [_webView loadRequest:request];

}

// UIWebViewDelegate
- (void)webViewDidStartLoad:(UIWebView *)webView {
    _loadedHtml = YES; // 标记开始加载HTML
    [_loadingView startAnimating];
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    _loadedHtml = NO; // 加载HTML失败, 允许重新加载
    [_loadingView stopAnimating];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    if (!webView.isLoading) {
        // 加载完成后回收loading动画
        [_loadingView stopAnimating];
        [_loadingView removeFromSuperview];
        _loadingView = nil;
        
        _loadedHtml     = YES; // 标记已经完成HTML的加载
        _thumbUp.hidden = false;
        _readNum.hidden = false;
        _webView.hidden = NO;
        
        // 获取webView内容实际高度
        float height = [[webView stringByEvaluatingJavaScriptFromString:@"document.documentElement.scrollHeight"] floatValue];
        if ([self.delegate respondsToSelector:@selector(webViewCell:loadedHTMLWithHeight:)]) {
            [self.delegate webViewCell:self loadedHTMLWithHeight:height];
        }
    }
}
@end
