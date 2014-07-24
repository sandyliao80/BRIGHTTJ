//
//  PostAuthor.m
//  BRIGHTTJ
//
//  Created by rimi on 14-7-22.
//  Copyright (c) 2014年 brighttj. All rights reserved.
//

#import "PostAuthor.h"

@implementation PostAuthor

static PostAuthor *author2;
static PostAuthor *author3;

+ (void)initAuthorInfo {
    
    author2 = [[PostAuthor alloc] init];
    author2.authorId = @"2";
    author2.authorName = @"敬洁";
    author2.authorEmail = @"clavisj@outlook.com";
    author2.weiboName = @"小懒_Clavis";
    
    author3 = [[PostAuthor alloc] init];
    author3.authorId = @"3";
    author3.authorName = @"唐嘉蓉";
    author3.authorEmail = @"tangjr.work@gmail.com";
    author3.weiboName = @"bright_tang";
}

+ (PostAuthor *)standardPostAnthorWithAuthorId:(NSString *)authorId {
    
    if ([authorId isEqualToString:@"2"]) {
        
        return author2;
    } else {
        
        return author3;
    }
}

+ (PostAuthor *)standardPostAnthorWithAuthorName:(NSString *)authorName {
    
    if ([authorName isEqualToString:@"敬洁"]) {
        
        return author2;
    } else {
        
        return author3;
    }
}

@end