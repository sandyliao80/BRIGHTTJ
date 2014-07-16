//
//  Post.m
//  BRIGHTTJ
//
//  Created by rimi on 14-7-16.
//  Copyright (c) 2014年 brighttj. All rights reserved.
//

#import "Post.h"

@implementation Post

- (void)setPostDate:(NSString *)postDate {
    
    if (_postDate != postDate) {
        
        postDate = [postDate substringToIndex:11];
        [_postDate release];
        _postDate = [postDate retain];
    }
}

- (void)setPostAuthor:(NSString *)postAuthor {
    
    if (_postAuthor != postAuthor) {
        
        [_postAuthor release];
        if ([postAuthor intValue] == 2) {
            
            _postAuthor = [[NSString stringWithFormat:@"敬洁"] retain];
        } else {
            
            _postAuthor = [[NSString stringWithFormat:@"唐嘉蓉"] retain];
        }
    }
}

@end