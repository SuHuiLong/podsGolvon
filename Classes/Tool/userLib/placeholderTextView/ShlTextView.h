//
//  ShlTextView.h
//  podsGolvon
//
//  Created by suhuilong on 16/8/29.
//  Copyright © 2016年 suhuilong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShlTextView : UITextView

@property(nonatomic,copy)UILabel  *placeLabel;

@property(nonatomic,copy)NSString *placeStr;


-(void)setPlaceLableFrame:(CGRect)frame;

-(void)textViewDidChange:(NSString *)str;
@end
