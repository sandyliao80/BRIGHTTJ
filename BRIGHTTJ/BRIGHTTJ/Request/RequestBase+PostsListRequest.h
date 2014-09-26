//
//  RequestBase+PostsListRequest.h
//  BRIGHTTJ
//
//  Created by rimi on 14-9-26.
//  Copyright (c) 2014年 brighttj. All rights reserved.
//

#import "RequestBase.h"

@interface RequestBase (PostsListRequest)

+ (void)requestPostsListWithPage:(NSString *)page callback:(Callback)callback;

@end
