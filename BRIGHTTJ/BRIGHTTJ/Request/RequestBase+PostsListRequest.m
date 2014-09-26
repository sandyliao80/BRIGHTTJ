//
//  RequestBase+PostsListRequest.m
//  BRIGHTTJ
//
//  Created by rimi on 14-9-26.
//  Copyright (c) 2014年 brighttj. All rights reserved.
//

#import "RequestBase+PostsListRequest.h"

@implementation RequestBase (PostsListRequest)

+ (void)requestPostsListWithPage:(NSString *)page callback:(Callback)callback {
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    
    [parameters setObject:@"pages" forKey:@"type"];
    [parameters setObject:page forKey:@"page"];
    
    [self sendPostAsynchronizeRequestWithMethod:@"http://www.brighttj.com/ios/wp-posts.php" parameters:parameters callback:callback];
}

@end