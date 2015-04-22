//
//  AccountTableViewController.h
//  HanaHaus
//
//  Created by Chris Nolet on 4/9/15.
//  Copyright (c) 2015 Relaunch. All rights reserved.
//

#import "AccountTableViewController.h"
#import "EditCell.h"

@implementation AccountTableViewController

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - UIViewController

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)viewDidLoad
{
    [super viewDidLoad];

    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    // Display saved account details
    self.nameTextField.text = [[NSUserDefaults standardUserDefaults] objectForKey:kUserDefaultsAccountName];
    self.emailTextField.text = [[NSUserDefaults standardUserDefaults] objectForKey:kUserDefaultsAccountEmail];
    self.phoneTextField.text = [[NSUserDefaults standardUserDefaults] objectForKey:kUserDefaultsAccountPhone];
    self.zipTextField.text = [[NSUserDefaults standardUserDefaults] objectForKey:kUserDefaultsAccountZip];
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];

    [self.nameTextField becomeFirstResponder];
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];

    [self.view endEditing:YES];
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - UITableViewDelegate

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];

    if ([[tableView cellForRowAtIndexPath:indexPath] isKindOfClass:[EditCell class]]) {
        EditCell *editCell = (EditCell *)cell;
        [editCell.textField becomeFirstResponder];
    } else {
        [self.view endEditing:NO];
    }
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Fix for separator insets on iOS 8: http://stackoverflow.com/questions/25770119/#25877725
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        cell.layoutMargins = UIEdgeInsetsZero;
        cell.preservesSuperviewLayoutMargins = NO;
    }
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - UITextFieldDelegate

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    // Skip to the next text field
    UIView *nextView = [self.view viewWithTag:textField.tag + 1];
    [nextView becomeFirstResponder];

    return YES;
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Public methods

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
- (IBAction)cancelBarButtonItemPressed:(id)sender
{
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
- (IBAction)doneBarButtonItemPressed:(id)sender
{
    // Save account details
    [[NSUserDefaults standardUserDefaults] setObject:self.nameTextField.text forKey:kUserDefaultsAccountName];
    [[NSUserDefaults standardUserDefaults] setObject:self.emailTextField.text forKey:kUserDefaultsAccountEmail];
    [[NSUserDefaults standardUserDefaults] setObject:self.phoneTextField.text forKey:kUserDefaultsAccountPhone];
    [[NSUserDefaults standardUserDefaults] setObject:self.zipTextField.text forKey:kUserDefaultsAccountZip];

    // Dismiss modal
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

@end
