//
//  NetworkConnection.m
//  IOS_27_Brighttj
//
//  Created by rimi on 14-7-16.
//  Copyright (c) 2014年 brighttj. All rights reserved.
//

#import "NetworkConnection.h"

@interface NetworkConnection () <NSURLConnectionDataDelegate> {
    
    NSMutableData *_responseData;
}

@end

@implementation NetworkConnection

+ (NSURLRequest *)POSTURLRequestWithParameters:(NSDictionary *)parameters urlWithString:(NSString *)string {
    
    NSLog(@"--->2");
    NSURL *url = [NSURL URLWithString:string];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    request.HTTPMethod = @"POST";
    request.timeoutInterval = 10;
    return request;
}

+ (id)JSONObjectWithData:(NSData *)data {
    
    if (data.length == 0) {
        
        return nil;
    }
    NSError *error = nil;
    id object = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&error];
    return object;
}

@end