//
//  FriendsterHeaderView.m
//  podsGolvon
//
//  Created by augbase on 16/9/17.
//  Copyright © 2016年 suhuilong. All rights reserved.
//

#import "FriendsterHeaderView.h"
#import "LikeTableViewCell.h"
#import "UIButton+WebCache.h"
#import "UIView+SDAutoLayout.h"
#import "NewDetailViewController.h"


#import "MSSBrowseDefine.h"



@interface FriendsterHeaderView () <UIViewControllerTransitioningDelegate,UIActionSheetDelegate>


@property (weak, nonatomic) PhotoBrowCollectionView    *collectionView;

@end

static NSString *identifierLike = @"LikeTableViewCell";
@implementation FriendsterHeaderView

-(instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithReuseIdentifier:reuseIdentifier]) {
        self.userInteractionEnabled = YES;
        [self createSubview];
        [self createLikeview];
    }
    return self;
}

-(void)alertSuccessShowView:(NSString *)str{
    
    SucessView *sView = [[SucessView alloc] initWithFrame:CGRectMake(WScale(37.1), HScale(44.7), WScale(26.1), HScale(10.8)) imageImageName: @"成功" descStr: str];
    [self.window addSubview:sView];
    dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0/*延迟执行时间*/ * NSEC_PER_SEC));
    
    dispatch_after(delayTime, dispatch_get_main_queue(), ^{
        [sView removeFromSuperview];
    });
    
}
-(void)createSubview{
    
    
    //分割线
    _line = [[UIView alloc]init];
    _line.frame = CGRectMake(0, 0, ScreenWidth, 5);
    _line.backgroundColor = SeparatorColor;
    [self.contentView addSubview:_line];
    
    _pressView = [[UIView alloc] init];
    _pressView.backgroundColor = ClearColor;
    [self addSubview:_pressView];
    
    UILongPressGestureRecognizer *pressHeader = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(pressHeader:)];
    pressHeader.minimumPressDuration = 0.5f;
    [_pressView addGestureRecognizer:pressHeader];
    
    
    //头像
    _headerIcon = [[UIImageView alloc] init];
    _headerIcon.frame = CGRectMake(kWvertical(15), kHvertical(13), kWvertical(40), kWvertical(40));
    _headerIcon.layer.masksToBounds = YES;
    _headerIcon.layer.cornerRadius = kWvertical(20);
    [self addSubview:_headerIcon];
    
    
    
    //昵称
    _nickname = [[UILabel alloc]init];
    _nickname.frame = CGRectMake(_headerIcon.right + kWvertical(10), kHvertical(15), kWvertical(100), kHvertical(20));
    if (Device >= 9.0) {
        _nickname.font = [UIFont fontWithName:Light size:kHorizontal(15)];
    }else{
        _nickname.font = [UIFont systemFontOfSize:kHorizontal(15)];
    }
    [self.contentView addSubview:_nickname];
    
    //发布时间
    _timeLabel = [[UILabel alloc]init];
    
    _timeLabel.frame = CGRectMake(_nickname.left, kHvertical(35), 200, kHvertical(14));
    if (Device >= 9.0) {
        _timeLabel.font = [UIFont fontWithName:Light size:kHorizontal(12)];
    }else{
        _timeLabel.font = [UIFont systemFontOfSize:kHorizontal(12)];
    }
    _timeLabel.textColor = GPColor(135, 135, 135);
    [self.contentView addSubview:_timeLabel];
    
    
    //个人动态删除
    _deleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _deleBtn.frame = CGRectMake(ScreenWidth - kWvertical(40), kHvertical(0), kWvertical(40), kWvertical(40));
    [_deleBtn setImage:[UIImage imageNamed:@"动态删除"] forState:UIControlStateNormal];
    [_deleBtn addTarget:self action:@selector(clickDelet) forControlEvents:UIControlEventTouchUpInside];
    _deleBtn.hidden = YES;
    [self addSubview:_deleBtn];
    
    //消息详情
    _followBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _followBtn.frame = CGRectMake(ScreenWidth - WScale(23), HScale(2) , WScale(22), HScale(3.7));
    [_followBtn setImage:[UIImage imageNamed:@"动态详情关注"] forState:UIControlStateNormal];
    [_followBtn setImage:[UIImage imageNamed:@"动态详情已关注"] forState:UIControlStateSelected];
    [_followBtn addTarget:self action:@selector(setFollow) forControlEvents:UIControlEventTouchUpInside];
    _followBtn.hidden = YES;
    [self addSubview:_followBtn];
    
    
    //头像区域跳转
    _turnBtn = [UIButton  buttonWithType:UIButtonTypeCustom];
    _turnBtn.frame = CGRectMake(0, 0, kWvertical(230), kHvertical(50));
    [_turnBtn addTarget:self action:@selector(clickHeaderIcon) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_turnBtn];
    
    UILongPressGestureRecognizer *longpress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longpressHeaderImage:)];
    longpress.minimumPressDuration = 0.5f;
    [_turnBtn addGestureRecognizer:longpress];
    
    
    _Vicon = [[UIImageView alloc]init];
    _Vicon.frame = CGRectMake(kWvertical(45),kHvertical(42), kWvertical(12), kWvertical(12));
    _Vicon.image = [UIImage imageNamed:@"专访小v"];
    [_turnBtn addSubview:_Vicon];
    
    
    //发布内容
    _content = [[UILabel alloc]init];
    _content.numberOfLines = 0;
    _content.font = [UIFont systemFontOfSize:kHorizontal(14)];
    [self.contentView addSubview:_content];
    
    //发布的照片
    PhotoBrowCollectionView *collectionView = [[PhotoBrowCollectionView alloc] init];
    [self.contentView addSubview:collectionView];
    self.collectionView = collectionView;
    
    
    //定位
    _addressImage = [[UIImageView alloc]init];
    _addressLabel.hidden = YES;
    _addressImage.image = [UIImage imageNamed:@"动态定位"];
    [self.contentView addSubview:_addressImage];
    
    _addressLabel = [[UILabel alloc]init];
    _addressLabel.hidden = YES;
    [self.contentView addSubview:_addressLabel];
    
    _commentBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_commentBtn addTarget:self action:@selector(clickComment) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_commentBtn];
    
    _likeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_likeBtn setImage:[UIImage imageNamed:@"喜欢_默认（首页）"] forState:UIControlStateNormal];
    [_likeBtn setImage:[UIImage imageNamed:@"喜欢_点击（首页）"] forState:UIControlStateSelected];
    [_likeBtn addTarget:self action:@selector(clickToLike) forControlEvents:UIControlEventTouchUpInside];
    
    [self addSubview:_likeBtn];
    
}
-(void)createLikeview{
    //点赞人
    UICollectionViewFlowLayout *flowlayout = [[UICollectionViewFlowLayout alloc]init];
    flowlayout.itemSize = CGSizeMake(kWvertical(26), kWvertical(26));
    flowlayout.minimumInteritemSpacing = kWvertical(4);
    
    _likeView = [[UICollectionView alloc]initWithFrame:CGRectMake(kWvertical(15), kHvertical(0), ScreenWidth-kWvertical(30), kHvertical(10)) collectionViewLayout:flowlayout];
    _likeView.contentInset = UIEdgeInsetsMake(kHvertical(10), kWvertical(7), kHvertical(10), kWvertical(7));
    _likeView.backgroundColor = GPColor(243, 245, 249);
    _likeView.delegate = self;
    _likeView.dataSource = self;
    _likeView.userInteractionEnabled = YES;
    _likeView.scrollEnabled = NO;
    [_likeView registerClass:[LikeTableViewCell class] forCellWithReuseIdentifier:identifierLike];
    [self addSubview:_likeView];
    
}

