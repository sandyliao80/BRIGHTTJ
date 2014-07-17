//
//  Post.m
//  BRIGHTTJ
//
//  Created by rimi on 14-7-16.
//  Copyright (c) 2014年 brighttj. All rights reserved.
//

/*
 
 post property and rewrite setter method code.
 
 */

#import "Post.h"

@implementation Post

/**
 *  rewrite setter method of postDate
 *
 *  @param postDate : post date
 */
- (void)setPostDate:(NSString *)postDate {
    
    if (_postDate != postDate) {
        
        postDate = [postDate substringToIndex:11]; // cut off HH:mm:ss in date
        [_postDate release];
        _postDate = [postDate retain];
    }
}

/**
 *  rewrite setter method of postAuthor
 *
 *  @param postAuthor : post author
 */
- (void)setPostAuthor:(NSString *)postAuthor {
    
    if (_postAuthor != postAuthor) {
        
        [_postAuthor release];
        
        // replace post author id with post author name
        if ([postAuthor intValue] == 2) {
            
            _postAuthor = [[NSString stringWithFormat:@"敬洁"] retain];
        } else {
            
            _postAuthor = [[NSString stringWithFormat:@"唐嘉蓉"] retain];
        }
    }
}

@end