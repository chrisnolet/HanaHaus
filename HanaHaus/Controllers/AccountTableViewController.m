//
//  AccountTableViewController.h
//  HanaHaus
//
//  Created by Chris Nolet on 4/9/15.
//  Copyright (c) 2015 Relaunch. All rights reserved.
//

#import "AccountTableViewController.h"
#import "EditCell.h"
#import "AccountManager.h"

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

    // Recall account details
    AccountManager *accountManager = [AccountManager sharedInstance];

    self.nameTextField.text = accountManager.name;
    self.emailTextField.text = accountManager.email;
    self.phoneTextField.text = accountManager.phone;
    self.zipTextField.text = accountManager.zip;
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
#pragma mark - UITableViewDelegate

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];

    if ([cell isKindOfClass:[EditCell class]]) {
        EditCell *editCell = (EditCell *)cell;
        [editCell.textField becomeFirstResponder];
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
    // Validate input
    NSString *error = [self validate];

    // TODO(CN): Display error on SVProgressHUD
    if (error) {
//        [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeGradient];
//        [SVProgressHUD showErrorWithStatus:error];
//
//        return;
    }

    // Save account details
    AccountManager *accountManager = [AccountManager sharedInstance];

    accountManager.name = self.nameTextField.text;
    accountManager.email = self.emailTextField.text;
    accountManager.phone = self.phoneTextField.text;
    accountManager.zip = self.zipTextField.text;

    // Dismiss modal
    [self performSegueWithIdentifier:@"UnwindFromAccountSegue" sender:nil];
}

@end
