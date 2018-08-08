//
//  LTGetMcourseLessonApi.h
//  test
//
//  Created by letar on 2018/8/6.
//  Copyright © 2018年 letar. All rights reserved.
//

#import "YTKRequest.h"
//获取知识微课学科列表
@interface LTGetMcourseLessonApi : YTKRequest

- (id)initWithToken:(NSString *)token subjectId:(NSString *)subjectId page:(NSUInteger)page;

@end
