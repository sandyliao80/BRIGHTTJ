//
//  RootViewController.m
//  BRIGHTTJ
//
//  Created by rimi on 14-7-21.
//  Copyright (c) 2014年 brighttj. All rights reserved.
//

#import "RootViewController.h"
#import "HomePageTableViewController.h"
#import "LeftView.h"
#import "PostCategory.h"
#import "PostAuthor.h"
#import <MessageUI/MessageUI.h>
#import "RequestBase+PostsCategoryReuqest.h"

#define GET_ID_IN_DICTIONARY(index) [[result allKeys] objectAtIndex:index]

@interface RootViewController () <UITableViewDelegate, UITableViewDataSource, MFMailComposeViewControllerDelegate> {
    
    UINavigationController *_navControlelr;
    HomePageTableViewController *_homePageTVC;
    UIView *_rightView;
    LeftView *_leftView;
    
    BOOL _isLeftShow;
    
    NSMutableArray *_dataSource;
}

- (void)initializeDataSource;
- (void)initializeUserInterface;
- (void)barButtonItemPressed:(UIBarButtonItem *)sender;
- (void)processGestureReconizer:(UIGestureRecognizer *)gesture;
- (void)hiddenOrShowLeftViewAnimation;

- (void)updateUserInterfaceWithData:(NSDictionary *)data;

@end

@implementation RootViewController

- (id)init {
    
    self = [super init];
    
    if (self) {
        
        _dataSource = [[NSMutableArray alloc] init];
    }
    
    return self;
}

- (void)dealloc {
    
    NSLog(@"%@被销毁了", [self class]);
    
    [_dataSource release];
    [_leftView release];
    [_rightView release];
    [_navControlelr release];
    [_homePageTVC release];
    
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
    
    [PostAuthor initAuthorInfo];
    
    [RequestBase requestPostCategoryWithCallback:^(NSError *error, NSMutableDictionary *result) {
        
        if (!error) {
            
            PostCategory *postCategory = [[PostCategory alloc] init];
            postCategory.categoryId = @"0";
            postCategory.categoryName = @"查看全部";
            [_dataSource addObject:postCategory];
            [postCategory release];
            
            for (int i = 0; i < [result allKeys].count; i ++) {
                
                PostCategory *postCategory = [[PostCategory alloc] init];
                postCategory.categoryId = GET_ID_IN_DICTIONARY(i);
                postCategory.categoryName = [[result objectForKey:GET_ID_IN_DICTIONARY(i)] objectForKey:@"category_name"];
                [_dataSource addObject:postCategory];
                [postCategory release];
            }
            
            // to ask update user interface with data
            [self updateUserInterfaceWithData:result];
        }
    }];
}

- (void)initializeUserInterface {
    
    _leftView = [[LeftView alloc] initWithFrame:CGRectMake(0, 0, 270, self.view.bounds.size.height)];
    _leftView.tableView.delegate = self;
    _leftView.tableView.dataSource = self;
    [self.view addSubview:_leftView];
    
    _homePageTVC = [[HomePageTableViewController alloc] init];
    _navControlelr = [[[UINavigationController alloc] initWithRootViewController:_homePageTVC] retain];
    _navControlelr.navigationBar.translucent = YES;
    _navControlelr.navigationBar.tintColor = [UIColor colorWithRed:(226/255.0) green:(101/255.0) blue:(64/255.0) alpha:1];
    
    // initialize category list bar button with image "menu.png"
    UIBarButtonItem *categoryListButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"menu"]
                                                                           style:UIBarButtonItemStylePlain
                                                                          target:self
                                                                          action:@selector(barButtonItemPressed:)];
    _homePageTVC.navigationItem.leftBarButtonItem = categoryListButton;
    categoryListButton.tag = 10;
    [categoryListButton release];
    
    // initialize category list bar button with image "paperplane.png"
    UIBarButtonItem *mailButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"paperplane"]
                                                                   style:UIBarButtonItemStylePlain
                                                                  target:self
                                                                  action:@selector(barButtonItemPressed:)];
    _homePageTVC.navigationItem.rightBarButtonItem = mailButton;
    mailButton.tag = 11;
    [mailButton release];
    
    _rightView = [_navControlelr.view retain];
    [self.view addSubview:_rightView];
    
    UIView *rightBorderView = [[UIView alloc] initWithFrame:CGRectMake(-4, 0, 4, self.view.bounds.size.height)];
    rightBorderView.backgroundColor = [UIColor colorWithRed:(226/255.0) green:(101/255.0) blue:(64/255.0) alpha:1];
    [_rightView addSubview:rightBorderView];
    [rightBorderView release];
    
    // 注册拖拽手势
//    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(processGestureReconizer:)];
//    [self.view addGestureRecognizer:pan];
//    [pan release];
    
    _isLeftShow = NO; // 标记左侧view是否显示
}

- (void)barButtonItemPressed:(UIBarButtonItem *)sender {
    
    if (sender.tag == 10) {
        
        [self hiddenOrShowLeftViewAnimation];
    } else {
        
        [self sendEmail];
    }
}

