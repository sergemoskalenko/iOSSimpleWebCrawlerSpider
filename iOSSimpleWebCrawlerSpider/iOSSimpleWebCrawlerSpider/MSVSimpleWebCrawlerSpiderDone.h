//
//  MSVSimpleWebCrawlerSpiderDone.h
//  iOSSimpleWebCrawlerSpider
//
//  Created by Serge Moskalenko on 28.04.16.
//  Copyright (c) 2016 Serge Moskalenko. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MSVSimpleWebCrawlerSpiderDone : NSObject

@property (nonatomic, weak) id delegate;

- (void)done;

@end
