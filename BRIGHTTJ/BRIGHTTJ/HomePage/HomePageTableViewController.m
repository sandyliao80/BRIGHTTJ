//
//  HomePageTableViewController.m
//  IOS_27_Brighttj
//
//  Created by rimi on 14-7-16.
//  Copyright (c) 2014年 brighttj. All rights reserved.
//

#import "HomePageTableViewController.h"
#import "NetworkConnection.h"
#import "NetworkConnectionDelegate.h"
#import "CustomTableViewCell.h"
#import "Post.h"

#define CELL_IDENTIFIER @"Custom"
#define POST_ID(index) [[data allKeys] objectAtIndex:index]

@interface HomePageTableViewController () <NetworkConnectionDelegate> {
    
    NSMutableArray *_dataSource;
}

- (void)initializeDataSource;
- (void)initializeUserInterface;

- (void)barButtonItemPressed:(UIBarButtonItem *)sender;

@end

@implementation HomePageTableViewController

- (id)init {
    
    self = [super init];
    
    if (self) {
        
        self.title = @"BRIGHTTJ";
        _dataSource = [[NSMutableArray alloc] init];
    }
    
    return self;
}

- (void)dealloc {
    
    [_dataSource release];
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initializeDataSource];
    [self initializeUserInterface];
}

- (void)initializeDataSource {
    
    NetworkConnection *connection = [[NetworkConnection alloc] init];
    connection.urlString = @"http://www.brighttj.com/ios/wp-posts.php";
    [connection asynchronousPOSTRequertWithParameters:nil];
    connection.delegate = self;
}

- (void)initializeUserInterface {
    
    [self.tableView registerClass:[CustomTableViewCell class] forCellReuseIdentifier:CELL_IDENTIFIER];
    self.tableView.rowHeight = 80;
    
    UIBarButtonItem *categoryListButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"menu"]
                                                                           style:UIBarButtonItemStylePlain
                                                                          target:self
                                                                          action:@selector(barButtonItemPressed:)];
    self.navigationItem.leftBarButtonItem = categoryListButton;
    [categoryListButton release];
    
    UIBarButtonItem *shareButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"share"]
                                                                           style:UIBarButtonItemStylePlain
                                                                          target:self
                                                                          action:@selector(barButtonItemPressed:)];
    self.navigationItem.rightBarButtonItem = shareButton;
    [shareButton release];
}

- (void)barButtonItemPressed:(UIBarButtonItem *)sender {
    
    
}

#pragma mark - NetworkConnectionDelegate methods

- (void)updateUserInterfaceWithData:(NSDictionary *)data {
    
    for (int i = 0; i < [data allKeys].count; i ++) {
        
        Post *post = [[Post alloc] init];
        post.postID = POST_ID(i);
        post.postTitle = [[data objectForKey:POST_ID(i)] objectForKey:@"post_title"];
        post.postAuthor = [[data objectForKey:POST_ID(i)] objectForKey:@"post_author"];
        post.postDate = [[data objectForKey:POST_ID(i)] objectForKey:@"post_date"];
        post.postViews = [[data objectForKey:POST_ID(i)] objectForKey:@"post_views"];
        [_dataSource addObject:post];
        NSLog(@"%@", post.postDate);
        [post release];
    }
    [self.tableView reloadData];
    NSLog(@"%@", data);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    // Return the number of rows in the section.
    return _dataSource.count;
}

#pragma mark - UITableViewDelegate methods

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CustomTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CELL_IDENTIFIER];
    cell.titleLabel.text = ((Post *)_dataSource[indexPath.row]).postTitle;
    cell.authorLabel.text = ((Post *)_dataSource[indexPath.row]).postAuthor;
    cell.viewsLabel.text = ((Post *)_dataSource[indexPath.row]).postViews;
    cell.dateLabel.text = ((Post *)_dataSource[indexPath.row]).postDate;
    if (indexPath.row % 2) {
        
        cell.backgroundColor = [UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:0.2];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
