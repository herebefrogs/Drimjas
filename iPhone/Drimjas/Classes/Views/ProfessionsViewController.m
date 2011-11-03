//
//  ProfessionsViewController.m
//  Drimjas
//
//  Created by Jerome Lecomte on 11-10-17.
//  Copyright (c) 2011 David J Peacock Photography. All rights reserved.
//

#import "ProfessionsViewController.h"
// API
#import "MyInfo.h"


@interface ProfessionsViewController ()

@property (nonatomic, retain) NSArray *professions;
- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath;

@end


@implementation ProfessionsViewController


@synthesize professions;
@synthesize myInfo;

- (void)dealloc {
    [professions release];
    [myInfo release];
    [super dealloc];
}

#pragma mark - View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
	self.title = NSLocalizedString(@"Pick Profession", "ProfessionsViewController Navigation Item Title");

    // read professions list from plist
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"Professions" ofType:@"plist"];
    NSArray *profs = [[NSDictionary dictionaryWithContentsOfFile:plistPath] objectForKey:@"professions"];

    // sort profession so their localized translations are in alphabetical order
    self.professions = [profs sortedArrayUsingComparator:^NSComparisonResult(NSString *prof1, NSString *prof2) {
        return [NSLocalizedString(prof1, "") localizedCaseInsensitiveCompare:NSLocalizedString(prof2, "")];
    }];
}

- (void)viewDidUnload {
    [super viewDidUnload];
    self.professions = nil;
    self.myInfo = nil;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    [self.tableView reloadData];

    if (self.myInfo.profession) {
        // if set, put profession currently selected in the middle of the screen
        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:[self.professions indexOfObject:self.myInfo.profession]
                                                                  inSection:0]
                              atScrollPosition:UITableViewScrollPositionTop animated:NO];
    }
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

    // place a checkmark on the row of the profession currently selected
    if ([[self.professions objectAtIndex:indexPath.row] isEqualToString:self.myInfo.profession]) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    else {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    self.myInfo.profession = [self.professions objectAtIndex:indexPath.row];

    [self.navigationController popViewControllerAnimated:YES];
}

@end