-(void)setDataWithModel:(FriendsterModel *)model{
    self.model = model;
    
    [_headerIcon sd_setImageWithURL:[NSURL URLWithString:model.avator] placeholderImage:[UIImage imageNamed:@"照片加载图片"]];
    
    if ([model.interview isEqualToString:@"0"]) {
        _Vicon.hidden = YES;
        
    }else{
        _Vicon.hidden = NO;
    }
    _nickname.text = model.nickname;
    [_nickname sizeToFit];
    //发布的时间
    _timeLabel.text = model.pubtime;
    [_timeLabel sizeToFit];
    
    
    //发布的内容
    NSString *conStr = [self.model.content stringByRemovingPercentEncoding];
    contentSize = [conStr boundingRectWithSize:CGSizeMake( ScreenWidth - kWvertical(30), MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:kHorizontal(14)]} context:nil].size;
    _content.text = conStr;
    _content.frame = CGRectMake(kWvertical(15), kHvertical(57),  ScreenWidth - kWvertical(30),contentSize.height);
    
    
    if ([model.position isEqualToString:@"不显示地点"]) {
        _addressImage.hidden = YES;
        _addressLabel.hidden = YES;
    }else{
        
        _addressImage.hidden = NO;
        _addressLabel.hidden = NO;
        _addressLabel.text = model.position;
        _addressLabel.font = [UIFont systemFontOfSize:kHorizontal(13)];
    }
    
    //点赞和评论
    [_commentBtn setImage:[UIImage imageNamed:@"首页评论"] forState:UIControlStateNormal];
    [_commentBtn setTitle:[NSString stringWithFormat:@"%@",model.commetum] forState:UIControlStateNormal];
    [_commentBtn setTitleColor:GPColor(135, 135, 135) forState:UIControlStateNormal];
    _commentBtn.titleEdgeInsets = UIEdgeInsetsMake(0, kWvertical(5), 0, 0);
    _commentBtn.titleLabel.font = [UIFont systemFontOfSize:kHorizontal(12)];
    
    
    _likeBtn.selected = model.isclicked;
    _followBtn.selected = model.isfocused;
    
    [_likeBtn setTitle:[NSString stringWithFormat:@"%@",model.clicknum] forState:UIControlStateNormal];
    
    _likeBtn.titleEdgeInsets = UIEdgeInsetsMake(0, kWvertical(5), 0, 0);
    [_likeBtn setTitleColor:GPColor(135, 135, 135) forState:UIControlStateNormal];
    _likeBtn.titleLabel.font = [UIFont systemFontOfSize:kHorizontal(12)];
    
    
}

