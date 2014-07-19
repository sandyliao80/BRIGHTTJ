//
//  PostDetailViewController.m
//  BRIGHTTJ
//
//  Created by rimi on 14-7-16.
//  Copyright (c) 2014年 brighttj. All rights reserved.
//

#import "PostDetailViewController.h"
#import "NetworkConnection.h"
#import "NetworkConnectionDelegate.h"
#import "GTMBase64.h"
#import "Post.h"

#define POST_ID(index) [[data allKeys] objectAtIndex:index]

@interface PostDetailViewController () <NetworkConnectionDelegate> {
    
    Post *_post;
    
    UILabel *_titleLabel;
    UILabel *_authorLabel;
    UILabel *_dateLabel;
    UILabel *_contentLabel;
    
    UITextView *_textView;
}

- (void)initializeDataSource;
- (void)initializeUserInterface;

- (void)barButtonPressed:(UIBarButtonItem *)sender;

- (void)updateUserInterfaceWithData:(NSDictionary *)data;

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
    
    [_post release];
    [_textView release];
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initializeDataSource];
    [self initializeUserInterface];
}

- (void)initializeDataSource {
    
    NetworkConnection *connection = [[NetworkConnection alloc] init];
    connection.urlString = @"http://www.brighttj.com/ios/wp-posts.php";
    connection.postData = @{@"type": @"post", @"id": _post.postID};
    [connection asynchronousPOSTRequert];
    connection.delegate = self;
    [connection release];
}

- (void)initializeUserInterface {
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIImage *moreImage = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForAuxiliaryExecutable:@"more.png"]];
    UIBarButtonItem *moreBarButton = [[UIBarButtonItem alloc] initWithImage:moreImage
                                                                      style:UIBarButtonItemStylePlain
                                                                     target:self
                                                                     action:@selector(barButtonPressed:)];
    self.navigationItem.rightBarButtonItem = moreBarButton;
    [moreBarButton release];
    
    _textView = [[UITextView alloc] init];
    _textView.bounds = CGRectMake(0, 0, self.view.bounds.size.width - 10, self.view.bounds.size.height);
    _textView.center = CGPointMake(CGRectGetMidX(self.view.bounds), CGRectGetMidY(self.view.bounds));
    _textView.font = [UIFont fontWithName:@"Arial" size:20.0];//设置字体名字和字体大小
    _textView.editable = NO;
    _textView.scrollEnabled = YES;//是否可以拖动
    _textView.autoresizingMask = UIViewAutoresizingFlexibleHeight;//自适应高度
    [self.view addSubview: _textView];//加入到整个页面中
}

- (void)barButtonPressed:(UIBarButtonItem *)sender {
    
    
}

#pragma mark - NetworkConnectionDelegate methods

/**
 *  recevie network connection response data
 *
 *  @param data : response data
 */
- (void)recevieResponseData:(NSDictionary *)data {
    
    _post.postTitle = [[data objectForKey:POST_ID(0)] objectForKey:@"post_title"];
    _post.postDate = [[data objectForKey:POST_ID(0)] objectForKey:@"post_date"];
    _post.postAuthor = [[data objectForKey:POST_ID(0)] objectForKey:@"post_author"];
    _post.postContent = [[data objectForKey:POST_ID(0)] objectForKey:@"post_content"];
    
    [self updateUserInterfaceWithData:data];
}

/**
 *  update user interface
 *
 *  @param data : update data
 */
- (void)updateUserInterfaceWithData:(NSDictionary *)data {
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithData:[_post.postContent dataUsingEncoding:NSUnicodeStringEncoding]
                                                                                          options:@{NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType}
                                                                               documentAttributes:nil
                                                                                            error:nil];
    _textView.attributedText = attributedString;
}

@end