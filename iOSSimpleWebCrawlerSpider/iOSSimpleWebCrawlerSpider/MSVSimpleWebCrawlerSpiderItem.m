//
//  MSVSimpleWebCrawlerSpiderItem.m
//  iOSSimpleWebCrawlerSpider
//
//  Created by Serge Moskalenko on 28.04.16.
//  Copyright (c) 2016 Serge Moskalenko. All rights reserved.
//

#import "MSVSimpleWebCrawlerSpiderItem.h"

@implementation MSVSimpleWebCrawlerSpiderItem

- (instancetype)init
{
    if (self = [super init]) {
        _status = MSVSimpleWebCrawlerSpiderItemStatusWait;
        _statusError = nil;
    }
    return self;
}

@end
