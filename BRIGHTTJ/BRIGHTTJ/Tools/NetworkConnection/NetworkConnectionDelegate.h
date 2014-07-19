//
//  NetworkConnectionDelegate.h
//  BRIGHTTJ
//
//  Created by rimi on 14-7-16.
//  Copyright (c) 2014年 brighttj. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol NetworkConnectionDelegate <NSObject>

// trigger this event when network connection finish loading
// to notify requester connection did finish loading and send response data
- (void)recevieResponseData:(NSDictionary *)data;

@end