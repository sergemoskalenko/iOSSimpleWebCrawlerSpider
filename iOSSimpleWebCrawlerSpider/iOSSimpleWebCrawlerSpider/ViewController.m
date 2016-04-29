//
//  ViewController.m
//  iOSSimpleWebCrawlerSpider
//
//  Created by Serge Moskalenko on 27.04.16.
//  Copyright (c) 2016 Serge Moskalenko. All rights reserved.
//

#import "ViewController.h"
#import "MSVSimpleWebCrawlerSpiderModel.h"
#import "MSVSimpleWebCrawlerSpiderItem.h"
#import "MSVSimpleWebCrawlerSpiderSeachSettings.h"
#import "MSVSimpleWebCrawlerSpiderLoader.h"

@interface ViewController ()
@property (strong, nonatomic) UITapGestureRecognizer* tapGestureRecognizer;
@property (nonatomic, weak) MSVSimpleWebCrawlerSpiderModel* model;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.

    self.model = [MSVSimpleWebCrawlerSpiderModel sharedModel];
    _model.delegate = self;
    
    [_model addObserver:self forKeyPath:@"currentStatus" options:0 context:NULL];
    
    self.tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapView)];
    [self.view addGestureRecognizer:self.tapGestureRecognizer];
    self.tapGestureRecognizer.delegate = self;
    
    [self reconnectView:_urlTextField];
    [self reconnectView:_searchedTextField];
    [self reconnectView:_maxResultsTextField];
    [self reconnectView:_maxDeepTextField];
    [self reconnectView:_maxFlowTextField];
    [self reconnectView:_goButton];
    [self reconnectView:_pauseButton];
    [self reconnectView:_resumeButton];
    [self reconnectView:_stopButton];
    [self reconnectView:_infoLabel];
    [self reconnectView:_tableView];
    
    NSNumber *padding = @11;
    NSDictionary *metrics = NSDictionaryOfVariableBindings(padding);
    void (^addConstraint)(UIView *, NSString *, NSDictionary *) = ^(UIView *superview, NSString *format, NSDictionary *views) {
        [superview addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:format options:0 metrics:metrics views:views]];
    };
    
    NSDictionary *rows = NSDictionaryOfVariableBindings(
                                                        _urlTextField,
                                                        _searchedTextField,
                                                        _maxResultsTextField,
                                                        _maxDeepTextField,
                                                        _maxFlowTextField,
                                                        _goButton,
                                                        _pauseButton,
                                                        _resumeButton,
                                                        _stopButton,
                                                        _infoLabel,
                                                        _tableView);

    
    addConstraint(self.view, @"H:|-padding-[_urlTextField]-padding-|", rows);
    // addConstraint(self.view, @"H:|-padding-[_searchedTextField]-padding-|", rows);
    addConstraint(self.view, @"H:|-padding-[_searchedTextField(>=115)]-5-[_maxResultsTextField]-5-[_maxDeepTextField(==_maxResultsTextField)]-5-[_maxFlowTextField(==_maxResultsTextField)]-padding-|", rows);
    addConstraint(self.view, @"H:|-padding-[_goButton(>=_stopButton)]-5-[_pauseButton(==_stopButton)]-5-[_resumeButton(==_stopButton)]-5-[_stopButton]-padding-|", rows);
    addConstraint(self.view, @"H:|-padding-[_infoLabel]-padding-|", rows);
        addConstraint(self.view, @"H:|-padding-[_tableView]-padding-|", rows);
    
    
    addConstraint(self.view, @"V:|-30-[_urlTextField(30)]-padding-[_searchedTextField(30)]-padding-[_goButton(30)]-padding-[_infoLabel(30)]-padding-[_tableView]-padding-|", rows);
    addConstraint(self.view, @"V:|-30-[_urlTextField(30)]-padding-[_maxResultsTextField(30)]-padding-[_pauseButton(30)]-padding-[_infoLabel(30)]-padding-[_tableView]-padding-|", rows);
    addConstraint(self.view, @"V:|-30-[_urlTextField(30)]-padding-[_maxDeepTextField(30)]-padding-[_resumeButton(30)]-padding-[_infoLabel(30)]-padding-[_tableView]-padding-|", rows);
    addConstraint(self.view, @"V:|-30-[_urlTextField(30)]-padding-[_maxFlowTextField(30)]-padding-[_stopButton(30)]-padding-[_infoLabel(30)]-padding-[_tableView]-padding-|", rows);
    
    [self buttonSet];
    
}