-(void)setLayoutModel:(PhotoBrowerLayoutModel *)layoutModel{
    
    [self.collectionView setLayoutModel:layoutModel];
    self.collectionView.frame = CGRectMake(0, kHvertical(57) + contentSize.height, [layoutModel contentWidth], [layoutModel contentHeight]);
    
    //长按动态区域
    _pressView.frame = CGRectMake(kWvertical(60), 0, ScreenWidth - kWvertical(60), kHvertical(57) + _content.height);
    //地址评论点赞的高度
    _addressImage.frame = CGRectMake(_headerIcon.left, _collectionView.bottom+kHvertical(13), kWvertical(13), kHvertical(15));
    _addressLabel.frame = CGRectMake(_addressImage.right+kWvertical(5), _collectionView.bottom+kHvertical(13), 100, kHvertical(16));
    [_addressLabel sizeToFit];
    _commentBtn.frame = CGRectMake(ScreenWidth - kWvertical(50), _collectionView.bottom, kWvertical(50), kHvertical(41));
    _likeBtn.frame = CGRectMake(_commentBtn.left-kWvertical(50), _collectionView.bottom, kWvertical(50), kHvertical(41));
    
    //点赞信息的高度
    CGFloat Height = ((_model.clicks.count%10!=0)?(_model.clicks.count/10+1):(_model.clicks.count/10))*(kWvertical(43));
    _likeView.frame = CGRectMake(kWvertical(15), _commentBtn.bottom, ScreenWidth-kWvertical(30), Height);
    
}

-(UIViewController *)viewController:(UIView *)view{
    UIResponder *responder = view;
    while ((responder = [responder nextResponder]))
        if ([responder isKindOfClass:[UIViewController class]])
            return (UIViewController *)responder;
    return nil;
}
#pragma mark ---- collectionView代理
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.model.clicks.count;
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    LikeTableViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifierLike forIndexPath:indexPath];
    if (collectionView == _likeView) {
        
        [cell relayoutWithModel:self.model.clicks[indexPath.row]];
        __weak typeof(self) weakself = self;
        cell.pressHeaderBlock = ^(LikeUsersModel *model){
            [weakself longpressLikeHeader:model];
        };
    }
    
    return cell;
}

