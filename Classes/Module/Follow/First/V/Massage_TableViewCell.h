//
//  Massage_TableViewCell.h
//  Golvon
//
//  Created by 李盼盼 on 16/3/21.
//  Copyright © 2016年 李盼盼. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Massage_TableViewCell : UITableViewCell

@property (strong, nonatomic) UIImageView *image;
@property (strong, nonatomic) UILabel *title;
@property (strong, nonatomic) UILabel *unread;

-(void)relayoutDataWithImage:(NSString *)imageName AndWithTitle:(NSString *)title AndWithUnread:(NSString *)unread;

@end
