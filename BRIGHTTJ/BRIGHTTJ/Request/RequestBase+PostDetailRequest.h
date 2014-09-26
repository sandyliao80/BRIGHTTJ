//
//  RequestBase+PostDetailRequest.h
//  BRIGHTTJ
//
//  Created by rimi on 14-9-26.
//  Copyright (c) 2014年 brighttj. All rights reserved.
//

#import "RequestBase.h"

@interface RequestBase (PostDetailRequest)

+ (void)requestPostDetailWithPostId:(NSString *)postId callback:(Callback)callback;

@end