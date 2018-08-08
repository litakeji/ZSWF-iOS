//
//  YHDetailsTabController.m
//  YHSegmentViewDemo
//
//  Created by letar on 2018/8/2.
//  Copyright © 2018年 letar. All rights reserved.
//

#define randomColor [UIColor colorWithRed:arc4random_uniform(256)/255.0 green:arc4random_uniform(256)/255.0 blue:arc4random_uniform(256)/255.0 alpha:1.0]

#import "LTDetailsTabController.h"
#import "LTGetMcourseLessonApi.h"
#import <MJExtension.h>
#import "LTLessonModel.h"
#import "LTVideoVC.h"
#import <MJRefresh.h>


@interface LTDetailsTabController ()

@property(nonatomic, strong) NSMutableArray *wkNameArr;
@property(nonatomic, strong) NSMutableArray *videoIdArr;
@property(nonatomic, strong) NSMutableArray *videoSrcArr;
@property(nonatomic, assign) NSUInteger page;


@end

@implementation LTDetailsTabController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.page = 1;
    [self loadLessonData];
    self.tableView.separatorInset = UIEdgeInsetsMake(0, 10, 0, 10);
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    });
}

//上拉加载更多数据
- (void)loadMoreData {
    self.page ++;
    [self loadLessonData];
}

//学科列表数据
- (void)loadLessonData {
    LTGetMcourseLessonApi *listApi = [[LTGetMcourseLessonApi alloc] initWithToken:self.token subjectId:self.subjectId page:self.page];
    [listApi startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        for (NSDictionary *lessonDict in request.responseJSONObject[@"data"]) {
            LTLessonModel *lessonModel = [LTLessonModel mj_objectWithKeyValues:lessonDict];
            [self.wkNameArr addObject:lessonModel.name];
            [self.videoIdArr addObject:lessonModel.id];
            [self.tableView reloadData];
            
            if(self.wkNameArr.count == [request.responseJSONObject[@"count"] unsignedIntegerValue]) {
                NSLog(@"加载完毕");
                [self.tableView.mj_footer endRefreshingWithNoMoreData];
            }else {
                [self.tableView.mj_footer endRefreshing];
            }
        }
        
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        NSLog(@"%@",request);
    }];
}


#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.wkNameArr.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellID = @"reuseIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    cell.textLabel.text = self.wkNameArr[indexPath.row];
    cell.textLabel.font = [UIFont systemFontOfSize:14];
    cell.imageView.image = [UIImage imageNamed:@"common_btn_audio"];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    LTVideoVC *videoVC = [[LTVideoVC alloc] init];
    videoVC.lessonId = self.videoIdArr[indexPath.row];
    videoVC.token = self.token;
    videoVC.subName = self.wkNameArr[indexPath.row];
    
    [self.navigationController pushViewController:videoVC animated:NO];
}




#pragma mark - 懒加载
- (NSMutableArray *)wkNameArr {
    if (!_wkNameArr) {
        _wkNameArr = [NSMutableArray array];
    }
    return _wkNameArr;
}

- (NSMutableArray *)videoIdArr {
    if (!_videoIdArr) {
        _videoIdArr = [NSMutableArray array];
    }
    return _videoIdArr;
}

- (NSMutableArray *)videoSrcArr {
    if (!_videoSrcArr) {
        _videoSrcArr = [NSMutableArray array];
    }
    return _videoSrcArr;
}

@end
