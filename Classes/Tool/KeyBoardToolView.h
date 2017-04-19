//
//  KeyBoardToolView.h
//  podsGolvon
//
//  Created by 李盼盼 on 16/9/1.
//  Copyright © 2016年 suhuilong. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol keyBoardToolViewDelegate <NSObject>

- (void)keyBoardToolShouldEndEditing:(UITextView *)textView;
- (void)keyBoardTooltextView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text;
-(void)keyBoardTooltextViewDidChange:(UITextView *)textView;
@end

@interface KeyBoardToolView : UIView

/***  输入框*/
@property (strong, nonatomic) UITextView               *textView;
/***  表情按钮*/
@property (strong, nonatomic) UIButton    *expressionBtn;
/***  代理*/
@property (strong, nonatomic) id<keyBoardToolViewDelegate> delegate;

@end
