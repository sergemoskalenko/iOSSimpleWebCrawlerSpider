//
//  MSVSimpleWebCrawlerSpiderSeachSettings.m
//  iOSSimpleWebCrawlerSpider
//
//  Created by Serge Moskalenko on 28.04.16.
//  Copyright (c) 2016 Serge Moskalenko. All rights reserved.
//

#import "MSVSimpleWebCrawlerSpiderSeachSettings.h"

@implementation MSVSimpleWebCrawlerSpiderSeachSettings

- (void)setUrlStartString:(NSString *)urlStartString
{
    // test & correct if need
    _urlStartString = urlStartString;
}

- (void)setSearchedString:(NSString *)searchedString
{
    // test & correct if need
    _searchedString = searchedString;
}

- (void)setMaxResults:(int)maxResults
{
    int value = maxResults;
    if (value > 500)
        value = 500;
    if (value < 1)
        value = 1;

    _maxResults = value;
}

- (void)setMaxDeep:(int)maxDeep
{
    int value = maxDeep;
    if (value > 5)
        value = 5;
    if (value < 1)
        value = 1;
    
    _maxDeep = value;
}

- (void)setMaxFlow:(int)maxFlow
{
    int value = maxFlow;
    if (value > 8)
        value = 8;
    if (value < 1)
        value = 1;
    
    _maxFlow = value;
}

@end
