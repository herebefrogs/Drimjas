//
//  CurrenciesViewController.m
//  Drimjas
//
//  Created by Jerome Lecomte on 11-10-11.
//  Copyright 2011 David J Peacock Photography. All rights reserved.
//

#import "CurrenciesViewController.h"

@interface CurrenciesViewController ()

@property (nonatomic, retain) NSArray *currencyCodes;
- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath;

@end


@implementation CurrenciesViewController


@synthesize currencyCodes;
@synthesize currency;

- (void)dealloc {
#ifdef __ENABLE_UI_LOGS__
	NSLog(@"CurrenciesViewController.dealloc");
#endif
    [currencyCodes release];
    [currency release];
    [super dealloc];
}

#pragma mark - View lifecycle

- (void)viewDidLoad {
#ifdef __ENABLE_UI_LOGS__
	NSLog(@"CurrenciesViewController.viewDidLoad");
#endif
    [super viewDidLoad];
	self.title = NSLocalizedString(@"Pick Currency", "CurrenciesViewController Navigation Item Title");

    // sort list of common ISO currency codes so their display names are in alphabetical order
    self.currencyCodes = [[NSLocale commonISOCurrencyCodes] sortedArrayUsingComparator:^NSComparisonResult(id code1, id code2) {
        return [[[NSLocale currentLocale] displayNameForKey:NSLocaleCurrencyCode
                                                      value:code1]
                localizedCaseInsensitiveCompare:[[NSLocale currentLocale] displayNameForKey:NSLocaleCurrencyCode
                                                                                      value:code2]];
    }];
}

- (void)viewDidUnload {
#ifdef __ENABLE_UI_LOGS__
	NSLog(@"CurrenciesViewController.viewDidUnload");
#endif
    [super viewDidUnload];
    self.currencyCodes = nil;
    self.currency = nil;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    [self.tableView reloadData];

    // put currency currently selected in the middle of the screen
    [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:[self.currencyCodes indexOfObject:self.currency.isoCode]
                                                              inSection:0]
                          atScrollPosition:UITableViewScrollPositionTop animated:NO];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return YES;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.currencyCodes.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
    [self configureCell:cell atIndexPath:indexPath];
    
    return cell;
}

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    // get the display name of the currency code
    cell.textLabel.text = [[NSLocale currentLocale] displayNameForKey:NSLocaleCurrencyCode
                                                                value:[self.currencyCodes objectAtIndex:indexPath.row]];

    // place a checkmark on the row of the currency currently selected
    if ([[self.currencyCodes objectAtIndex:indexPath.row] isEqualToString:self.currency.isoCode]) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    else {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    self.currency.isoCode = [self.currencyCodes objectAtIndex:indexPath.row];

    [self.navigationController popViewControllerAnimated:YES];
}

@end
