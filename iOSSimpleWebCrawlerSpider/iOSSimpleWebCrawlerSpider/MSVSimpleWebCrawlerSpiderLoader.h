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

@property (nonatomic, strong, readonly) NSOperationQueue *operationQueue;

+ (instancetype)sharedLoader;
- (void)addRequest:(NSURLRequest *)request withHandler:(MSVSimpleWebCrawlerSpiderLoaderHandler)requestHandler;

@end
