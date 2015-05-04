//
//  BookingViewController.m
//  HanaHaus
//
//  Created by Chris Nolet on 3/28/15.
//  Copyright (c) 2015 Relaunch. All rights reserved.
//

#import "BookingViewController.h"
#import "BookingTypeTableViewController.h"
#import "ConfirmViewController.h"
#import "NSDate+BeginningOfDay.h"
#import "NSString+Plural.h"

@interface BookingViewController ()

@property (strong, nonatomic) UIView *headerView;
@property (nonatomic, assign) NSInteger bookingTypeIndex;
@property (nonatomic, assign) BOOL showDatePicker;

- (void)applicationWillChangeStatusBarFrame:(NSNotification *)notification;
- (void)toggleDatePicker;
- (void)updateHeaderFrame;

@end

@implementation BookingViewController

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - UIViewController

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)viewDidLoad
{
    [super viewDidLoad];

    // Adjust header placement after toggling in-call status bar
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(applicationWillChangeStatusBarFrame:)
                                                 name:UIApplicationWillChangeStatusBarFrameNotification
                                               object:nil];

    // Add header view
    self.headerView = [[[UINib nibWithNibName:@"Header" bundle:nil] instantiateWithOwner:self options:nil] firstObject];

    [self.tableView addSubview:self.headerView];

    // Set header width and height
    CGRect frame = CGRectMake(0, 0, self.tableView.frame.size.width, self.headerView.frame.size.height);

    self.headerView.frame = frame;
    self.tableView.tableHeaderView = [[UIView alloc] initWithFrame:frame];

    // Limit booking times
    self.datePicker.minimumDate = [NSDate beginningOfDay];
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    [self.navigationController setNavigationBarHidden:YES animated:animated];
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"BookingTypeSegue"]) {

    }
    else if ([segue.identifier isEqualToString:@"ConfirmSegue"]) {
        ConfirmViewController *confirmViewController = segue.destinationViewController;

        confirmViewController.bookingTypeIndex = self.bookingTypeIndex;
        confirmViewController.numberOfPeople = self.numberOfPeopleStepper.value;
        confirmViewController.hours = self.hoursStepper.value;
    }
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - NSObject

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - UITableViewDelegate

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (!self.showDatePicker && indexPath.row == kTableViewDatePickerRow) {
        return 0;
    }

    return [super tableView:tableView heightForRowAtIndexPath:indexPath];
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];

    if ([cell isEqual:self.startCell]) {
        [tableView deselectRowAtIndexPath:indexPath animated:YES];

        [self toggleDatePicker];
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
#pragma mark - UIScrollViewDelegate

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self updateHeaderFrame];
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Public methods

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
- (IBAction)stepperValueDidChange:(id)sender
{
    if ([sender isEqual:self.numberOfPeopleStepper]) {
        self.numberOfPeopleLabel.text = [NSString stringWithInteger:self.numberOfPeopleStepper.value
                                                       singularTerm:@"Person"
                                                         pluralTerm:@"People"];

        self.numberOfPeopleLabel.textColor = [UIColor redColor];

        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.1 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
            [UIView transitionWithView:self.numberOfPeopleLabel
                              duration:1
                               options:UIViewAnimationOptionTransitionCrossDissolve
                            animations:^{
                                self.numberOfPeopleLabel.textColor = [UIColor blackColor];
                            } completion:nil];
        });
    }
    else if ([sender isEqual:self.hoursStepper]) {
        self.hoursLabel.text = [NSString stringWithInteger:self.hoursStepper.value singularTerm:@"Hour" pluralTerm:@"Hours"];
    }
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
- (IBAction)datePickerValueDidChange:(id)sender
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateStyle = NSDateFormatterMediumStyle;
    dateFormatter.timeStyle = NSDateFormatterShortStyle;
    dateFormatter.dateFormat = @"MMM d, y     h:mm a";

    self.startCell.detailTextLabel.text = [dateFormatter stringFromDate:self.datePicker.date];
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
- (IBAction)accountButtonPressed:(id)sender
{
    [self performSegueWithIdentifier:@"AccountSegue" sender:nil];
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
- (IBAction)continueButtonPressed:(id)sender
{
    [self performSegueWithIdentifier:@"ConfirmSegue" sender:nil];
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
- (IBAction)unwindFromAccount:(UIStoryboardSegue *)unwindSegue
{
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
- (IBAction)unwindFromBookingType:(UIStoryboardSegue *)unwindSegue
{
    BookingTypeTableViewController *bookingTypeTableViewController = unwindSegue.sourceViewController;

    self.bookingTypeIndex = bookingTypeTableViewController.bookingTypeIndex;
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Private methods

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)applicationWillChangeStatusBarFrame:(NSNotification *)notification
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self updateHeaderFrame];
    });
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)toggleDatePicker
{
    self.showDatePicker = !self.showDatePicker;

    // ...
    self.startCell.detailTextLabel.textColor = self.showDatePicker ? [UIColor redColor] : [UIColor blackColor];

    // Animate ...
    [UIView animateWithDuration:0.5
                          delay:0
         usingSpringWithDamping:1
          initialSpringVelocity:1
                        options:0
                     animations:^{

                         // Show or hide date picker cell
                         [self.tableView beginUpdates];
                         [self.tableView reloadData];
                         [self.tableView endUpdates];

                         // ... TODO(CN): Add comment
                         if (self.showDatePicker) {
                             CGFloat offset = (self.datePicker.frame.size.height + self.startCell.frame.size.height) / 2.0f;

                             self.tableView.contentOffset = CGPointMake(0, offset);
                         } else {
                             [self updateHeaderFrame];
                         }

                         [self.view layoutIfNeeded];
                     } completion:nil];
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)updateHeaderFrame
{
    // Pin the header view to the top of the table view
    CGFloat offset = self.tableView.contentOffset.y;

    self.headerView.frame = CGRectMake(0,
                                       offset,
                                       self.tableView.frame.size.width,
                                       MAX(self.tableView.tableHeaderView.frame.size.height - offset, 0));
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
- (NSString *)validate
{
    NSString *name = [[NSUserDefaults standardUserDefaults] objectForKey:kUserDefaultsAccountName];
    NSString *email = [[NSUserDefaults standardUserDefaults] objectForKey:kUserDefaultsAccountEmail];
    NSString *phone = [[NSUserDefaults standardUserDefaults] objectForKey:kUserDefaultsAccountPhone];
    NSString *zip = [[NSUserDefaults standardUserDefaults] objectForKey:kUserDefaultsAccountZip];

    if ([name length] == 0) {
        return @"Name required";
    }

    if ([email length] == 0) {
        return @"Email required";
    }

    if ([phone length] == 0) {
        return @"Phone required";
    }

    if ([zip length] == 0) {
        return @"Zip required";
    }

    return nil;
}

@end
