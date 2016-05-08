//
//  MSVSimpleWebCrawlerSpiderModel.m
//  iOSSimpleWebCrawlerSpider
//
//  Created by Serge Moskalenko on 28.04.16.
//  Copyright (c) 2016 Serge Moskalenko. All rights reserved.
//

#import "MSVSimpleWebCrawlerSpiderModel.h"
#import "MSVSimpleWebCrawlerSpiderItem.h"
#import "MSVSimpleWebCrawlerSpiderLevelManager.h"
#import "MSVSimpleWebCrawlerSpiderLoader.h"


@interface MSVSimpleWebCrawlerSpiderModel()
@property (nonatomic, strong) NSMutableDictionary* itemsDic;
@property (nonatomic, strong) NSMutableArray* items;
@property (nonatomic, strong) MSVSimpleWebCrawlerSpiderLevelManager* levelManager;
@property (nonatomic, assign) BOOL levelOperationSuspended;

@end

@implementation MSVSimpleWebCrawlerSpiderModel


+ (instancetype)sharedModel
{
    static MSVSimpleWebCrawlerSpiderModel *shared = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shared = [[MSVSimpleWebCrawlerSpiderModel alloc] init];
    });
    return shared;
}


- (id)init
{
    if (self = [super init])
    {
        _searchSettings = [MSVSimpleWebCrawlerSpiderSeachSettings new];
        _currentInfo = [MSVSimpleWebCrawlerSpiderCurrentInfo new];
        _itemsDic = [NSMutableDictionary new];
        _items = [NSMutableArray array];
        self.currentStatus = MSVSimpleWebCrawlerSpiderCurrentStatusNone;
    }
    
    return self;
}



- (NSArray *)itemsArrayForLevel:(int)level
{
    NSMutableArray* result = [NSMutableArray array];
    
    for (MSVSimpleWebCrawlerSpiderItem* item in self.items)
    {
        if (item.level == level)
            [result addObject:item];
    }
    
    return result;
}

- (void)appendItem:(MSVSimpleWebCrawlerSpiderItem *)item
{
    @synchronized(_items)
    {
        if (_items.count < _searchSettings.maxResults)
        {
            BOOL notExists = YES;
            NSString* urlString = item.urlString;
            for (MSVSimpleWebCrawlerSpiderItem* item in self.items)
            {
                if ([item.urlString isEqualToString:urlString])
                {
                    notExists = NO;
                    break;
                }
            }

            if (notExists)
                [_items addObject:item];
        }
    }
}

- (void)appendItemWithURLString:(NSString *)urlString level:(int)level
{
    MSVSimpleWebCrawlerSpiderItem* item = [MSVSimpleWebCrawlerSpiderItem new];
    item.urlString = urlString;
    item.level = level;
    [self appendItem:item];

}

#pragma martk - Actions


- (void)start
{
    if (_currentStatus == MSVSimpleWebCrawlerSpiderCurrentStatusNone || _currentStatus == MSVSimpleWebCrawlerSpiderCurrentStatusStopped || _currentStatus == MSVSimpleWebCrawlerSpiderCurrentStatusDone )
    {
     
        [MSVSimpleWebCrawlerSpiderLoader sharedLoader].operationQueue.maxConcurrentOperationCount = self.searchSettings.maxFlow;
        
        self.currentInfo.viewCount = 0;
        self.currentInfo.foundCount = 0;
        
        [_items removeAllObjects];
        MSVSimpleWebCrawlerSpiderItem* item = [MSVSimpleWebCrawlerSpiderItem new];
        item.urlString = self.searchSettings.urlStartString;
        item.level = 1;
        [_items addObject:item];
        
        _levelManager = [MSVSimpleWebCrawlerSpiderLevelManager new];
        _levelManager.delegate = _delegate;
        [_levelManager runLevels:self.searchSettings.maxDeep];
        
        self.currentStatus = MSVSimpleWebCrawlerSpiderCurrentStatusInWork;
    }
}

- (void)pause
{
    [MSVSimpleWebCrawlerSpiderLoader sharedLoader].operationQueue.suspended = YES;
    _levelOperationSuspended = _levelManager.operationQueue.suspended;
    _levelManager.operationQueue.suspended = YES;
    
    self.currentStatus = MSVSimpleWebCrawlerSpiderCurrentStatusSuspended;

}

- (void)resume
{
    [MSVSimpleWebCrawlerSpiderLoader sharedLoader].operationQueue.maxConcurrentOperationCount = self.searchSettings.maxFlow;
    
    [MSVSimpleWebCrawlerSpiderLoader sharedLoader].operationQueue.suspended = NO;
    _levelManager.operationQueue.suspended = _levelOperationSuspended;
    
    self.currentStatus = MSVSimpleWebCrawlerSpiderCurrentStatusInWork;

}

- (void)stop
{
    _searchSettings.maxFlow = 0;
    [_levelManager.operationQueue cancelAllOperations];
    [[MSVSimpleWebCrawlerSpiderLoader sharedLoader].operationQueue cancelAllOperations];
    
    self.currentStatus = MSVSimpleWebCrawlerSpiderCurrentStatusStopped;

}

- (void)doneLevels
{
    [MSVSimpleWebCrawlerSpiderModel sharedModel].currentInfo.flowCount = 0;
    self.currentStatus = MSVSimpleWebCrawlerSpiderCurrentStatusDone;
    [_delegate performSelectorOnMainThread:@selector(downloadedItem) withObject:nil waitUntilDone:NO];
}

#pragma mark -

- (void)setCurrentStatus:(MSVSimpleWebCrawlerSpiderCurrentStatus)currentStatus
{
    [self willChangeValueForKey:@"currentStatus"];
    _currentStatus = currentStatus;
    [self didChangeValueForKey:@"currentStatus"];
    
}

@end
