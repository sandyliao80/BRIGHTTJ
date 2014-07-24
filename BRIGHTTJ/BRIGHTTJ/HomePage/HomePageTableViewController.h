//
//  HomePageTableViewController.h
//  IOS_27_Brighttj
//
//  Created by rimi on 14-7-16.
//  Copyright (c) 2014年 brighttj. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HomePageTableViewController : UITableViewController {
    
    BOOL _footerRefreshEnable;
}

@property (nonatomic, assign) BOOL footerRefreshEnable;

- (void)initializeDataSource;
- (void)requestPostCategoryByPostCategoryId:(NSString *)postCategoryId;

@end