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
#import "PostAuthor.h"

@implementation Post

- (void)dealloc {
    
    NSLog(@"%@被销毁了", [self class]);
    
    [_postAuthor release];
    [_postContent release];
    [_postTitle release];
    [_postID release];
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
        _postAuthor = [[[PostAuthor standardPostAnthorWithAuthorId:postAuthor] authorName] retain];
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
        
        // set post date text and style using html code
        NSString *postDate = [NSString stringWithFormat:@"</h3><p style=\"font-size:12;color:#807f7e;text-align:center\">%@%@%@%@", _postAuthor, @"&nbsp;&nbsp;&nbsp;&nbsp;", _postDate, @"</p>"];
        
        // initialize post content
        NSString *postContentString = [NSString stringWithFormat:@"%@%@%@%@%@", @"<body style=\"line-height: 18px;\"><br/><h3 style=\"text-align:center;\">", _postTitle, postDate, [[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] autorelease], @"</body>"];
        
        // block or replace special char in post content
        postContentString = [self addBlockquoteStyleInString:postContentString];
        postContentString = [self deleteCaptionMetaInString:postContentString];
        postContentString = [self resizeImageInString:postContentString];
        
        // set post content
        _postContent = [[NSString stringWithFormat:@"%@", postContentString] retain];
        
        NSLog(@"%@", _postContent);
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
    NSString *regexString = [NSString stringWithFormat:@"%@", @"\\[caption id=\"\" align=\".*\" width=\"...\"\\]"];
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
    
    return string;
}

- (NSComparisonResult)postIdCompare:(Post *)post {
    
    return [_postID compare:post.postID] * -1;
}

#pragma mark - NSCoding methods

/**
 *  对象编码为NSData
 *
 *  @param aCoder 编码器
 */
- (void)encodeWithCoder:(NSCoder *)aCoder {
    
    [aCoder encodeObject:_postID forKey:@"postID"];
    [aCoder encodeObject:_postDate forKey:@"postData"];
    [aCoder encodeObject:_postTitle forKey:@"postTitle"];
    [aCoder encodeObject:_postAuthor forKey:@"postAuthor"];
}

/**
 *  NSData解码为对象
 *
 *  @param aDecoder 解码器
 *
 *  @return 已经解码的对象
 */
- (id)initWithCoder:(NSCoder *)aDecoder {
    
    self = [super init];
    if (self) {
        
        self.postID = [aDecoder decodeObjectForKey:@"postID"];
        self.postDate = [aDecoder decodeObjectForKey:@"postData"];
        self.postTitle = [aDecoder decodeObjectForKey:@"postTitle"];
        self.postAuthor = [aDecoder decodeObjectForKey:@"postAuthor"];
    }
    return self;
}

@end