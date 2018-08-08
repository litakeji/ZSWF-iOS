//
//  LTVideoVC.m
//  test
//
//  Created by letar on 2018/8/2.
//  Copyright © 2018年 letar. All rights reserved.
//

#import "LTVideoVC.h"
#import <WMPlayer.h>
#import <Masonry.h>
#import "LTLessonVodModel.h"
#import "LTVideoDetailApi.h"
#import <MJExtension.h>

@interface LTVideoVC ()<WMPlayerDelegate>
@property(nonatomic,strong)WMPlayer *wmPlayer;
@end

@implementation LTVideoVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    //获取设备旋转方向的通知,即使关闭了自动旋转,一样可以监测到设备的旋转方向
    [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
    //旋转屏幕通知
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(onDeviceOrientationChange:)
                                                 name:UIDeviceOrientationDidChangeNotification
                                               object:nil];
    
    
    [self loadVideoData];
}



- (void)loadVideoData{
    LTVideoDetailApi *videoDetailApi = [[LTVideoDetailApi alloc] initWithToken:self.token lessonId:self.lessonId];
    [videoDetailApi startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        LTLessonVodModel *vodModel = [LTLessonVodModel mj_objectWithKeyValues:request.responseJSONObject];
        [self wmPlayerWithURLStr:vodModel.src];
        [self toOrientation:UIInterfaceOrientationLandscapeRight];
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        NSLog(@"%@",request);
    }];
}

- (void)wmPlayerWithURLStr:(NSString *)URLStr {
    WMPlayerModel *playerModel = [WMPlayerModel new];
    playerModel.title = self.subName;
    playerModel.videoURL = [NSURL URLWithString:URLStr];
    WMPlayer * wmPlayer = [[WMPlayer alloc]initPlayerModel:playerModel];
    wmPlayer.delegate = self;
    wmPlayer.backBtnStyle = BackBtnStyleNone;
    self.wmPlayer = wmPlayer;
    [self.view addSubview:wmPlayer];
//    wmPlayer.frame = CGRectMake(200, 200, 200, 200);
    [wmPlayer mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.wmPlayer.superview).offset([WMPlayer IsiPhoneX]?88:64);
        make.leading.trailing.equalTo(self.wmPlayer.superview);
        make.height.equalTo(@(([UIScreen mainScreen].bounds.size.width)*9/16.0));
        make.width.equalTo(@([UIScreen mainScreen].bounds.size.width));
    }];
    
    [wmPlayer play];
}

///播放器事件
-(void)wmplayer:(WMPlayer *)wmplayer clickedCloseButton:(UIButton *)closeBtn{
    NSLog(@"didClickedCloseButton");
    if (wmplayer.isFullscreen) {
        [self.navigationController popViewControllerAnimated:YES];
        [self releaseWMPlayer];
        [self toOrientation:UIInterfaceOrientationPortrait];
    }else{
        NSLog(@"bbbb");
        [self.navigationController popViewControllerAnimated:NO];
        [self releaseWMPlayer];
//        self.table.hidden =NO;
    }
}
-(void)wmplayer:(WMPlayer *)wmplayer clickedFullScreenButton:(UIButton *)fullScreenBtn{
    if (self.wmPlayer.isFullscreen) {//全屏
        NSLog(@"点击全屏");
        [self toOrientation:UIInterfaceOrientationPortrait];
    }else{//非全屏
        NSLog(@"点击1111全屏");
        [self toOrientation:UIInterfaceOrientationLandscapeRight];
    }
}
//操作栏隐藏或者显示都会调用此方法
-(void)wmplayer:(WMPlayer *)wmplayer isHiddenTopAndBottomView:(BOOL)isHidden{
    NSLog(@"操作栏隐藏或者显示都会调用此方法");
    [self setNeedsStatusBarAppearanceUpdate];
}

