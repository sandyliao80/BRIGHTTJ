
//
//  PostDetailViewController.m
//  BRIGHTTJ
//
//  Created by rimi on 14-7-16.
//  Copyright (c) 2014年 brighttj. All rights reserved.
//

/*
 
 post detail user interface and logical code.
 
 */

#import "PostDetailViewController.h"
#import "GTMBase64.h"
#import "Post.h"
#import <ShareSDK/ShareSDK.h>
#import <TencentOpenAPI/QQApiInterface.h>
#import <TencentOpenAPI/TencentOAuth.h>
#import "PostAuthor.h"
#import "DataPersistence.h"
#import "SvGifView.h"
#import "RequestBase+PostDetailRequest.h"

#define POST_ID(index) [[result allKeys] objectAtIndex:index]

@interface PostDetailViewController () <UIActionSheetDelegate, UIWebViewDelegate> {
    
    Post *_post;
    NSString *_postContent;
    UIWebView *_textView;
    NSMutableAttributedString *_attributedString;
    SvGifView *_gifView;
}

- (void)initializeDataSource;
- (void)initializeUserInterface;

- (void)updateUserInterfaceWithPostContent:(NSString *)postContent;

@end

@implementation PostDetailViewController

/**
 *  initialize PostDetailViewController with postid
 *
 *  @param postID : post id
 *
 *  @return already initialized PostDetailViewController
 */
- (id)initWithPostID:(NSString *)postID {
    
    self = [super init];
    
    if (self) {
        
        _post = [[Post alloc] init];
        _post.postID = postID;
    }
    
    return self;
}

- (void)dealloc {
    
    NSLog(@"%@我被销毁了", [self class]);
    
    [_gifView release];
    [_attributedString release];
    [_textView release];
    [_postContent release];
    [_post release];
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initializeUserInterface];
    
    _postContent = [[DataPersistence readPostContentWithPostId:_post.postID] retain];

    if (_postContent == NULL || _postContent.length == 6) {
        
        NSLog(@"我没有缓存，我到网络上请求了");
        [self initializeDataSource];
    } else {
        
        NSLog(@"我有缓存，我读的缓存");
        [self updateUserInterfaceWithPostContent:_postContent];
    }
}

/**
 *  initialize data source
 */
- (void)initializeDataSource {
    
    [_gifView startGif];
    
    [RequestBase requestPostDetailWithPostId:_post.postID callback:^(NSError *error, NSMutableDictionary *result) {
        
        if (!error) {
            
            // package data in post object
            _post.postTitle = [[result objectForKey:POST_ID(0)] objectForKey:@"post_title"];
            _post.postDate = [[result objectForKey:POST_ID(0)] objectForKey:@"post_date"];
            _post.postAuthor = [[result objectForKey:POST_ID(0)] objectForKey:@"post_author"];
            _post.postContent = [[result objectForKey:POST_ID(0)] objectForKey:@"post_content"];
            
            [DataPersistence savePostContent:_post];
            
            // update user interface with data
            [self updateUserInterfaceWithPostContent:_post.postContent];
        } else {
            
            [_gifView stopGif];
        }
    }];
}

/**
 *  initialize user interface
 */
- (void)initializeUserInterface {
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    _textView = [[UIWebView alloc] init];
    _textView.bounds = CGRectMake(0, 0, self.view.bounds.size.width - 10, self.view.bounds.size.height);
    _textView.center = CGPointMake(CGRectGetMidX(self.view.bounds), CGRectGetMidY(self.view.bounds));
//    _textView.editable = NO; // don't allow editing
//    _textView.scrollEnabled = YES; // allow scroll
    _textView.autoresizingMask = UIViewAutoresizingFlexibleHeight; // auto resize
    [self.view addSubview: _textView];
    
    NSURL *fileUrl = [[NSBundle mainBundle] URLForResource:@"loading" withExtension:@"gif"];
    _gifView = [[SvGifView alloc] initWithCenter:CGPointMake(self.view.bounds.size.width / 2, self.view.bounds.size.height / 2 - 50) fileURL:fileUrl];
    _gifView.backgroundColor = [UIColor clearColor];
    _gifView.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
    [self.view addSubview:_gifView];
    
    UIBarButtonItem *mailButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"share"]
                                                                   style:UIBarButtonItemStylePlain
                                                                  target:self
                                                                  action:nil];
    self.navigationItem.rightBarButtonItem = mailButton;
    mailButton.tag = 11;
    [mailButton release];
}

/**
 *  update user interface
 *
 *  @param data : update data
 */
- (void)updateUserInterfaceWithPostContent:(NSString *)postContent {
    
    // set text type is html text document type
//    _attributedString = [[NSMutableAttributedString alloc] initWithData:[postContent dataUsingEncoding:NSUnicodeStringEncoding]
//                                                                                          options:@{NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType}
//                                                                               documentAttributes:nil
//                                                                                            error:nil];
//    _textView.attributedText = _attributedString;
//
    
    [_textView loadHTMLString:postContent baseURL:nil];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    
    [_gifView stopGif];
}

@end