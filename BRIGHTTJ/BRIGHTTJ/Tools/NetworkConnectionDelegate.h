//
//  NetworkConnectionDelegate.h
//  BRIGHTTJ
//
//  Created by rimi on 14-7-16.
//  Copyright (c) 2014年 brighttj. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol NetworkConnectionDelegate <NSObject>

- (void)updateUserInterfaceWithData:(NSDictionary *)data;

@end