- (void)dealloc
{
    [_model removeObserver:self forKeyPath:@"currentStatus"];
}


- (void)buttonSet
{
    switch (_model.currentStatus)
    {
        case MSVSimpleWebCrawlerSpiderCurrentStatusNone:
        case MSVSimpleWebCrawlerSpiderCurrentStatusDone:
        case MSVSimpleWebCrawlerSpiderCurrentStatusStopped:
            _goButton.enabled = YES;
            _pauseButton.enabled = NO;
            _resumeButton.enabled = NO;
            _stopButton.enabled = NO;
            break;

        case MSVSimpleWebCrawlerSpiderCurrentStatusInWork:
            _goButton.enabled = NO;
            _pauseButton.enabled = YES;
            _resumeButton.enabled = NO;
            _stopButton.enabled = NO;
            break;

        case MSVSimpleWebCrawlerSpiderCurrentStatusSuspended:
            _goButton.enabled = NO;
            _pauseButton.enabled = NO;
            _resumeButton.enabled = YES;
            _stopButton.enabled = NO;
            break;
            
        default:
            break;
    }
}


- (void)tapView
{
    for(int i = 1001; i < 1006; i++ )
    {
        UITextField *textField = (UITextField *)[self.view viewWithTag:i];
        [textField resignFirstResponder];
    }
}

- (void)reconnectView:(UIView *)view
{
    [view removeFromSuperview];
    view.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:view];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Actions

- (IBAction)go:(id)sender {
    [self tapView];
    [self testTextField];
    
    [_model start];
}

- (IBAction)pause:(id)sender {
    [self tapView];
    
    [_model pause];
}

- (IBAction)resume:(id)sender {
    [self tapView];

    [_model resume];
}

- (IBAction)stop:(id)sender {
    [self tapView];
    
    [_model stop];
}

#pragma mark - TextField delegate methods 

- (void)testTextField
{
    for(int i = 1001; i < 1006; i++ )
    {
        UITextField *textField = (UITextField *)[self.view viewWithTag:i];
        [self textFieldTestAndCorrect:textField];
        
        switch (textField.tag)
        {
            case 1001:
                _model.searchSettings.urlStartString = textField.text;
                textField.text = _model.searchSettings.urlStartString;
                break;
                
            case 1002:
                _model.searchSettings.searchedString = textField.text;
                textField.text = _model.searchSettings.searchedString;
                break;
                
            case 1003:
                _model.searchSettings.maxResults = [textField.text intValue];
                textField.text = [NSString stringWithFormat:@"%d", _model.searchSettings.maxResults];
                break;
                
            case 1004:
                _model.searchSettings.maxDeep = [textField.text intValue];
                textField.text = [NSString stringWithFormat:@"%d", _model.searchSettings.maxDeep];
                break;
                
            case 1005:
                _model.searchSettings.maxFlow = [textField.text intValue];
                textField.text = [NSString stringWithFormat:@"%d", _model.searchSettings.maxFlow];
                break;
                
            default:
                break;
        }
    }
}

