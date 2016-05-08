//
//  MSVSimpleWebCrawlerSpiderLevelManager.m
//  iOSSimpleWebCrawlerSpider
//
//  Created by Serge Moskalenko on 28.04.16.
//  Copyright (c) 2016 Serge Moskalenko. All rights reserved.
//

#import "MSVSimpleWebCrawlerSpiderLevelManager.h"
#import "MSVSimpleWebCrawlerSpiderModel.h"
#import "MSVSimpleWebCrawlerSpiderLevel.h"
#import "MSVSimpleWebCrawlerSpiderDone.h"
#import "MSVSimpleWebCrawlerSpiderLoader.h"

@interface MSVSimpleWebCrawlerSpiderLevelManager()
@property (nonatomic, strong) NSOperationQueue *operationQueue;
@end


@implementation MSVSimpleWebCrawlerSpiderLevelManager


- (instancetype)init
{
    if (self = [super init]) {
        _operationQueue = [[NSOperationQueue alloc] init];
        _operationQueue.maxConcurrentOperationCount = 1;
    }
    return self;
}

- (void)runLevels:(int)maxLevel
{
    __weak MSVSimpleWebCrawlerSpiderLevelManager* weakSelf = self;
    
    NSBlockOperation *operationOld = nil;
    
    for (int i = 1; i < maxLevel + 1; i++)
    {
        NSBlockOperation *operation = [NSBlockOperation blockOperationWithBlock:^{
            MSVSimpleWebCrawlerSpiderLevel* oneLevel = [[MSVSimpleWebCrawlerSpiderLevel alloc] init];
            oneLevel.delegate = weakSelf.delegate;
            oneLevel.operationQueue = weakSelf.operationQueue;
            [oneLevel runLevel:i];
        }];
        
        if (operationOld)
            [operation addDependency:operationOld];
        operationOld = operation;
        
        [_operationQueue addOperation:operation];
    }
    
    NSBlockOperation *operation = [NSBlockOperation blockOperationWithBlock:^{
        [[MSVSimpleWebCrawlerSpiderModel sharedModel] performSelectorOnMainThread:@selector(doneLevels) withObject:nil waitUntilDone:NO];
        // [[MSVSimpleWebCrawlerSpiderModel sharedModel] doneLevels];
        [MSVSimpleWebCrawlerSpiderModel sharedModel].currentInfo.flowCount = 0;
    }];
    if (operationOld)
        [operation addDependency:operationOld];
    [_operationQueue addOperation:operation];
}

@end
