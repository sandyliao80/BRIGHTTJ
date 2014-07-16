//
//  HomePageTableViewController.m
//  IOS_27_Brighttj
//
//  Created by rimi on 14-7-16.
//  Copyright (c) 2014年 brighttj. All rights reserved.
//

#import "HomePageTableViewController.h"

@interface HomePageTableViewController ()

- (void)initializeUserInterface;

@end

@implementation HomePageTableViewController

- (id)init {
    
    self = [super init];
    
    if (self) {
        
        self.title = @"BRIGHTTJ";
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initializeUserInterface];
}

- (void)initializeUserInterface {
    
    
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    // Return the number of sections.
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    // Return the number of rows in the section.
    return 0;
}

@end
