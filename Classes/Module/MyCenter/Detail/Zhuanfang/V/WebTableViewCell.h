//
//  WebTableViewCell.h
//  ZhuanFang
//
//  Created by 李盼盼 on 16/4/6.
//  Copyright © 2016年 李盼盼. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WebTableViewCell;

@protocol WebViewCellDelegate <NSObject>

@required
/*!
 *  @author Steven
 *  @brief webView加载完成内容
 *  @param contentCell   当前cell
 *  @param contentHeight webView内容高度 (用于刷新cell高度)
 */
- (void)webViewCell:(WebTableViewCell *)webViewCell loadedHTMLWithHeight:(CGFloat)contentHeight;

@end

@interface WebTableViewCell : UITableViewCell

@property (nonatomic, assign) id<WebViewCellDelegate> delegate;
@property (nonatomic, copy) NSString *htmlString;

@end
