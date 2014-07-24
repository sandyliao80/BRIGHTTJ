//
//  DataPersistence.h
//  BRIGHTTJ
//
//  Created by rimi on 14-7-23.
//  Copyright (c) 2014年 brighttj. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Post.h"

@interface DataPersistence : NSObject

+ (void)savePostsList:(NSArray *)posts;
+ (void)deleteAllPostsList;
+ (NSMutableArray *)readPostsList;

+ (void)savePostContent:(Post *)post;
+ (void)deleteAllPosts;
+ (NSString *)readPostContentWithPostId:(NSString *)postId;

@end