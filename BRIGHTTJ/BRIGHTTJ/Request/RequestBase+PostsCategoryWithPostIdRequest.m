//
//  RequestBase+PostsCategoryRequest.m
//  BRIGHTTJ
//
//  Created by rimi on 14-9-26.
//  Copyright (c) 2014年 brighttj. All rights reserved.
//

#import "RequestBase+PostsCategoryWithPostIdRequest.h"

@implementation RequestBase (PostsCategoryWithPostIdRequest)

+ (void)requestPostsListWithPostId:(NSString *)postId callback:(Callback)callback {
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    
    [parameters setObject:@"category" forKey:@"type"];
    [parameters setObject:postId forKey:@"id"];
    
    [self sendPostAsynchronizeRequestWithMethod:@"http://www.brighttj.com/ios/wp-posts.php" parameters:parameters callback:callback];
}

@end