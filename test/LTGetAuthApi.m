//
//  LTGetAuthApi.m
//  test
//
//  Created by letar on 2018/8/3.
//  Copyright © 2018年 letar. All rights reserved.
//

#import "LTGetAuthApi.h"


#define SECRETID @"c67e49e5b0c4610ed27f"
#define SECRETKEY @"ca34f792a4f92b1f47720d4068494177d"

@implementation LTGetAuthApi


- (NSString *)requestUrl {
    return @"Auth/getAuth";
}

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodGET;
}

- (id)requestArgument {
    return @{
             @"secretId": SECRETID,
             @"secretKey": SECRETKEY
             };
}


@end
