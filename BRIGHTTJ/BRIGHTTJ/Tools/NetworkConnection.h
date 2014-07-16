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

@property (nonatomic, assign) id<NetworkConnectionDelegate> delegate;
@property (nonatomic, retain) NSString *urlString;

- (void)asynchronousPOSTRequertWithParameters:(NSDictionary *)paramters;

@end