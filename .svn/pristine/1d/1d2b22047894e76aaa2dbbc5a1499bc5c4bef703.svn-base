//
//  SignaturesViewController.h
//  podsGolvon
//
//  Created by 李盼盼 on 16/11/2.
//  Copyright © 2016年 suhuilong. All rights reserved.
//

#import <UIKit/UIKit.h>


@class SignViewController;
@protocol signaturesDelegate <NSObject>

-(void)signaturesSendNameid:(NSString *)nameID;

@end

@interface SignaturesViewController : UIViewController

@property (copy, nonatomic) NSString    *signatureStr;

@property (copy, nonatomic) NSString    *labelStr;

@property (copy, nonatomic) NSString    *name_id;

@property (weak, nonatomic) id<signaturesDelegate> delegate;
@end
