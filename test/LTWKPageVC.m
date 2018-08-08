//
//  LTWKPageVC.m
//  test
//
//  Created by letar on 2018/7/31.
//  Copyright © 2018年 letar. All rights reserved.
//

#import "LTWKPageVC.h"
#import "LTGetAuthApi.h"
#import <MJExtension.h>
#import "YHSegmentView.h"
#import "LTDetailsTabController.h"
#import "LTAuthModel.h"
#import "LTGetMcourseSubjectApi.h"
#import "LTSubjectModel.h"
#import "UIColor+YMHex.h"
#import "UIView+HNExp.h"

@interface LTWKPageVC ()



@end

@implementation LTWKPageVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 44)];
    title.text = @"知识微课";
    title.font = [UIFont systemFontOfSize:20.0f];
    title.textAlignment = NSTextAlignmentCenter;
    title.textColor = [UIColor whiteColor];
    self.navigationItem.titleView = title;

    [self getAuthData];
    
}


//初始化学科分栏
- (void)prepareSubSegmentViewWithSubModelArr:(NSArray<LTSubjectModel *> *)subModelArr token:(NSString *)token{
    NSMutableArray *vcArr = [NSMutableArray array];
    NSMutableArray *titleArr = [NSMutableArray array];
    for (NSDictionary *subDict in subModelArr) {
        LTSubjectModel *subModel = [LTSubjectModel mj_objectWithKeyValues:subDict];
        LTDetailsTabController *tabVC = [LTDetailsTabController new];
//        tabVC.title = subModel.name;
        tabVC.token = token;
        tabVC.subjectId = subModel.id;
        [vcArr addObject:tabVC];
        [titleArr addObject:subModel.name];
    }
    
    YHSegmentView *segmentView = [[YHSegmentView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.navigationController.navigationBar.frame), self.view.width, [UIScreen mainScreen].bounds.size.height - CGRectGetMaxY(self.navigationController.navigationBar.frame)) ViewControllersArr:[vcArr copy] TitleArr:titleArr TitleNormalSize:16.0f TitleSelectedSize:16.0f SegmentStyle:YHSegementStyleIndicate ParentViewController:self ReturnIndexBlock:^(NSInteger index) {
    }];
    
     segmentView.yh_titleSelectedColor = [UIColor colorWithHexString:@"#fcb200"];
     segmentView.yh_titleNormalColor = [UIColor colorWithHexString:@"#666666"];
     segmentView.yh_segmentTintColor = [UIColor colorWithHexString:@"#fcb200"];
     [self.view addSubview:segmentView];
}

//知识微课学科列表
- (void)getMcourseSubjecWithToken:(NSString *)token {
    LTGetMcourseSubjectApi *subjectApi = [[LTGetMcourseSubjectApi alloc] initWithToken:token];
    [subjectApi startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        NSMutableArray *subModelArr = [NSMutableArray array];
        for (NSDictionary *subDict in request.responseJSONObject[@"data"]) {
            LTSubjectModel *subModel = [LTSubjectModel mj_objectWithKeyValues:subDict];
            [subModelArr addObject:subModel];
        }
        //初始化学科分栏
        [self prepareSubSegmentViewWithSubModelArr:subModelArr token:token];
        
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        NSLog(@"%@",request.error);
    }];
    
}

// 获取token数据
- (void)getAuthData {
    LTGetAuthApi *authApi = [[LTGetAuthApi alloc] init];
    [authApi startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        LTAuthModel *authModel = [LTAuthModel mj_objectWithKeyValues:request.responseJSONObject];
        [self getMcourseSubjecWithToken:authModel.token];//获取学科列表
        
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        NSLog(@"%@",request.error);
    }];
}


@end
