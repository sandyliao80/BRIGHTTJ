//
//  PostAuthor.h
//  BRIGHTTJ
//
//  Created by rimi on 14-7-22.
//  Copyright (c) 2014年 brighttj. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PostAuthor : NSObject

@property (nonatomic, retain) NSString *authorId;
@property (nonatomic, retain) NSString *authorName;
@property (nonatomic, retain) NSString *authorEmail;
@property (nonatomic, retain) NSString *weiboName;

+ (void)initAuthorInfo;
+ (PostAuthor *)standardPostAnthorWithAuthorId:(NSString *)authorId;
+ (PostAuthor *)standardPostAnthorWithAuthorName:(NSString *)authorName;

@end