//长按评论
-(void)longpressLikeHeader:(LikeUsersModel *)model{
    
    [self longpressGestureRecognizer];
}

-(void)longpressGestureRecognizer{
    
    _longpressActionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"举报", nil];
    _longpressActionSheet.actionSheetStyle = UIActionSheetStyleAutomatic;
    [_longpressActionSheet showFromRect:CGRectMake(0, ScreenHeight, ScreenWidth, ScreenHeight) inView:self.window animated:YES];
}
-(void)createReportView{
    _reportActionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"色情信息",@"广告欺诈",@"不当发言",@"虚假信息", nil];
    
    _reportActionSheet.actionSheetStyle = UIActionSheetStyleAutomatic;
    [_reportActionSheet showFromRect:CGRectMake(0, ScreenHeight, ScreenWidth, ScreenHeight) inView:self.window animated:YES];
}
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (actionSheet == _longpressActionSheet) {
        switch (buttonIndex) {
                
            case 0:
                [self createReportView];
                break;
                
            default:
                break;
        }
    }else{
        switch (buttonIndex) {
            case 0:
                
                [self alertSuccessShowView:@"提交成功"];
                break;
                
            case 1:
                
                [self alertSuccessShowView:@"提交成功"];
                break;
            case 2:
                
                [self alertSuccessShowView:@"提交成功"];
                break;
            case 3:
                
                [self alertSuccessShowView:@"提交成功"];
                break;
                
            default:
                break;
        }
    }
    
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    NewDetailViewController *VC = [[NewDetailViewController alloc] init];
    LikeUsersModel *model = self.model.clicks[indexPath.row];
    VC.nameID = model.cuid;
    VC.hidesBottomBarWhenPushed = YES;
    [VC setBlock:^(BOOL isback) {
        
    }];
    currentViewController = [self viewController:self];
    [currentViewController.navigationController pushViewController:VC animated:YES];
}
#pragma mark ---- 点击事件
//评论
-(void)clickComment{
    
    if (self.commentBlock) {
        self.commentBlock(self.model);
    }
    
}
//点赞
-(void)clickToLike{
    
    _likeBtn.selected = !_likeBtn.selected;
    
    if (self.likeBlock) {
        self.likeBlock(self.model);
    }
}
//删除
-(void)clickDelet{
    if (self.deleBlock) {
        self.deleBlock(self.model);
    }
}
-(void)setFollow{
    
    _followBtn.selected = !_followBtn.selected;
    if (self.followBlock) {
        self.followBlock(self.model);
    }
}
//跳转
-(void)clickHeaderIcon{
    if (self.clickHeaderIconBlock) {
        self.clickHeaderIconBlock(self.model);
    }
}
//长安举报
-(void)longpressHeaderImage:(UILongPressGestureRecognizer *)longpress{
    if (longpress.state == UIGestureRecognizerStateBegan) {
        
        if (self.longpressHeaderImageBlock) {
            self.longpressHeaderImageBlock(self.model);
        }
    }
}
-(void)pressHeader:(UILongPressGestureRecognizer *)longpress{
    if (longpress.state == UIGestureRecognizerStateBegan) {
        if (self.longpressHeader) {
            self.longpressHeader(self.model);
        }
    }
}
//点击照片放大
- (void)tapImageView:(UITapGestureRecognizer *)tap
{
    
    
    
    UIView *imageView = tap.view;
    
    NSInteger currentImageIndex = imageView.tag-1;
    
    // 加载网络图片
    NSMutableArray *browseItemArray = [[NSMutableArray alloc]init];
    int i = 0;
    
    for(i = 0;i < [_imageViewsArray count];i++)
    {
        UIImageView *imageView = [self viewWithTag:i +1];
        MSSBrowseModel *browseItem = [[MSSBrowseModel alloc]init];
        browseItem.bigImageUrl = _imageUrlArray[i];// 加载网络图片大图地址
        browseItem.smallImageView = imageView;// 小图
        [browseItemArray addObject:browseItem];
    }
    MSSBrowseNetworkViewController *bvc = [[MSSBrowseNetworkViewController alloc]initWithBrowseItemArray:browseItemArray currentIndex:currentImageIndex];
    
    [bvc showBrowseViewController];
    

    
    
    
    
}

@end
