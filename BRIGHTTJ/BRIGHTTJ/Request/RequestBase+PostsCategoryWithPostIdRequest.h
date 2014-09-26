//
//  RequestBase+PostsCategoryRequest.h
//  BRIGHTTJ
//
//  Created by rimi on 14-9-26.
//  Copyright (c) 2014年 brighttj. All rights reserved.
//

#import "RequestBase.h"

@interface RequestBase (PostsCategoryWithPostIdRequest)

+ (void)requestPostsListWithPostId:(NSString *)postId callback:(Callback)callback;

@end