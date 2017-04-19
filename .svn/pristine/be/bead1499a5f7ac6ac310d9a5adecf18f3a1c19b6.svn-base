//
//  InterviewDetileViewController.h
//  podsGolvon
//
//  Created by apple on 2016/12/28.
//  Copyright © 2016年 suhuilong. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^VisionBlock) (BOOL isView);

@class InterviewViewController;
@protocol LikeDelegate <NSObject>

-(void)likeBtnSelected:(BOOL)isSelected withLikeNum:(NSString*)likenum;

@end

@interface InterviewDetileViewController : UIViewController
@property (copy, nonatomic) NSString *htmlStr;
@property (copy, nonatomic) NSString *addTimeStr;
@property (copy, nonatomic) NSString *readStr;
@property (copy, nonatomic) NSString *likeStr;
@property (copy, nonatomic) NSString *titleStr;
@property (copy, nonatomic) NSString *ID;
@property (copy, nonatomic) NSString *type;
@property (copy, nonatomic) NSString *maskPic;
@property (copy, nonatomic) NSString *name_id;
@property (assign, nonatomic) BOOL isLike;
@property (assign, nonatomic) BOOL isFollow;

@property (strong, nonatomic) VisionBlock    block;

@property (weak, nonatomic) id<LikeDelegate> likeDelegate;

-(void)setBlock:(VisionBlock)block;

@end
