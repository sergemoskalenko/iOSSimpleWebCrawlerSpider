//
//  MSVSimpleWebCrawlerSpiderLoader.h
//  iOSSimpleWebCrawlerSpider
//
//  Created by Serge Moskalenko on 28.04.16.
//  Copyright (c) 2016 Serge Moskalenko. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^MSVSimpleWebCrawlerSpiderLoaderHandler)(NSURLResponse *response, NSData *data, NSError *error);

@interface MSVSimpleWebCrawlerSpiderLoader : NSObject

@property (nonatomic, weak, readonly) NSOperationQueue *operationQueue;
@property (nonatomic, weak, readonly) NSURLSession* session;

+ (instancetype)sharedLoader;
- (void)addRequest:(NSURLRequest *)request withHandler:(MSVSimpleWebCrawlerSpiderLoaderHandler)requestHandler;

@end
