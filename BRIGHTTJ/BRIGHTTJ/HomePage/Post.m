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

/**
 *  rewrite setter method of postContent
 *
 *  @param postContent : post content
 */
- (void)setPostContent:(NSString *)postContent {
    
    if (_postContent != postContent) {
        
        [_postContent release];
        
        // decode string with base64
        NSData *data = [GTMBase64 decodeString:postContent];
        
        // set post title text and style using html code
        self.postTitle = [[NSString stringWithFormat:@"%@%@%@", @"<body style=\"line-height: 18px;\"><br/><h3 style=\"text-align:center;\">", _postTitle, @"</h3>"] retain];
        
        // set post date text and style using html code
        self.postDate = [[NSString stringWithFormat:@"%@%@%@%@%@", @"<p style=\"font-size:12;color:#807f7e;text-align:center\">", _postAuthor, @"&nbsp;&nbsp;&nbsp;&nbsp;", _postDate, @"</p>"] retain];
        
        // initialize post content
        NSString *postContentString = [NSString stringWithFormat:@"%@%@%@%@", _postTitle, _postDate,
                                              [[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] autorelease], @"</body>"];
        
        // block or replace special char in post content
        postContentString = [self addBlockquoteStyleInString:postContentString];
        postContentString = [self deleteCaptionMetaInString:postContentString];
        postContentString = [self resizeImageInString:postContentString];
        
        // set post content
        _postContent = [[NSString stringWithFormat:@"%@", postContentString] retain];
        
        NSLog(@"%@", postContentString);
    }
}

/**
 *  add background color for blockquote meta
 *
 *  @param string : who need add background color for blockquote meta
 *
 *  @return already add background color
 */
- (NSString *)addBlockquoteStyleInString:(NSString *)string {
    
    string = [string stringByReplacingOccurrencesOfString:@"<blockquote>" withString:@"<br/><br/><div style=\"background:#e3e3e3;padding:5px;\">"];
    string = [string stringByReplacingOccurrencesOfString:@"</blockquote>" withString:@"</div><br/>"];
    
    return string;
}

/**
 *  block caption meta in string
 *
 *  @param string : who need block caption meta
 *
 *  @return already block caption meta
 */
- (NSString *)deleteCaptionMetaInString:(NSString *)string {
    
    // set regex
    NSString *regexString = [NSString stringWithFormat:@"%@", @"\\[caption id=\"\" align=\"alignnone\" width=\"...\"\\]"];
    // replace string by regex
    string = [string stringByReplacingOccurrencesOfRegex:regexString withString:@""];
    string = [string stringByReplacingOccurrencesOfString:@"[/caption]" withString:@"<br/>"];
    
    return string;
}

/**
 *  resize image
 *
 *  @param string : who need resize image
 *
 *  @return already resize image
 */
- (NSString *)resizeImageInString:(NSString *)string {
    
    // set regex
    NSString *regexString = [NSString stringWithFormat:@"%@", @"width=\"...\" height=\".*\""];
    // replace string by regex
    string = [string stringByReplacingOccurrencesOfRegex:regexString withString:@"width=\"320\""];
    
    NSLog(@"%@", regexString);
    
    return string;
}

@end