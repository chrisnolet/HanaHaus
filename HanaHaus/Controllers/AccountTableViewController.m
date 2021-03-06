//
//  AccountTableViewController.m
//  HanaHaus
//
//  Created by Chris Nolet on 4/9/15.
//  Copyright (c) 2015 Relaunch. All rights reserved.
//

#import <Analytics.h>
#import <Mixpanel.h>
#import "AccountTableViewController.h"
#import "EditCell.h"
#import "AccountManager.h"

@interface AccountTableViewController ()

@property (strong, nonatomic) AccountManager *accountManager;

- (void)updateDoneButton;

@end

@implementation AccountTableViewController

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - UIViewController

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)viewDidLoad
{
    [super viewDidLoad];

    // Recall account details
    self.accountManager = [[AccountManager alloc] init];

    self.nameTextField.text = self.accountManager.name;
    self.emailTextField.text = self.accountManager.email;
    self.phoneTextField.text = self.accountManager.phone;
    self.zipTextField.text = self.accountManager.zip;

    [self updateDoneButton];
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
- (IBAction)textFieldTextDidChange:(id)sender
{
    [self updateDoneButton];
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
- (IBAction)cancelBarButtonItemPressed:(id)sender
{
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
- (IBAction)doneBarButtonItemPressed:(id)sender
{
    // Save account details
    self.accountManager.name = self.nameTextField.text;
    self.accountManager.email = self.emailTextField.text;
    self.accountManager.phone = self.phoneTextField.text;
    self.accountManager.zip = self.zipTextField.text;

    [self.accountManager save];

    // Dismiss modal
    [self performSegueWithIdentifier:@"UnwindFromAccountSegue" sender:nil];

    [[SEGAnalytics sharedAnalytics] identify:[Mixpanel sharedInstance].distinctId traits:@{
        @"name": self.accountManager.name,
        @"email": self.accountManager.email,
        @"phone": self.accountManager.phone,
        @"zip": self.accountManager.zip
    }];

    [[SEGAnalytics sharedAnalytics] track:@"Updated Account"];
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Private methods

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)updateDoneButton
{
    self.accountManager.name = self.nameTextField.text;
    self.accountManager.email = self.emailTextField.text;
    self.accountManager.phone = self.phoneTextField.text;
    self.accountManager.zip = self.zipTextField.text;

    self.doneBarButtonItem.enabled = ![self.accountManager validate];
}

@end
