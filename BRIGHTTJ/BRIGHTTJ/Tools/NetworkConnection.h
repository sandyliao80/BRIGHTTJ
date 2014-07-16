//
//  NetworkConnection.h
//  IOS_27_Brighttj
//
//  Created by rimi on 14-7-16.
//  Copyright (c) 2014年 brighttj. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NetworkConnection : NSObject

+ (NSURLRequest *)POSTURLRequestWithParameters:(NSDictionary *)parameters urlWithString:(NSString *)string;
+ (id)JSONObjectWithData:(NSData *)data;

@end
