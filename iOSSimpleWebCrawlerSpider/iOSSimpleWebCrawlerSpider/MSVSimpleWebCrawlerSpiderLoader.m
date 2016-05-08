//
//  MSVSimpleWebCrawlerSpiderLoader.m
//  iOSSimpleWebCrawlerSpider
//
//  Created by Serge Moskalenko on 28.04.16.
//  Copyright (c) 2016 Serge Moskalenko. All rights reserved.
//

#import "MSVSimpleWebCrawlerSpiderLoader.h"

@interface MSVSimpleWebCrawlerSpiderLoader()
@property (nonatomic, weak) NSOperationQueue *operationQueue;
@property (nonatomic, weak) NSURLSession* session;
@end


@implementation MSVSimpleWebCrawlerSpiderLoader


+ (instancetype)sharedLoader
{
    static MSVSimpleWebCrawlerSpiderLoader *loader = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        loader = [[MSVSimpleWebCrawlerSpiderLoader alloc] init];
    });
    return loader;
}


- (instancetype)init
{
    if (self = [super init]) {
        _session = [NSURLSession sharedSession];
        _operationQueue = _session.delegateQueue;
        _operationQueue.maxConcurrentOperationCount = 3;
    }
    return self;
}

- (void)addRequest:(NSURLRequest *)request withHandler:(MSVSimpleWebCrawlerSpiderLoaderHandler)requestHandler
{
        NSURLSessionDataTask *task = [_session dataTaskWithRequest:request
                                                completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                    requestHandler(response, data, error);
                                                }];
        [task resume];
}

@end
