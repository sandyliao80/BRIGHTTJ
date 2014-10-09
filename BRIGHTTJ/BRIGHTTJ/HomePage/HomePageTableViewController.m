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

#import "CustomTableViewCell.h"
#import "Post.h"
#import "PostDetailViewController.h"
#import "LeftView.h"
#import "PostCategory.h"
#import "MJRefresh.h"
#import "CSNotificationView.h"
#import "DataPersistence.h"
#import "RootViewController.h"
#import "RequestBase+PostsListRequest.h"
#import "RequestBase+PostsCategoryWithPostIdRequest.h"

#define CELL_IDENTIFIER @"Custom"
#define GET_ID_IN_DICTIONARY(index) [[result allKeys] objectAtIndex:index]

@interface HomePageTableViewController () {
    
    NSMutableArray *_tempDataSource;
    NSMutableArray *_dataSource;
    BOOL _isCategoryList;
    BOOL _isFooterRefreshing;
    BOOL _isHeaderRefreshing;
    NSInteger _page;
}

@property (nonatomic, retain) NSMutableArray *dataSource;

- (void)initializeUserInterface;

- (void)updateUserInterfaceWithData:(NSDictionary *)data;
- (void)footerRefreshing;
- (void)headerRefreshing;

- (void)readPostsListFromLocalData;

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
        _tempDataSource = [[NSMutableArray alloc] init];
        _isCategoryList = NO;
        _isFooterRefreshing = NO;
        _isHeaderRefreshing = YES;
        _page = 0;
        _footerRefreshEnable = YES;
    }
    
    return self;
}

- (void)dealloc {
    
    NSLog(@"%@被销毁了", [self class]);
    
    [_tempDataSource release];
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
    
    [RequestBase requestPostsListWithPage:[NSString stringWithFormat:@"%d", _page] callback:^(NSError *error, NSMutableDictionary *result) {
        
        if (!error && [result allKeys].count) {
            
            NSLog(@"我是到网络上请求的列表");
            
            if (_isCategoryList || !_isFooterRefreshing || _isHeaderRefreshing) {
                
                [_dataSource removeAllObjects];
            }
            if (_isHeaderRefreshing) {
                
                [DataPersistence deleteAllPostsList];
            }
            
            NSArray *posts = [result objectForKey:@"posts"];
            
            for (NSDictionary *value in posts) {
                
                Post *post = [[Post alloc] init];
                post.postID = [value objectForKey:@"ID"];
                post.postTitle = [value objectForKey:@"post_title"];
                post.postAuthor = [value objectForKey:@"post_author"];
                post.postDate = [value objectForKey:@"post_date"];
                
                [_tempDataSource addObject:post];
                [post release];
            }
            
            [_dataSource addObjectsFromArray:_tempDataSource];
            
            if (!_isCategoryList) {
                
                [DataPersistence savePostsList:_tempDataSource];
                NSLog(@"enable-->%d", _footerRefreshEnable);
            }
            [_tempDataSource removeAllObjects];
            
            // to ask update user interface with data
            [self updateUserInterfaceWithData:result];
            
            _isCategoryList = NO;
            _isFooterRefreshing = NO;
            _isHeaderRefreshing = NO;
            [self.tableView footerEndRefreshing];
            [self.tableView headerEndRefreshing];
        } else {
            
            _isFooterRefreshing = NO;
            _isHeaderRefreshing = NO;
            [self.tableView footerEndRefreshing];
            [self.tableView headerEndRefreshing];
            
            [CSNotificationView showInViewController:self style:CSNotificationViewStyleError message:@"网络连接失败，无法更新文章列表"];
            
            [self readPostsListFromLocalData];
        }
    }];
}

/**
 *  initialize user interface
 */
- (void)initializeUserInterface {
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self.tableView addFooterWithTarget:self action:@selector(footerRefreshing)];
    [self.tableView addHeaderWithTarget:self action:@selector(headerRefreshing)];
    
    // register custom cell with cell identifier
    [self.tableView registerClass:[CustomTableViewCell class] forCellReuseIdentifier:CELL_IDENTIFIER];
    // set table row height
    self.tableView.rowHeight = 80;
    
    [self readPostsListFromLocalData];
}

#pragma mark - PostCategoryDelegate methods

- (void)requestPostCategoryByPostCategoryId:(NSString *)postCategoryId {
    
    _isCategoryList = YES;
    
    [RequestBase requestPostsListWithPostId:postCategoryId callback:^(NSError *error, NSMutableDictionary *result) {
        
        // TODO:分类请求回调处理
    }];
}

#pragma mark - UpdateUserInterface methods

/**
 *  update user interface
 *
 *  @param data : update data
 */
- (void)updateUserInterfaceWithData:(NSMutableDictionary *)data {
    
    [self.tableView reloadData];
}

- (void)footerRefreshing {
    
    if (_footerRefreshEnable) {
        
        _isFooterRefreshing = YES;
        _page ++;
        [self initializeDataSource];
    } else {
        
        [self.tableView footerEndRefreshing];
    }
}

- (void)headerRefreshing {
    
    _page = 0;
    _isHeaderRefreshing = YES;
    _footerRefreshEnable = YES;
    [self initializeDataSource];
}

#pragma mark - UITableViewDataSource methods

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
    
//    RootViewController *rootVC = (RootViewController *)self.w

    Post *selectedPost = (Post *)_dataSource[indexPath.row];
    PostDetailViewController *postDetailVC = [[PostDetailViewController alloc] initWithPostID:selectedPost.postID];
    [self.navigationController pushViewController:postDetailVC animated:YES];
    [postDetailVC release];
}

- (void)readPostsListFromLocalData {
    
    self.dataSource = [DataPersistence readPostsList];
    [self.tableView reloadData];
}

@end