//
//  ViewController.h
//  iOSSimpleWebCrawlerSpider
//
//  Created by Serge Moskalenko on 27.04.16.
//  Copyright (c) 2016 Serge Moskalenko. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController<UIGestureRecognizerDelegate>

@property (weak, nonatomic) IBOutlet UITextField *urlTextField;
@property (weak, nonatomic) IBOutlet UITextField *searchedTextField;
@property (weak, nonatomic) IBOutlet UITextField *maxResultsTextField;
@property (weak, nonatomic) IBOutlet UITextField *maxDeepTextField;
@property (weak, nonatomic) IBOutlet UITextField *maxFlowTextField;

@property (weak, nonatomic) IBOutlet UIButton *goButton;
@property (weak, nonatomic) IBOutlet UIButton *pauseButton;
@property (weak, nonatomic) IBOutlet UIButton *resumeButton;
@property (weak, nonatomic) IBOutlet UIButton *stopButton;

@property (weak, nonatomic) IBOutlet UILabel *infoLabel;
@property (weak, nonatomic) IBOutlet UITableView *tableView;



- (IBAction)go:(id)sender;
- (IBAction)pause:(id)sender;
- (IBAction)resume:(id)sender;
- (IBAction)stop:(id)sender;

@end

