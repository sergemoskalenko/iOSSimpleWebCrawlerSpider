//
//  MSVSimpleWebCrawlerSpiderDone.m
//  iOSSimpleWebCrawlerSpider
//
//  Created by Serge Moskalenko on 28.04.16.
//  Copyright (c) 2016 Serge Moskalenko. All rights reserved.
//

#import "MSVSimpleWebCrawlerSpiderDone.h"

@implementation MSVSimpleWebCrawlerSpiderDone

- (void)done
{
    if ([_delegate respondsToSelector:@selector(doneLevels)])
        [_delegate performSelectorOnMainThread:@selector(doneLevels) withObject:nil waitUntilDone:NO];
}

@end
