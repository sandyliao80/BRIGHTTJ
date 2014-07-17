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

@interface PostDetailViewController () <NetworkConnectionDelegate>

- (void)initializeDataSource;
- (void)initializeUserInterface;


@end

@implementation PostDetailViewController

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
    [connection asynchronousPOSTRequert];
    connection.delegate = self;
}

- (void)initializeUserInterface {
    
    
}

- (void)updateUserInterfaceWithData:(NSDictionary *)data {
    
    
}

@end