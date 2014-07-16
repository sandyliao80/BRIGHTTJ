//
//  Post.h
//  BRIGHTTJ
//
//  Created by rimi on 14-7-16.
//  Copyright (c) 2014年 brighttj. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Post : NSObject

@property (nonatomic, retain) NSString *postID;
@property (nonatomic, retain) NSString *postTitle;
@property (nonatomic, retain) NSString *postDate;
@property (nonatomic, retain) NSString *postViews;
@property (nonatomic, retain) NSString *postAuthor;

@end