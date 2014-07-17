//
//  HomePageTableViewController.m
//  IOS_27_Brighttj
//
//  Created by rimi on 14-7-16.
//  Copyright (c) 2014年 brighttj. All rights reserved.
//

/*
    
 home page user interface and logical code.
 
 */

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

/**
 *  rewitre init method
 *
 *  @return already initializied object
 */
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
    
    // initialize data source
    [self initializeDataSource];
    // initailize user interface
    [self initializeUserInterface];
}

/**
 *  initialize date source
 */
- (void)initializeDataSource {
    
    // initialize network connection
    NetworkConnection *connection = [[NetworkConnection alloc] init];
    // set request url
    connection.urlString = @"http://www.brighttj.com/ios/wp-posts.php";
    // set connection data
    connection.postData = nil;
    // send request with post method
    [connection asynchronousPOSTRequert];
    // set NetworkConnectionDelegate delegate
    connection.delegate = self;
}

/**
 *  initialize user interface
 */
- (void)initializeUserInterface {
    
    // register custom cell with cell identifier
    [self.tableView registerClass:[CustomTableViewCell class] forCellReuseIdentifier:CELL_IDENTIFIER];
    // set table row height
    self.tableView.rowHeight = 80;
    
    // initialize category list bar button with image "menu.png"
    UIBarButtonItem *categoryListButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"menu"]
                                                                           style:UIBarButtonItemStylePlain
                                                                          target:self
                                                                          action:@selector(barButtonItemPressed:)];
    self.navigationItem.leftBarButtonItem = categoryListButton;
    [categoryListButton release];
    
    // initialize category list bar button with image "more.png"
    UIBarButtonItem *shareButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"more"]
                                                                           style:UIBarButtonItemStylePlain
                                                                          target:self
                                                                          action:@selector(barButtonItemPressed:)];
    self.navigationItem.rightBarButtonItem = shareButton;
    [shareButton release];
}

/**
 *  bar button trigger event
 *
 *  @param sender : the bar button who is trigger this event
 */
- (void)barButtonItemPressed:(UIBarButtonItem *)sender {
    
    
}

#pragma mark - NetworkConnectionDelegate methods

/**
 *  update user interface untill connection has response
 *
 *  @param data : response data
 */
- (void)updateUserInterfaceWithData:(NSDictionary *)data {
    
    // package data in post object
    for (int i = 0; i < [data allKeys].count; i ++) {
        
        Post *post = [[Post alloc] init];
        post.postID = POST_ID(i);
        post.postTitle = [[data objectForKey:POST_ID(i)] objectForKey:@"post_title"];
        post.postAuthor = [[data objectForKey:POST_ID(i)] objectForKey:@"post_author"];
        post.postDate = [[data objectForKey:POST_ID(i)] objectForKey:@"post_date"];
        post.postViews = [[data objectForKey:POST_ID(i)] objectForKey:@"post_views"];
        // add post into _dataSource
        [_dataSource addObject:post];
        [post release];
    }
    [self.tableView reloadData];
    NSLog(@"%@", data);
}

#pragma mark - Table view data source

/**
 *  set the number of sections
 *
 *  @param tableView : the tableview who is trigger this event
 *
 *  @return the number of sections
 */
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{

    return 1;
}

/**
 *  set the number of rows in the section
 *
 *  @param tableView : the tableview who is trigger this event
 *  @param section   : the section who would set row
 *
 *  @return the number of rows in the section
 */
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    // Return the number of rows in the section.
    return _dataSource.count;
}

#pragma mark - UITableViewDelegate methods

/**
 *  set the content of cell
 *
 *  @param tableView : the tableview who is trigger this event
 *  @param indexPath : the tableview index
 *
 *  @return already set cell
 */
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    // initialize custom cell
    CustomTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CELL_IDENTIFIER];
    // set cell text
    cell.titleLabel.text = ((Post *)_dataSource[indexPath.row]).postTitle;
    cell.authorLabel.text = ((Post *)_dataSource[indexPath.row]).postAuthor;
    cell.viewsLabel.text = ((Post *)_dataSource[indexPath.row]).postViews;
    cell.dateLabel.text = ((Post *)_dataSource[indexPath.row]).postDate;
    // set single cell background
    if (indexPath.row % 2) {
        
        cell.backgroundColor = [UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:0.2];
    } else {
        
        cell.backgroundColor = [UIColor whiteColor];
    }
    return cell;
}

/**
 *  tableview cell did selected event
 *
 *  @param tableView : the tableview who is trigger this event
 *  @param indexPath : the tableview index
 */
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    // set cell highlight disappear
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSLog(@"%d", indexPath.row);
}

@end
