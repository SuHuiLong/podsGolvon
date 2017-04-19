//
//  ActivityFooterTableViewCell.h
//  podsGolvon
//
//  Created by apple on 2016/12/26.
//  Copyright © 2016年 suhuilong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomeLabel.h"

@class ActivityFooterTableViewCell;
@protocol ActivityDelegate <NSObject>

- (void)webViewCell:(ActivityFooterTableViewCell *)webViewCell loadedHtmlWithHeight:(CGFloat)contentHeight;


@end

@interface ActivityFooterTableViewCell : UITableViewCell

@property (nonatomic, assign) id<ActivityDelegate> htmlDelegate;
@property (copy, nonatomic) NSString *htmlString;

@end
