//
//  SimpleInterest.m
//  Golvon
//
//  Created by 李盼盼 on 16/8/11.
//  Copyright © 2016年 苏辉龙. All rights reserved.
//

#import "SimpleInterest.h"

static SimpleInterest *manger = nil;
@implementation SimpleInterest

+(SimpleInterest *)sharedSingle{
    @synchronized (self) {
        if (!manger) {
            manger = [[SimpleInterest alloc]init];
            manger.supportNameID = [[NSMutableString alloc]initWithString:@"0"];
        }
    }
    return manger;
}


@end
