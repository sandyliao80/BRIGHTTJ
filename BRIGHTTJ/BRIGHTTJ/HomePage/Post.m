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
#import "GTMBase64.h"
#import "RegexKitLite.h"

@implementation Post

- (void)dealloc {
    
    [_postContent release];
    [_postTitle release];
    [_postID release];
    [_postViews release];
    [_postDate release];
    [super dealloc];
}

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

- (void)setPostContent:(NSString *)postContent {
    
    if (_postContent != postContent) {
        
        [_postContent release];
        
        NSData *data = [GTMBase64 decodeString:postContent];
        _postTitle = [[NSString stringWithFormat:@"%@%@%@", @"<body style=\"line-height: 18px;\"><br/><h3 style=\"text-align:center;\">", _postTitle, @"</h3>"] retain];
        _postDate = [[NSString stringWithFormat:@"%@%@%@%@%@", @"<p style=\"font-size:12;color:#807f7e;text-align:center\">", _postAuthor, @"&nbsp;&nbsp;&nbsp;&nbsp;", _postDate, @"</p>"] retain];
        
        NSString *postContentString = [NSString stringWithFormat:@"%@%@%@%@", _postTitle, _postDate,
                                              [[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] autorelease], @"</body>"];
        postContentString = [self addBlockquoteStyleInString:postContentString];
        postContentString = [self deleteCaptionMetaInString:postContentString];
        postContentString = [self resetImageSizeInString:postContentString];
        
        _postContent = [[NSString stringWithFormat:@"%@", postContentString] retain];
        
        NSLog(@"%@", postContentString);
    }
}

- (NSString *)addBlockquoteStyleInString:(NSString *)string {
    
    string = [string stringByReplacingOccurrencesOfString:@"<blockquote>" withString:@"<br/><br/><div style=\"background:#e3e3e3;padding:5px;\">"];
    string = [string stringByReplacingOccurrencesOfString:@"</blockquote>" withString:@"</div><br/>"];
    
    return string;
}

- (NSString *)deleteCaptionMetaInString:(NSString *)string {
    
    NSString *regexString = [NSString stringWithFormat:@"%@", @"\\[caption id=\"\" align=\"alignnone\" width=\"...\"\\]"];
    string = [string stringByReplacingOccurrencesOfRegex:regexString withString:@""];
    string = [string stringByReplacingOccurrencesOfString:@"[/caption]" withString:@"<br/>"];
    
    return string;
}

- (NSString *)resetImageSizeInString:(NSString *)string {
    
    NSString *regexString = [NSString stringWithFormat:@"%@", @"width=\"...\" height=\".*\""];
    string = [string stringByReplacingOccurrencesOfRegex:regexString withString:@"width=\"320\""];
    
    NSLog(@"%@", regexString);
    
    return string;
}

@end