//
//  LTVideoDetailApi.h
//  test
//
//  Created by letar on 2018/8/1.
//  Copyright © 2018年 letar. All rights reserved.
//

#import "YTKRequest.h"

@interface LTVideoDetailApi : YTKRequest

- (id)initWithToken:(NSString *)token lessonId:(NSString *)lessonId;

@end
