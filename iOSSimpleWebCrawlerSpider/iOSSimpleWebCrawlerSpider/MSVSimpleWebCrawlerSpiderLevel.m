//
//  MSVSimpleWebCrawlerSpiderLevel.m
//  iOSSimpleWebCrawlerSpider
//
//  Created by Serge Moskalenko on 28.04.16.
//  Copyright (c) 2016 Serge Moskalenko. All rights reserved.
//

#import "MSVSimpleWebCrawlerSpiderLevel.h"
#import "MSVSimpleWebCrawlerSpiderModel.h"
#import "MSVSimpleWebCrawlerSpiderLoader.h"
#import "MSVSimpleWebCrawlerSpiderItem.h"


@implementation MSVSimpleWebCrawlerSpiderLevel

- (void)runLevel:(int)level
{
    _requestsCount = 0;
    
    __weak MSVSimpleWebCrawlerSpiderLevel* weakSelf = self;
    __weak NSString* searchedString = [MSVSimpleWebCrawlerSpiderModel sharedModel].searchSettings.searchedString;
    NSArray* items = [[MSVSimpleWebCrawlerSpiderModel sharedModel] itemsArrayForLevel:level];
    for (MSVSimpleWebCrawlerSpiderItem* item in items)
    {
        
        while (weakSelf.requestsCount >= [MSVSimpleWebCrawlerSpiderModel sharedModel].searchSettings.maxFlow)
            [NSThread sleepForTimeInterval:0.1];
    
        __weak MSVSimpleWebCrawlerSpiderItem* itemWeak = item;
        
        // NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:item.urlString]];
        NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:item.urlString] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:5]; // 5 sec for page
        
        [[MSVSimpleWebCrawlerSpiderLoader sharedLoader] addRequest:request withHandler:^(NSURLResponse *response, NSData *data, NSError *error)
        {
            
            if (error) {
                itemWeak.statusError = [error localizedDescription];
                itemWeak.status = MSVSimpleWebCrawlerSpiderItemStatusError;
            } else {
                
                NSString* htmlString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                // 1
                NSArray* components = [htmlString componentsSeparatedByString:searchedString];
                itemWeak.numberResult = (int)components.count;
                if (itemWeak.numberResult > 0)
                {
                    itemWeak.status = MSVSimpleWebCrawlerSpiderItemStatusFound;
                    [MSVSimpleWebCrawlerSpiderModel sharedModel].currentInfo.foundCount += itemWeak.numberResult;
                }
                else
                {
                    itemWeak.status = MSVSimpleWebCrawlerSpiderItemStatusNotFound;
                }
                
            
                // 2
                NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"<a.+?href=\"([^\"]+)" options:NSRegularExpressionCaseInsensitive error:&error];
                
                NSArray *arrayOfAllMatches = nil;
                if (htmlString)
                    arrayOfAllMatches = [regex matchesInString:htmlString options:0 range:NSMakeRange(0, [htmlString length])];
                
                for (NSTextCheckingResult *match in arrayOfAllMatches) {
                    if (match == nil)
                        continue;
                    
                    NSString* substringForMatch = [htmlString substringWithRange:match.range];
                    NSUInteger loc =[substringForMatch  rangeOfString:@"href=" options:NSCaseInsensitiveSearch].location;
                    substringForMatch = [substringForMatch substringFromIndex:loc + 5];
                    substringForMatch = [substringForMatch stringByReplacingOccurrencesOfString:@"\"" withString:@""];
                    
                    NSString* newUrl = substringForMatch;
                    if (newUrl)
                    {
                        if ([newUrl  rangeOfString:@"http://" options:NSCaseInsensitiveSearch].location == NSNotFound || [newUrl  rangeOfString:@"https://" options:NSCaseInsensitiveSearch].location == NSNotFound)
                        {
                            newUrl = [NSURL URLWithString:substringForMatch relativeToURL:[NSURL URLWithString:itemWeak.urlString] ].absoluteString;
                        }
                        [[MSVSimpleWebCrawlerSpiderModel sharedModel] appendItemWithURLString:newUrl level:level + 1];
                    }
                    
                    // NSLog(@"Extracted URL: %@",substringForMatch);
                    // NSLog(@"%@, %d", newUrl, itemWeak.numberResult);
                    
                    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                        
                        if ([_delegate respondsToSelector:@selector(newItem)])
                            [_delegate performSelectorOnMainThread:@selector(newItem) withObject:nil waitUntilDone:NO];
                    }];
                    
                }

            }
            
            if (--_requestsCount == 0)
                weakSelf.operationQueue.suspended = NO;
            
            [MSVSimpleWebCrawlerSpiderModel sharedModel].currentInfo.flowCount = _requestsCount;
            
            [MSVSimpleWebCrawlerSpiderModel sharedModel].currentInfo.viewCount++;

            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                
                if ([_delegate respondsToSelector:@selector(downloadedItem)])
                    [_delegate performSelectorOnMainThread:@selector(downloadedItem) withObject:nil waitUntilDone:NO];
            }];

        }];
        
        _requestsCount++;
        [MSVSimpleWebCrawlerSpiderModel sharedModel].currentInfo.flowCount = _requestsCount;
    }

    if (items.count > 0)
        self.operationQueue.suspended = YES;
}


// <a[^>]+href=\"(.*?)\"[^>]*>.*?</a>
// @"http?://([-\\w\\.]+)+(:\\d+)?(/([\\w/_\\.]*(\\?\\S+)?)?)?"
         



@end
