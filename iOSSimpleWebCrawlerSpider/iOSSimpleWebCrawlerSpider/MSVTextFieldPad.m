//
//  MSVTextFieldPad.m
//  iOSSimpleWebCrawlerSpider
//
//  Created by Serge Moskalenko on 28.04.16.
//  Copyright (c) 2016 Serge Moskalenko. All rights reserved.
//

#import "MSVTextFieldPad.h"

@implementation MSVTextFieldPad

- (CGRect)textRectForBounds:(CGRect)bounds
{
    return CGRectMake(bounds.origin.x + 5, bounds.origin.y,
                      bounds.size.width - 5, bounds.size.height);
}

- (CGRect)editingRectForBounds:(CGRect)bounds {
    return [self textRectForBounds:bounds];
}

@end
