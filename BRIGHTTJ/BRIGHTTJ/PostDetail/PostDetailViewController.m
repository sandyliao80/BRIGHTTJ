
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
#import "NetworkConnection.h"
#import "NetworkConnectionDelegate.h"
#import "GTMBase64.h"
#import "Post.h"
#import <ShareSDK/ShareSDK.h>
#import <TencentOpenAPI/QQApiInterface.h>
#import <TencentOpenAPI/TencentOAuth.h>
#import "PostAuthor.h"
#import "DataPersistence.h"
#import "SvGifView.h"

#define POST_ID(index) [[data allKeys] objectAtIndex:index]

@interface PostDetailViewController () <NetworkConnectionDelegate, UIActionSheetDelegate> {
    
    Post *_post;
    NSString *_postContent;
    UIWebView *_textView;
    NSMutableAttributedString *_attributedString;
    SvGifView *_gifView;
}

- (void)initializeDataSource;
- (void)initializeUserInterface;

- (void)configureShareParameters;
- (void)shareToSocialWebsites;

- (void)barButtonPressed:(UIBarButtonItem *)sender;

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
    
    // initialize network connection
    NetworkConnection *connection = [[NetworkConnection alloc] init];
    // set request url
    connection.urlString = @"http://www.brighttj.com/ios/wp-posts.php";
    // set connection data
    connection.postData = @{@"type": @"post", @"id": _post.postID};
    // send request with post method
    [connection asynchronousPOSTRequert];
    // set NetworkConnectionDelegate delegate
    connection.delegate = self;
    [connection release];
    
    [_gifView startGif];
}

/**
 *  initialize user interface
 */
- (void)initializeUserInterface {
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    // set right bar button
    UIImage *moreImage = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForAuxiliaryExecutable:@"share.png"]];
    UIBarButtonItem *moreBarButton = [[UIBarButtonItem alloc] initWithImage:moreImage
                                                                      style:UIBarButtonItemStylePlain
                                                                     target:self
                                                                     action:@selector(barButtonPressed:)];
    self.navigationItem.rightBarButtonItem = moreBarButton;
    [moreBarButton release];
    
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
    
    [self configureShareParameters];
}

/**
 *  bar button trigger event
 *
 *  @param sender : the bar button who is trigger this event
 */
- (void)barButtonPressed:(UIBarButtonItem *)sender {
    
    [self shareToSocialWebsites];
}

#pragma mark - Share methods

- (void)configureShareParameters {
    
    [ShareSDK registerApp:@"568898243"];
    
    /**
     连接新浪微博开放平台应用以使用相关功能，此应用需要引用SinaWeiboConnection.framework
     http://open.weibo.com上注册新浪微博开放平台应用，并将相关信息填写到以下字段
     **/
    [ShareSDK connectSinaWeiboWithAppKey:@"568898243"
                               appSecret:@"38a4f8204cc784f81f9f0daaf31e02e3"
                             redirectUri:@"http://www.sharesdk.cn"];
    /**
     连接QQ空间应用以使用相关功能，此应用需要引用QZoneConnection.framework
     http://connect.qq.com/intro/login/上申请加入QQ登录，并将相关信息填写到以下字段
     
     如果需要实现SSO，需要导入TencentOpenAPI.framework,并引入QQApiInterface.h和TencentOAuth.h，将QQApiInterface和TencentOAuth的类型传入接口
     **/
    [ShareSDK connectQZoneWithAppKey:@"100371282"
                           appSecret:@"aed9b0303e3ed1e27bae87c33761161d"
                   qqApiInterfaceCls:[QQApiInterface class]
                     tencentOAuthCls:[TencentOAuth class]];
}

- (void)shareToSocialWebsites {
    
    NSString *imagePath = [[NSBundle mainBundle] pathForResource:@"ShareSDK"  ofType:@"jpg"];
    
    NSString *contentString = [NSString stringWithFormat:@"我在http://www.brighttj.com上阅读了《 %@ 》这篇文章(作者@%@)，觉得很不错，和大家分享分享。传送门：http://www.brighttj.com?p=%@", _post.postTitle, [[PostAuthor standardPostAnthorWithAuthorName:_post.postAuthor] weiboName], _post.postID];
    
    //构造分享内容
    id<ISSContent> publishContent = [ShareSDK content:contentString
                                       defaultContent:contentString
                                                image:[ShareSDK imageWithPath:imagePath]
                                                title:@"ShareSDK"
                                                  url:@"http://www.sharesdk.cn"
                                          description:contentString
                                            mediaType:SSPublishContentMediaTypeNews];
    
    [ShareSDK showShareActionSheet:nil
                         shareList:nil
                           content:publishContent
                     statusBarTips:YES
                       authOptions:nil
                      shareOptions: nil
                            result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
                                if (state == SSResponseStateSuccess)
                                {
                                    NSLog(@"分享成功");
                                }
                                else if (state == SSResponseStateFail)
                                {
                                    NSLog(@"分享失败,错误码:%d,错误描述:%@", [error errorCode], [error errorDescription]);
                                }
                            }];
}

#pragma mark - NetworkConnectionDelegate methods

/**
 *  recevie network connection response data
 *
 *  @param data : response data
 */
- (void)recevieResponseData:(NSMutableDictionary *)data {
    
    // package data in post object
    _post.postTitle = [[data objectForKey:POST_ID(0)] objectForKey:@"post_title"];
    _post.postDate = [[data objectForKey:POST_ID(0)] objectForKey:@"post_date"];
    _post.postAuthor = [[data objectForKey:POST_ID(0)] objectForKey:@"post_author"];
    _post.postContent = [[data objectForKey:POST_ID(0)] objectForKey:@"post_content"];
    
    [DataPersistence savePostContent:_post];
    
    // update user interface with data
    [self updateUserInterfaceWithPostContent:_post.postContent];
}

- (void)networkConnectionError:(NSError *)error {
    
    [_gifView stopGif];
    NSLog(@"%@", error);
}

/**
 *  update user interface
 *
 *  @param data : update data
 */
- (void)updateUserInterfaceWithPostContent:(NSString *)postContent {
    
//    // set text type is html text document type
//    _attributedString = [[NSMutableAttributedString alloc] initWithData:[postContent dataUsingEncoding:NSUnicodeStringEncoding]
//                                                                                          options:@{NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType}
//                                                                               documentAttributes:nil
//                                                                                            error:nil];
//    _textView.attributedText = _attributedString;
//
    
    [_textView loadHTMLString:postContent baseURL:nil];
    [_gifView stopGif];
}

@end