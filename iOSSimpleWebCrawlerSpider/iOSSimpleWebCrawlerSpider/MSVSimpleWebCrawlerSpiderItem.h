//
//  MSVSimpleWebCrawlerSpiderItem.h
//  iOSSimpleWebCrawlerSpider
//
//  Created by Serge Moskalenko on 28.04.16.
//  Copyright (c) 2016 Serge Moskalenko. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, MSVSimpleWebCrawlerSpiderItemStatus) {
    MSVSimpleWebCrawlerSpiderItemStatusWait,
    MSVSimpleWebCrawlerSpiderItemStatusInWork,
    MSVSimpleWebCrawlerSpiderItemStatusNotFound,
    MSVSimpleWebCrawlerSpiderItemStatusFound,
    MSVSimpleWebCrawlerSpiderItemStatusError
};


@interface MSVSimpleWebCrawlerSpiderItem : NSObject

@property (nonatomic,strong) NSString* urlString;
@property (nonatomic,strong) NSString* statusError;
@property (nonatomic, assign) MSVSimpleWebCrawlerSpiderItemStatus status;
@property (nonatomic, assign) int numberResult;
@property (nonatomic, assign) int level;

@end
