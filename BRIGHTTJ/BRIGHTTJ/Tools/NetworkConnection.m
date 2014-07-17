//
//  NetworkConnection.m
//  IOS_27_Brighttj
//
//  Created by rimi on 14-7-16.
//  Copyright (c) 2014年 brighttj. All rights reserved.
//

/*
 
 network connection logical code.
 
 */

#import "NetworkConnection.h"

@interface NetworkConnection () <NSURLConnectionDataDelegate> {
    
    NSMutableData *_responseData; //
}

- (NSURLRequest *)POSTURLRequest;
- (id)JSONObjectWithData:(NSData *)data;

@end

@implementation NetworkConnection

/**
 *  rewrite init method
 *
 *  @return already initializied object
 */
- (id)init {
    
    self = [super init];
    
    if (self) {
        
        // init _resopnseData
        _responseData = [[NSMutableData alloc] init];
    }
    
    return self;
}

- (void)dealloc {
    
    [_responseData release];
    [_urlString release];
    [super dealloc];
}

/**
 *  asynchronous request with post method
 */
- (void)asynchronousPOSTRequert {
    
    [NSURLConnection connectionWithRequest:[self POSTURLRequest] delegate:self];
}

/**
 *  config post request
 *
 *  @return already configed post request
 */
- (NSURLRequest *)POSTURLRequest {
    
    NSURL *url = [NSURL URLWithString:_urlString];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    request.HTTPMethod = @"POST";
    request.timeoutInterval = 10;
    
    // if post data is not nil, set http body
    if (!self.postData) {
        
        // initialize httpBodyString
        NSMutableString *httpBodyString = [NSMutableString string];
        for (NSString *key in self.postData) {
            
            [httpBodyString appendFormat:@"%@=%@&", key, [self.postData objectForKey:key]];
        }
        request.HTTPBody = [httpBodyString dataUsingEncoding:NSUTF8StringEncoding];
    }
    return request;
}

/**
 *  serialize date to json
 *
 *  @param data : the data who would serialize to json (response data)
 *
 *  @return json
 */
- (id)JSONObjectWithData:(NSData *)data {
    
    if (data.length == 0) {
        
        return nil;
    }
    NSError *error = nil;
    id object = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&error];
    return object;
}

#pragma mark - NSURLConnectionDataDelegate methods

/**
 *  trigger this event when response data received
 *
 *  @param connection : network connection
 *  @param data       : response data
 */
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    
    // initialize data buffer zone
    if (!_responseData) {
        
        _responseData = [[NSMutableData alloc] init];
    }
    // append data
    [_responseData appendData:data];
}

/**
 *  trigger this event when connection did finish loading
 *
 *  @param connection : network connection
 */
- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    
    // serilaize data to json
    id object = [self JSONObjectWithData:_responseData];
    // reset response data
    _responseData.length = 0;
    // update user interface with response data
    [self.delegate updateUserInterfaceWithData:object];
}

@end