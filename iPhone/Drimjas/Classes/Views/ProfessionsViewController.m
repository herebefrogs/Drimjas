//
//  ProfessionsViewController.m
//  Drimjas
//
//  Created by Jerome Lecomte on 11-10-17.
//  Copyright (c) 2011 David J Peacock Photography. All rights reserved.
//

#import "ProfessionsViewController.h"


@interface ProfessionsViewController ()

@property (nonatomic, retain) NSArray *professions;
- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath;

@end


@implementation ProfessionsViewController


@synthesize professions;

- (void)dealloc {
    [professions release];
    [super dealloc];
}

#pragma mark - View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
	self.title = NSLocalizedString(@"Pick Profession", "ProfessionsViewController Navigation Item Title");

    // read professions from plist
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"Professions" ofType:@"plist"];
    NSArray *profs = [NSArray arrayWithContentsOfFile:plistPath];

    // sort profession so their localized translations are in alphabetical order
    self.professions = [profs sortedArrayUsingComparator:^NSComparisonResult(NSString *prof1, NSString *prof2) {
        return [NSLocalizedString(prof1, "") localizedCaseInsensitiveCompare:NSLocalizedString(prof2, "")];
    }];
}

- (void)viewDidUnload {
    [super viewDidUnload];
    self.professions = nil;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    [self.tableView reloadData];

    // TODO scroll to put selected row in the middle of the screen
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return YES;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.professions.count;
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
    // get the display name of the profession
    cell.textLabel.text = NSLocalizedString([self.professions objectAtIndex:indexPath.row], "");

    // TODO place a checkmark on the row of the profession currently selected
    cell.accessoryType = UITableViewCellAccessoryNone;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"select profession %@", [self.professions objectAtIndex:indexPath.row]);

    // TODO assign selected profession

    [self.navigationController popViewControllerAnimated:YES];
}

@end
