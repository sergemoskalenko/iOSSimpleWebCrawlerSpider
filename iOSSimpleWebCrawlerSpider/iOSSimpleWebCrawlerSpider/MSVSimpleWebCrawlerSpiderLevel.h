//
//  MSVSimpleWebCrawlerSpiderLevel.h
//  iOSSimpleWebCrawlerSpider
//
//  Created by Serge Moskalenko on 28.04.16.
//  Copyright (c) 2016 Serge Moskalenko. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MSVSimpleWebCrawlerSpiderLevel : NSObject

@property (nonatomic, weak) NSOperationQueue *operationQueue;
@property (nonatomic, weak) id delegate;
@property (nonatomic, assign) NSUInteger requestsCount;

- (void)runLevel:(int)level;

@end