- (void)textFieldTestAndCorrect:(UITextField *)textField
{
    @synchronized(textField)
    {
        NSString* text = textField.text;
        text = [text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        int num = [text intValue];
        
        if (text.length == 0 || (num == 0 && textField.tag > 1002))
        {
            switch (textField.tag)
            {
                case 1001:
                    textField.text = @"http://msv-main.blogspot.com";
                    break;
                    
                case 1002:
                    textField.text = @"iOS";
                    break;
                    
                case 1003:
                    textField.text = @"100";
                    break;
                    
                case 1004:
                    textField.text = @"3"; 
                    break;
                    
                case 1005:
                    textField.text = @"3";
                    break;
                    
                default:
                    break;
            }

        }
        else
        {
            if (textField.tag == 1001)
            {
                if ([text  rangeOfString:@"http://" options:NSCaseInsensitiveSearch].location == NSNotFound && [text  rangeOfString:@"https://" options:NSCaseInsensitiveSearch].location == NSNotFound)
                {
                    text = [@"http://" stringByAppendingString:text];
                }

                if ([text rangeOfString:@"." options:NSCaseInsensitiveSearch].location == NSNotFound)
                {
                    text = [text stringByAppendingString:@".com"];
                }
            }

        }
    }
}


- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    [self textFieldTestAndCorrect:textField];
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{

    NSInteger tag = textField.tag;
    UITextField *textFieldNext = (UITextField *)[self.view viewWithTag:tag + 1];
    if (textFieldNext)
    {
        [textField resignFirstResponder];
        [textFieldNext becomeFirstResponder];
    }
    
    [self textFieldTestAndCorrect:textField];
    
    return YES;
}



#pragma mark - UITableView dataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [MSVSimpleWebCrawlerSpiderModel sharedModel].items.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellType = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellType];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellType];
    }
    MSVSimpleWebCrawlerSpiderItem *item = [MSVSimpleWebCrawlerSpiderModel sharedModel].items[indexPath.row];
    cell.textLabel.text = @"";
    if (item.numberResult > 0 || item.statusError != nil)
    {
        cell.textLabel.text = [NSString stringWithFormat:@"%d times %@", item.numberResult, item.statusError?[NSString stringWithFormat:@", Error:%@", item.statusError]:@""];
    }
    else
    {
        if (item.status == MSVSimpleWebCrawlerSpiderItemStatusWait && item.level <= [MSVSimpleWebCrawlerSpiderModel sharedModel].searchSettings.maxDeep)
            cell.textLabel.text = [NSString stringWithFormat:@"wait... %d", item.level];
        if (item.status == MSVSimpleWebCrawlerSpiderItemStatusInWork)
            cell.textLabel.text = @"loading...";
    }
        
    cell.detailTextLabel.text = item.urlString;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;
{
    MSVSimpleWebCrawlerSpiderItem *item = [MSVSimpleWebCrawlerSpiderModel sharedModel].items[indexPath.row];
    NSString* urlString = item.urlString;
    
    NSURL *url = [NSURL URLWithString:urlString];
    if ([[UIApplication sharedApplication] canOpenURL:url]) {
        [[UIApplication sharedApplication] openURL:url];
    }
}


#pragma mark - delegates from model

- (void) observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object
                         change:(NSDictionary *)change context:(void *)context
{
    if (object == _model && [keyPath isEqualToString:@"currentStatus"])
    {
        [self buttonSet];
    }
    else {
        [super observeValueForKeyPath:keyPath ofObject:object
                               change:change context:context];
    }
}

- (void)newItem
{
    [self showInfo];
    [self.tableView reloadData];
}

- (void)downloadedItem
{
    [self showInfo];
    [self.tableView reloadData];
    
}

- (void)showInfo
{
    _infoLabel.text = [NSString stringWithFormat:@"%d active flow, %d pages view, %d found", _model.currentInfo.flowCount, _model.currentInfo.viewCount, _model.currentInfo.foundCount];
}


#pragma mark UIGestureRecognizerDelegate methods

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    if ([touch.view isDescendantOfView:_tableView]) {
        
        // Don't let selections of auto-complete entries fire the
        // gesture recognizer
        return NO;
    }
    
    return YES;
}

@end
