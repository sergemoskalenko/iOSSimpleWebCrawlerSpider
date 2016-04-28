//
//  MSVSimpleWebCrawlerSpiderLevelManager.h
//  iOSSimpleWebCrawlerSpider
//
//  Created by Serge Moskalenko on 28.04.16.
//  Copyright (c) 2016 Serge Moskalenko. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MSVSimpleWebCrawlerSpiderLevelManager : NSObject

@property (nonatomic, strong, readonly) NSOperationQueue *operationQueue;
@property (nonatomic, assign) int maxLevel;
@property (nonatomic, weak) id delegate;


- (void)runLevels:(int)maxLevel;

@end
