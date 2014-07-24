//
//  CustomTableViewCell.h
//  BRIGHTTJ
//
//  Created by rimi on 14-7-16.
//  Copyright (c) 2014年 brighttj. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomTableViewCell : UITableViewCell


@property (nonatomic, retain) UILabel *titleLabel; //to show post title text
@property (nonatomic, retain) UILabel *authorLabel; //to show post author text
@property (nonatomic, retain) UILabel *dateLabel; //to show post date text

@end