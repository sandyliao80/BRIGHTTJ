//
//  Post.h
//  BRIGHTTJ
//
//  Created by rimi on 14-7-16.
//  Copyright (c) 2014年 brighttj. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Post : NSObject

@property (nonatomic, retain) NSString *postID; // post id
@property (nonatomic, retain) NSString *postTitle; // post title
@property (nonatomic, retain) NSString *postDate; // post date
@property (nonatomic, retain) NSString *postViews; // post views
@property (nonatomic, retain) NSString *postAuthor; // post author
@property (nonatomic, retain) NSString *postContent; // post content

@end