//点击进入,退出全屏,或者监测到屏幕旋转去调用的方法
-(void)toOrientation:(UIInterfaceOrientation)orientation{
    //获取到当前状态条的方向
    UIInterfaceOrientation currentOrientation = [UIApplication sharedApplication].statusBarOrientation;
    [self.wmPlayer removeFromSuperview];
    //根据要旋转的方向,使用Masonry重新修改限制
    if (orientation ==UIInterfaceOrientationPortrait) {
        [self.view addSubview:self.wmPlayer];
        self.wmPlayer.isFullscreen = NO;
        self.wmPlayer.backBtnStyle = BackBtnStyleNone;
        
        [self.wmPlayer mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.wmPlayer.superview).offset([WMPlayer IsiPhoneX]?88:64);
            make.leading.trailing.equalTo(self.wmPlayer.superview);
            make.height.equalTo(@(([UIScreen mainScreen].bounds.size.width)*9/16.0));
            make.width.equalTo(@([UIScreen mainScreen].bounds.size.width));
        }];
        
    }else{
        [[UIApplication sharedApplication].keyWindow addSubview:self.wmPlayer];
        self.wmPlayer.isFullscreen = YES;
        self.wmPlayer.backBtnStyle = BackBtnStylePop;
        
        if(currentOrientation ==UIInterfaceOrientationPortrait){
            if (self.wmPlayer.playerModel.verticalVideo) {
                [self.wmPlayer mas_remakeConstraints:^(MASConstraintMaker *make) {
                    make.edges.equalTo(self.wmPlayer.superview);
                }];
            }else{
                [self.wmPlayer mas_remakeConstraints:^(MASConstraintMaker *make) {
                    make.width.equalTo(@([UIScreen mainScreen].bounds.size.height));
                    make.height.equalTo(@([UIScreen mainScreen].bounds.size.width));
                    make.center.equalTo(self.wmPlayer.superview);
                }];
            }
            
        }else{
            if (self.wmPlayer.playerModel.verticalVideo) {
                [self.wmPlayer mas_remakeConstraints:^(MASConstraintMaker *make) {
                    make.edges.equalTo(self.wmPlayer.superview);
                }];
            }else{
                [self.wmPlayer mas_remakeConstraints:^(MASConstraintMaker *make) {
                    make.width.equalTo(@([UIScreen mainScreen].bounds.size.width));
                    make.height.equalTo(@([UIScreen mainScreen].bounds.size.height));
                    make.center.equalTo(self.wmPlayer.superview);
                }];
            }
            
        }
    }
    //iOS6.0之后,设置状态条的方法能使用的前提是shouldAutorotate为NO,也就是说这个视图控制器内,旋转要关掉;
    //也就是说在实现这个方法的时候-(BOOL)shouldAutorotate返回值要为NO
    if (self.wmPlayer.playerModel.verticalVideo) {
        [self setNeedsStatusBarAppearanceUpdate];
    }else{
        [[UIApplication sharedApplication] setStatusBarOrientation:orientation animated:NO];
        //更改了状态条的方向,但是设备方向UIInterfaceOrientation还是正方向的,这就要设置给你播放视频的视图的方向设置旋转
        //给你的播放视频的view视图设置旋转
        [UIView animateWithDuration:0.4 animations:^{
            self.wmPlayer.transform = CGAffineTransformIdentity;
            self.wmPlayer.transform = [WMPlayer getCurrentDeviceOrientation];
            [self.wmPlayer layoutIfNeeded];
            [self setNeedsStatusBarAppearanceUpdate];
        }];
    }
}



-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}
-(BOOL)prefersStatusBarHidden{
    if (self.wmPlayer.isFullscreen) {
        return self.wmPlayer.prefersStatusBarHidden;
    }
    return NO;
}
/**
 *  旋转屏幕通知
 */
- (void)onDeviceOrientationChange:(NSNotification *)notification{
    if (self.wmPlayer==nil){
        return;
    }
    if (self.wmPlayer.playerModel.verticalVideo) {
        return;
    }
    if (self.wmPlayer.isLockScreen){
        return;
    }
    UIDeviceOrientation orientation = [UIDevice currentDevice].orientation;
    UIInterfaceOrientation interfaceOrientation = (UIInterfaceOrientation)orientation;
    switch (interfaceOrientation) {
            case UIInterfaceOrientationPortraitUpsideDown:{
                NSLog(@"第3个旋转方向---电池栏在下");
            }
            break;
            case UIInterfaceOrientationPortrait:{
                NSLog(@"第0个旋转方向---电池栏在上");
                [self toOrientation:UIInterfaceOrientationPortrait];
            }
            break;
            case UIInterfaceOrientationLandscapeLeft:{
                NSLog(@"第2个旋转方向---电池栏在左");
                [self toOrientation:UIInterfaceOrientationLandscapeLeft];
            }
            break;
            case UIInterfaceOrientationLandscapeRight:{
                NSLog(@"第1个旋转方向---电池栏在右");
                [self toOrientation:UIInterfaceOrientationLandscapeRight];
            }
            break;
        default:
            break;
    }
}



/**
 *  释放WMPlayer
 */
-(void)releaseWMPlayer {
    [self.wmPlayer pause];
    [self.wmPlayer removeFromSuperview];
    self.wmPlayer = nil;
}
-(void)dealloc {
    NSLog(@"%@ dealloc",[self class]);
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
