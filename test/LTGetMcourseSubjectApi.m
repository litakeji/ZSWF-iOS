//
//  LTGetMcourseSubjectApi.m
//  test
//
//  Created by letar on 2018/8/3.
//  Copyright © 2018年 letar. All rights reserved.
//

#import "LTGetMcourseSubjectApi.h"
#import "NSString+LTString.h"

#define SECRETID @"c67e49e5b0c4610ed27f"


@implementation LTGetMcourseSubjectApi {
    NSString *_token;
}


- (id)initWithToken:(NSString *)token {
    self = [super init];
    if (self) {
        _token = token;
    }
    return self;
}

- (NSString *)requestUrl {
    return @"MicroCourse/getMcourseSubject";
}

- (id)requestArgument {
    return @{
             @"secretId": SECRETID,
             @"timestamp":[NSString getNowTimeTimestamp],
             @"token":_token,
             };
}



@end
