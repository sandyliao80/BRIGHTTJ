//
//  NetworkConnection.h
//  IOS_27_Brighttj
//
//  Created by rimi on 14-7-16.
//  Copyright (c) 2014年 brighttj. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NetworkConnectionDelegate.h"

@interface NetworkConnection : NSObject

@property (nonatomic, assign) id<NetworkConnectionDelegate> delegate; // NetworkConnecionDelegate
@property (nonatomic, retain) NSString *urlString; // request url string
@property (nonatomic, retain) NSDictionary *postData; // post data

- (void)asynchronousPOSTRequert; // send request with post method

@end