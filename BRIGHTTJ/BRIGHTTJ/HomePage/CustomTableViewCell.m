//
//  CustomTableViewCell.m
//  BRIGHTTJ
//
//  Created by rimi on 14-7-16.
//  Copyright (c) 2014年 brighttj. All rights reserved.
//

/*
 
 custom cell style user interface.
 
 */

#import "CustomTableViewCell.h"

@interface CustomTableViewCell ()

- (void)initializeTableCell;

@end

@implementation CustomTableViewCell

- (void)dealloc {
    
    [_viewsLabel release];
    [_titleLabel release];
    [_authorLabel release];
    [_dateLabel release];
    [super dealloc];
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        // initialize table cell
        [self initializeTableCell];
    }
    return self;
}

/**
 *  initialize table cell style
 */
- (void)initializeTableCell {
    
    // config _titleLabel
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 5, 260, 50)];
    _titleLabel.font = [UIFont systemFontOfSize:16];
    _titleLabel.numberOfLines = 0;
    _titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    _titleLabel.textColor = [UIColor blackColor];
    [self.contentView addSubview:_titleLabel];
    
    // config post author image
    UIImage *postAuthorImage = [UIImage imageNamed:@"post_author"];
    UIImageView *postAuthorImageView = [[UIImageView alloc] initWithImage:postAuthorImage];
    postAuthorImageView.frame = CGRectMake(33, 59, 12, 12);
    [self.contentView addSubview:postAuthorImageView];
    [postAuthorImageView release];
    
    // config _auhtorLabel
    _authorLabel = [[UILabel alloc] initWithFrame:CGRectMake(50, 60, 100, 10)];
    _authorLabel.font = [UIFont systemFontOfSize:12];
    _authorLabel.textColor = [UIColor lightGrayColor];
    [self.contentView addSubview:_authorLabel];
    
    // config post views image
    UIImage *postViewsImage = [UIImage imageNamed:@"post_views"];
    UIImageView *postViewsImageView = [[UIImageView alloc] initWithImage:postViewsImage];
    postViewsImageView.frame = CGRectMake(113, 60, 12, 12);
    [self.contentView addSubview:postViewsImageView];
    [postViewsImageView release];
    
    // config _viewsLabel
    _viewsLabel = [[UILabel alloc] initWithFrame:CGRectMake(130, 60, 100, 10)];
    _viewsLabel.font = [UIFont systemFontOfSize:12];
    _viewsLabel.textColor = [UIColor lightGrayColor];
    [self.contentView addSubview:_viewsLabel];
    
    // config post date image
    UIImage *postDateImage = [UIImage imageNamed:@"post_date"];
    UIImageView *postfateImageView = [[UIImageView alloc] initWithImage:postDateImage];
    postfateImageView.frame = CGRectMake(183, 60, 12, 12);
    [self.contentView addSubview:postfateImageView];
    [postfateImageView release];
    
    // config _dateLabel
    _dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(200, 60, 100, 10)];
    _dateLabel.font = [UIFont systemFontOfSize:12];
    _dateLabel.textColor = [UIColor lightGrayColor];
    [self.contentView addSubview:_dateLabel];
    
    // set separator edge with zero
    self.separatorInset = UIEdgeInsetsZero;
    // set asscessory type with disclosure indicator
    self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end