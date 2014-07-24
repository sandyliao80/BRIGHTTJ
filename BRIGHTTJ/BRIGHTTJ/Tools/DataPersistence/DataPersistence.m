//
//  DataPersistence.m
//  BRIGHTTJ
//
//  Created by rimi on 14-7-23.
//  Copyright (c) 2014年 brighttj. All rights reserved.
//

#import "DataPersistence.h"

#define POSTS_LIST_PATH @"postsList.plist"
#define POST_FINDER @"post_finder"

@implementation DataPersistence

#pragma mark - Manage posts list

+ (void)savePostsList:(NSArray *)posts {
    
    NSMutableArray *postsList = nil;
    
    NSString *documentDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *plistPath = [documentDirectory stringByAppendingPathComponent:POSTS_LIST_PATH];
    
    for (Post *post in posts) {
        
        // 归档/编码
        NSData *data = [NSKeyedArchiver archivedDataWithRootObject:post];
        
        // 把属性列表文件读到内存中
        // 获取文件在沙盒中的路径
        
        postsList = [NSMutableArray arrayWithArray:[NSMutableArray arrayWithContentsOfFile:plistPath]];
        // 添加第一条数据
        [postsList addObject:data];
        
        // 更新文件系统
        BOOL success = [postsList writeToFile:plistPath atomically:YES];
        NSAssert(success, @"save operation did failed.");
    }
}

+ (void)deleteAllPostsList {
    
    [self deleteFileWithPath:POSTS_LIST_PATH];
}

+ (void)deleteFileWithPath:(NSString *)filePath {
    
    // 获取文件路径
    NSString *documentDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *plistPaht = [documentDirectory stringByAppendingPathComponent:filePath];
    
    NSFileManager *manager = [NSFileManager defaultManager];
    // 判断文件是否存在
    if ([manager fileExistsAtPath:plistPaht]) {
        
        NSError *error = nil;
        BOOL success = [manager removeItemAtPath:plistPaht error:&error];
        NSAssert(success, @"remove operation did failed.");
    }
}

+ (NSMutableArray *)readPostsList {
    
    // 获取文件路径
    NSString *documentDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *plistPath = [documentDirectory stringByAppendingPathComponent:POSTS_LIST_PATH];
    // 获取列表
    NSMutableArray *postData = [NSMutableArray arrayWithArray:[NSMutableArray arrayWithContentsOfFile:plistPath]];
    NSMutableArray *postsList = [NSMutableArray array];
    // NSData解码
    for (NSData *data in postData) {
        
        Post *post = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        [postsList addObject:post];
    }
    return postsList;
}

#pragma mark - Manage post content

+ (void)savePostContent:(Post *)post {
    
    NSString *tempDirectory = NSTemporaryDirectory();
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *testDirectory = [tempDirectory stringByAppendingPathComponent:POST_FINDER];
    // 创建目录
    [fileManager createDirectoryAtPath:testDirectory withIntermediateDirectories:YES attributes:nil error:nil];
    
    NSString *postPath = [testDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.txt", post.postID]];
    // 读入文件
    if (![fileManager fileExistsAtPath:postPath]) {
        
        // 写入
        [fileManager createFileAtPath:postPath contents:[post.postContent  dataUsingEncoding:NSUTF8StringEncoding] attributes:nil];
    }
}

+ (NSString *)readPostContentWithPostId:(NSString *)postId {
    
    NSString *tempDirectory = NSTemporaryDirectory();
    NSString *testDirectory = [tempDirectory stringByAppendingPathComponent:POST_FINDER];
    NSString *postPath = [testDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.txt", postId]];
    
    NSError *error = nil;
    NSString *postContent = [NSString stringWithFormat:@"%@", [NSString stringWithContentsOfFile:postPath encoding:NSUTF8StringEncoding error:&error]];
    
    if (error) {
        
        NSLog(@"read post content failed with message '%@'", [error localizedDescription]);
    }
    
    return postContent;
}

+ (void)deleteAllPosts {
    
    // 获取文件路径
    NSString *tempDirectory = NSTemporaryDirectory();
    NSString *testDirectory = [tempDirectory stringByAppendingPathComponent:POST_FINDER];
    
    NSFileManager *manager = [NSFileManager defaultManager];
    // 判断文件是否存在
    if ([manager fileExistsAtPath:testDirectory]) {
        
        NSError *error = nil;
        BOOL success = [manager removeItemAtPath:testDirectory error:&error];
        NSAssert(success, @"remove operation did failed.");
    }
}

@end