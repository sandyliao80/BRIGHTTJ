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

- (NSURLRequest *)POSTURLRequestWithParameters:(NSDictionary *)parameters;
- (id)JSONObjectWithData:(NSData *)data;

@end

@implementation NetworkConnection

- (id)init {
    
    self = [super init];
    
    if (self) {
        
        _responseData = [[NSMutableData alloc] init];
    }
    
    return self;
}

- (void)dealloc {
    
    [_responseData release];
    [_urlString release];
    [super dealloc];
}

- (void)asynchronousPOSTRequertWithParameters:(NSDictionary *)paramters {
    
    [NSURLConnection connectionWithRequest:[self POSTURLRequestWithParameters:nil] delegate:self];
}

- (NSURLRequest *)POSTURLRequestWithParameters:(NSDictionary *)parameters {
    
    NSURL *url = [NSURL URLWithString:_urlString];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    request.HTTPMethod = @"POST";
    request.timeoutInterval = 10;
    return request;
}

- (id)JSONObjectWithData:(NSData *)data {
    
    if (data.length == 0) {
        
        return nil;
    }
    NSError *error = nil;
    id object = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&error];
    return object;
}

#pragma mark - NSURLConnectionDataDelegate methods

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    
    // 初始化缓冲区
    if (!_responseData) {
        
        _responseData = [[NSMutableData alloc] init];
    }
    // 拼接数据
    [_responseData appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    
    id object = [self JSONObjectWithData:_responseData];
    _responseData.length = 0;
    [self.delegate updateUserInterfaceWithData:object];
}

@end