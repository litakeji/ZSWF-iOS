//
//  LTGetMcourseLessonApi.m
//  test
//
//  Created by letar on 2018/8/6.
//  Copyright © 2018年 letar. All rights reserved.
//

#import "LTGetMcourseLessonApi.h"
#import "NSString+LTString.h"

#define SECRETID @"c67e49e5b0c4610ed27f"

@implementation LTGetMcourseLessonApi {
    NSString *_token;
    NSString *_subjectId;
    NSUInteger _page;
}


- (id)initWithToken:(NSString *)token subjectId:(NSString *)subjectId page:(NSUInteger)page{
    self = [super init];
    if (self) {
        _token = token;
        _subjectId = subjectId;
        _page = page;
    }
    return self;
}

- (NSString *)requestUrl {
    return @"MicroCourse/getMcourseLesson";
}

- (id)requestArgument {
    return @{
             //             @"n": @(_lessonCount),
             @"subjectId": _subjectId,
             @"secretId": SECRETID,
             @"timestamp":[NSString getNowTimeTimestamp],
             @"token":_token,
             @"page":@(_page),
             };
}

@end