- (void)sendEmail {
    
    MFMailComposeViewController *mailConposeVC = [[MFMailComposeViewController alloc] init];
    mailConposeVC.mailComposeDelegate = self;
    // set recipient
    NSString *recipient1 = [[PostAuthor standardPostAnthorWithAuthorId:@"2"] authorEmail];
    NSString *recipient2 = [[PostAuthor standardPostAnthorWithAuthorId:@"3"] authorEmail];
    [mailConposeVC setToRecipients:[NSArray arrayWithObjects:recipient1, recipient2, @"291767410@qq.com", nil]];
    
    //    [self.view.window.rootViewController presentViewController:mailConposeVC animated:YES completion:nil];
    [self presentViewController:mailConposeVC animated:YES completion:nil];
    [mailConposeVC release];
}

#pragma mark - MFMailComposeViewControllerDelegate methods

- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error {
    
    switch (result)
    {
        case MFMailComposeResultCancelled:
            NSLog(@"Mail send canceled...");
            break;
        case MFMailComposeResultSaved:
            NSLog(@"Mail saved...");
            break;
        case MFMailComposeResultSent:
            NSLog(@"Mail sent...");
            break;
        case MFMailComposeResultFailed:
            NSLog(@"Mail send errored: %@...", [error localizedDescription]);
            break;
        default:
            break;
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)hiddenOrShowLeftViewAnimation {
    
    if (_isLeftShow) {
        
        [UIView animateWithDuration:0.5 animations:^{
            
            _rightView.center = CGPointMake(160, CGRectGetMidY(self.view.bounds));
        } completion:nil];
    } else {
        
        [UIView animateWithDuration:0.5 animations:^{
            
            _rightView.center = CGPointMake(425,  CGRectGetMidY(self.view.bounds));
        } completion:nil];
    }
    _isLeftShow = !_isLeftShow;
}

/**
 *  手势响应事件
 *
 *  @param gesture 手势
 */
- (void)processGestureReconizer:(UIGestureRecognizer *)gesture {
    
    // 如果是拖拽手势
    if ([gesture isKindOfClass:[UIPanGestureRecognizer class]]) {
        
        UIPanGestureRecognizer *pan = (UIPanGestureRecognizer *)gesture;
        
        // 获得位移
        CGPoint translation = [pan translationInView:self.view];
        
        // 如果左侧view已经显示，那拖动时右侧view向右动
        // 如果左侧view还没显示，那拖动时左侧view向左动
        if (_isLeftShow && translation.x <= 0) {
            
            _rightView.frame = CGRectMake(_leftView.bounds.size.width + translation.x, 0, self.view.bounds.size.width, self.view.bounds.size.height);
            
        } else if (!_isLeftShow && translation.x > 0) {
            
            _rightView.frame = CGRectMake(translation.x, 0, self.view.bounds.size.width, self.view.bounds.size.height);
        }
        
        // 当结束拖拽手势时
        if (pan.state == UIGestureRecognizerStateEnded) {
            
            if (_isLeftShow) { // 如果左侧view已经显示
                
                if (translation.x < -140) { // 左滑 < 140就不切换页面
                    
                    [UIView animateWithDuration:0.3 animations:^{
                        
                        _rightView.center = CGPointMake(160,  CGRectGetMidY(self.view.bounds));
                        _isLeftShow = NO;
                    }];
                } else { // 左滑 > 140就切换页面
                    
                    [UIView animateWithDuration:0.3 animations:^{
                        
                        _rightView.center = CGPointMake(425,  CGRectGetMidY(self.view.bounds));
                    }];
                }
            } else { // 如果左侧view还没显示
                
                if (translation.x > 140) { // 右滑 < 140就不切换页面
                    
                    [UIView animateWithDuration:0.3 animations:^{
                        
                        _rightView.center = CGPointMake(425,  CGRectGetMidY(self.view.bounds));
                        _isLeftShow = YES;
                    }];
                } else { // 右滑 < 140就不切换页面
                    
                    [UIView animateWithDuration:0.3 animations:^{
                        
                        _rightView.center = CGPointMake(160,  CGRectGetMidY(self.view.bounds));
                    }];
                }
            }
        }
    }
}

- (void)updateUserInterfaceWithData:(NSDictionary *)data {
    
    [_leftView.tableView reloadData];
}

#pragma mark - UITableViewDataSource methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return _dataSource.count;
}

#pragma mark - UITableViewDelegate methods

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *cellIdentifier = @"SystemCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (!cell) {
        
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier] autorelease];
    }

    cell.textLabel.text = ((PostCategory *)_dataSource[indexPath.row]).categoryName;
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    cell.backgroundColor = [UIColor clearColor];
    cell.textLabel.textColor = [UIColor whiteColor];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    [self hiddenOrShowLeftViewAnimation];
    
    if (indexPath.row == 0) {
        
        _homePageTVC.footerRefreshEnable = YES;
        [_homePageTVC initializeDataSource];
    } else {
        
        _homePageTVC.footerRefreshEnable = NO;
        [_homePageTVC requestPostCategoryByPostCategoryId:((PostCategory *)_dataSource[indexPath.row]).categoryId];
    }
}

@end