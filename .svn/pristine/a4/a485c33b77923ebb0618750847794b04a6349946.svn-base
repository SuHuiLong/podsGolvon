//
//  InterviewWebviewCell.h
//  podsGolvon
//
//  Created by apple on 2016/12/28.
//  Copyright © 2016年 suhuilong. All rights reserved.
//

#import <UIKit/UIKit.h>

@class InterviewWebviewCell;
@protocol InterviewWebviewDelegate <NSObject>

- (void)webViewCell:(InterviewWebviewCell *)webViewCell loadedHTMLWithHeight:(CGFloat)contentHeight;


@end


@interface InterviewWebviewCell : UITableViewCell

@property (nonatomic, assign) id<InterviewWebviewDelegate> delegate;

@property (nonatomic, copy) NSString *htmlString;

@property (nonatomic, strong) UILabel   *thumbUp;
@property (nonatomic, strong) UILabel   *readNum;
@end
