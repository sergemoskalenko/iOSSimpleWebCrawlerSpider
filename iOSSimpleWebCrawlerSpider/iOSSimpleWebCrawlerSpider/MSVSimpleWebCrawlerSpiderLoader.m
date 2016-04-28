//
//  MSVSimpleWebCrawlerSpiderLoader.m
//  iOSSimpleWebCrawlerSpider
//
//  Created by Serge Moskalenko on 28.04.16.
//  Copyright (c) 2016 Serge Moskalenko. All rights reserved.
//

#import "MSVSimpleWebCrawlerSpiderLoader.h"

@interface MSVSimpleWebCrawlerSpiderLoader()
@property (nonatomic, strong) NSOperationQueue *operationQueue;
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
        _operationQueue = [[NSOperationQueue alloc] init];
        _operationQueue.maxConcurrentOperationCount = 3;
    }
    return self;
}

- (void)addRequest:(NSURLRequest *)request withHandler:(MSVSimpleWebCrawlerSpiderLoaderHandler)requestHandler
{
    NSBlockOperation *operation = [NSBlockOperation blockOperationWithBlock:^{
        
        NSURLSession *session = [NSURLSession sharedSession];
        NSURLSessionDataTask *task = [session dataTaskWithRequest:request
                                                completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                    requestHandler(response, data, error);
                                                }];
        [task resume];
    }];
    [_operationQueue addOperation:operation];
}

@end
