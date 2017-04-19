//
//  HomePageViewController.h
//  podsGolvon
//
//  Created by 李盼盼 on 16/8/26.
//  Copyright © 2016年 suhuilong. All rights reserved.
//

#import "BaseViewController.h"
#import "NewAlertView.h"
#import "SeachViewController.h"
#import "ScoreCardViewController.h"
#import "CollectionViewFlowLayout.h"
#import "NewDetailViewController.h"
#import "FriendsterModel.h"
#import "DynamicMessageModel.h"
#import "LikeUsersModel.h"
#import "PictureModel.h"
#import "SupportModel.h"
#import "RecommendModel.h"
#import "HomePageCollectionViewCell.h"
#import "FriendsterTableViewCell.h"
#import "LikeTableViewCell.h"
#import "Masonry.h"
#import "XZMRefresh.h"
#import "UIButton+WebCache.h"
#import "DownLoadDataSource.h"
#import "DDPageControl.h"
#import "NSObject+YYModel.h"
#import <BaiduMapAPI_Map/BMKMapComponent.h>
#import <BaiduMapAPI_Location/BMKLocationComponent.h>
#import "PublishPhotoViewController.h"
#import "Follow_ViewController.h"
#import "ReviewPhotosViewController.h"
#import "EmojiKeybordView.h"
#import "SDPhotoBrowser.h"
#import "CoreDataManager.h"
#import "ViewHistoryData.h"
#import "JPUSHService.h"
#import "UIScrollView+MJRefresh.h"


#import "FindViewController.h"
#import "SignaturesViewController.h"
#import "ConsummateViewController.h"
#import "RegistViewController.h"
#import "SetNicknameViewController.h"
@interface HomePageViewController : BaseViewController

/***  人气数据*/
@property (strong, nonatomic) NSMutableArray    *hotDataArr;

/***  controllerID*/
@property (assign, nonatomic) int    controllID;

@property (strong, nonatomic) NSIndexPath      *currentInadexpath;
@property (assign, nonatomic) CGFloat offSetY;
@property (assign, nonatomic) CGRect  headerRect;
@property (assign, nonatomic) CGFloat cellHeght;
@property (assign, nonatomic) int     row;
@property (assign, nonatomic) int     section;
@property (assign, nonatomic) NSInteger     operateIndex;
@property (assign, nonatomic) NSInteger     sectionIndex;
/**
 *  第一次加载评论后刷新数据
 */
@property (assign, nonatomic) int    oneDid;

//@property (copy, nonatomic) NSString *controller;
-(void)startHeaderRefresh;
@end
