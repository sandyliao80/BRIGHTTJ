//
//  RequestBase+PostsCategoryReuqest.m
//  BRIGHTTJ
//
//  Created by rimi on 14-9-26.
//  Copyright (c) 2014年 brighttj. All rights reserved.
//

#import "RequestBase+PostsCategoryReuqest.h"

@implementation RequestBase (PostsCategoryReuqest)

+ (void)requestPostCategoryWithCallback:(Callback)callback {
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    
    [parameters setObject:@"categories" forKey:@"type"];
    
    [self sendPostAsynchronizeRequestWithMethod:@"http://www.brighttj.com/ios/wp-posts.php" parameters:parameters callback:callback];
}

@end