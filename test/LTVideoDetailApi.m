//
//  LTVideoDetailApi.m
//  test
//
//  Created by letar on 2018/8/1.
//  Copyright © 2018年 letar. All rights reserved.
//

#import "LTVideoDetailApi.h"
#import "NSString+LTString.h"

#define SECRETID @"c67e49e5b0c4610ed27f"

@implementation LTVideoDetailApi {
    NSString *_token;
    NSString *_lessonId;
}



- (id)initWithToken:(NSString *)token lessonId:(NSString *)lessonId {
    self = [super init];
    if (self) {
        _token = token;
        _lessonId = lessonId;
    }
    return self;
}

- (NSString *)requestUrl {
    return @"MicroCourse/getMcourseLessonVod";
}

- (id)requestArgument {
    return @{
             @"lessonId": _lessonId,
             @"token":_token,
             @"secretId": SECRETID,
             @"timestamp":[NSString getNowTimeTimestamp],
             };
}

@end
