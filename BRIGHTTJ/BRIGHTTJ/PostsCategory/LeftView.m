//
//  LeftView.m
//  BRIGHTTJ
//
//  Created by rimi on 14-7-18.
//  Copyright (c) 2014年 brighttj. All rights reserved.
//

#import "LeftView.h"

@interface LeftView ()

- (void)initializeUserInterface;
- (void)buttonPressed:(UIButton *)sender;

@end

@implementation LeftView

- (void)dealloc {
    
    [_tableView release];
    [super dealloc];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        
        [self initializeUserInterface];
    }
    return self;
}

- (void)initializeUserInterface {
    
    UIImage *footerImage = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForAuxiliaryExecutable:@"background_footer.jpg"]];
    self.backgroundColor = [UIColor colorWithPatternImage:footerImage];
    
    UIImage *titleImage = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForAuxiliaryExecutable:@"background_title.jpg"]];
    UIImageView *borderImageView = [[UIImageView alloc] initWithImage:titleImage];
    borderImageView.bounds = CGRectMake(0, 0, 140, 140);
    borderImageView.center = CGPointMake(CGRectGetWidth(self.bounds) / 2, 120);
    borderImageView.backgroundColor = [UIColor clearColor];
    borderImageView.clipsToBounds = YES;
    borderImageView.layer.borderWidth = 4;
    borderImageView.layer.borderColor = [[UIColor colorWithRed:(0/255.0) green:(0/255.0) blue:(0/255.0) alpha:0.7] CGColor];
    borderImageView.layer.cornerRadius = 70;
    [self addSubview:borderImageView];
    [borderImageView release];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    button.bounds = CGRectMake(0, 0, 140, 140);
    button.center = CGPointMake(CGRectGetWidth(self.bounds) / 2, 120);
    button.backgroundColor = [UIColor clearColor];
    button.clipsToBounds = YES;
    button.layer.cornerRadius = 70;
    [button addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:button];
    
    UIImage *logoImage = [[UIImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForAuxiliaryExecutable:@"icon.png"]];
    UIImageView *logoImageView = [[UIImageView alloc] initWithImage:logoImage];
    [logoImage release];
    logoImageView.bounds = CGRectMake(0, 0, 100, 100);
    logoImageView.center = CGPointMake(CGRectGetWidth(self.bounds) / 2, 120);
    [self addSubview:logoImageView];
    [logoImageView release];
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 280, self.bounds.size.width, self.bounds.size.height - 280) style:UITableViewStylePlain];
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.separatorColor = [UIColor colorWithRed:(100/255.0) green:(100/255.0) blue:(100/255.0) alpha:0.7];
    [self addSubview:_tableView];
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.bounds = CGRectMake(0, 0, 90, 40);
    titleLabel.center = CGPointMake(CGRectGetMidX(self.bounds), 230);
    titleLabel.text = @"分类目录";
    titleLabel.font = [UIFont systemFontOfSize:20];
    titleLabel.textColor = [UIColor whiteColor];
    [self addSubview:titleLabel];
    [titleLabel release];
}

- (void)buttonPressed:(UIButton *)sender {
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://www.brighttj.com"]];
}

@end