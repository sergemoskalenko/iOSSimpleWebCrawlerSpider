//
//  MSVSimpleWebCrawlerSpiderSeachSettings.h
//  iOSSimpleWebCrawlerSpider
//
//  Created by Serge Moskalenko on 28.04.16.
//  Copyright (c) 2016 Serge Moskalenko. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MSVSimpleWebCrawlerSpiderSeachSettings : NSObject

@property (nonatomic,strong) NSString* urlStartString;
@property (nonatomic,strong) NSString* searchedString;

@property (nonatomic, assign) int maxResults;
@property (nonatomic, assign) int maxDeep;
@property (nonatomic, assign) int maxFlow;

@end
