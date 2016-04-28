//
//  MSVSimpleWebCrawlerSpiderModel.h
//  iOSSimpleWebCrawlerSpider
//
//  Created by Serge Moskalenko on 28.04.16.
//  Copyright (c) 2016 Serge Moskalenko. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MSVSimpleWebCrawlerSpiderSeachSettings.h"
#import "MSVSimpleWebCrawlerSpiderCurrentInfo.h"
#import "MSVSimpleWebCrawlerSpiderItem.h"



typedef NS_ENUM(NSInteger, MSVSimpleWebCrawlerSpiderCurrentStatus) {
    MSVSimpleWebCrawlerSpiderCurrentStatusNone,
    MSVSimpleWebCrawlerSpiderCurrentStatusInWork,
    MSVSimpleWebCrawlerSpiderCurrentStatusSuspended,
    MSVSimpleWebCrawlerSpiderCurrentStatusStopped,
    MSVSimpleWebCrawlerSpiderCurrentStatusDone
    
};


@interface MSVSimpleWebCrawlerSpiderModel : NSObject

@property (nonatomic, strong) MSVSimpleWebCrawlerSpiderSeachSettings* searchSettings;
@property (nonatomic, strong) MSVSimpleWebCrawlerSpiderCurrentInfo* currentInfo;

@property (nonatomic, strong, readonly) NSMutableDictionary* itemsDic;
@property (nonatomic, strong, readonly) NSMutableArray* items;
@property (nonatomic, assign, readonly) MSVSimpleWebCrawlerSpiderCurrentStatus currentStatus;
@property (nonatomic, weak) id delegate;

+ (instancetype)sharedModel;
- (NSArray *)itemsArrayForLevel:(int)level;
- (void)appendItem:(MSVSimpleWebCrawlerSpiderItem *)item;
- (void)appendItemWithURLString:(NSString *)urlString level:(int)level;

- (void)start;
- (void)pause;
- (void)resume;
- (void)stop;

- (void)doneLevels;

@end
