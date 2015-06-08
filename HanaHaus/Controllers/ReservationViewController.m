//
//  ReservationViewController.m
//  HanaHaus
//
//  Created by Chris Nolet on 3/28/15.
//  Copyright (c) 2015 Relaunch. All rights reserved.
//

#import "ReservationViewController.h"
#import "ReservationTypeTableViewController.h"
#import "AccountTableViewController.h"
#import "ConfirmViewController.h"
#import "AccountManager.h"
#import "NSDate+Calendar.h"
#import "NSDateFormatter+StringWithFormat.h"
#import "NSString+Plural.h"

@interface ReservationViewController ()

@property (strong, nonatomic) UIView *headerView;
@property (nonatomic, assign) NSInteger reservationTypeIndex;
@property (nonatomic, assign) BOOL showDatePicker;

- (void)applicationWillChangeStatusBarFrame:(NSNotification *)notification;
- (void)applicationSignificantTimeChange:(NSNotification *)notification;
- (void)setHeaderView:(UIView *)headerView;
- (void)setShowDatePicker:(BOOL)showDatePicker animated:(BOOL)animated;
- (void)updateHeaderFrame;
- (void)updateStartDate;
- (void)resetStartDate;

@end

@implementation ReservationViewController

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

    // Reset date picker at midnight
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(applicationSignificantTimeChange:)
                                                 name:UIApplicationSignificantTimeChangeNotification
                                               object:nil];

    // Add header view
    self.headerView = [[[UINib nibWithNibName:@"Header" bundle:nil] instantiateWithOwner:self options:nil] firstObject];

    // Set default start date
    [self resetStartDate];
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
    if ([segue.identifier isEqualToString:@"ReservationTypeSegue"]) {
        ReservationTypeTableViewController *reservationTypeTableViewController = segue.destinationViewController;

        reservationTypeTableViewController.reservationTypeIndex = self.reservationTypeIndex;
    }
    else if ([segue.identifier isEqualToString:@"AccountRequiredSegue"]) {
        AccountTableViewController *accountTableViewController = (AccountTableViewController *)[segue.destinationViewController
                                                                                                topViewController];

        accountTableViewController.confirmSegueOnUnwind = YES;
    }
    else if ([segue.identifier isEqualToString:@"ConfirmSegue"]) {
        ConfirmViewController *confirmViewController = segue.destinationViewController;

        confirmViewController.reservationTypeIndex = self.reservationTypeIndex;
        confirmViewController.numberOfPeople = self.numberOfPeopleStepper.value;
        confirmViewController.hours = self.hoursStepper.value;
        confirmViewController.startDate = self.datePicker.date;
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
    // Hide date picker row if necessary
    if (!self.showDatePicker && indexPath.row == kTableViewDatePickerRow) {
        return 0;
    }

    return [super tableView:tableView heightForRowAtIndexPath:indexPath];
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];

    if ([cell isEqual:self.startDateCell]) {
        [tableView deselectRowAtIndexPath:indexPath animated:YES];

        [self setShowDatePicker:!self.showDatePicker animated:YES];
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

        [self indicateUpdateForLabel:self.numberOfPeopleLabel];
    }
    else if ([sender isEqual:self.hoursStepper]) {
        self.hoursLabel.text = [NSString stringWithInteger:self.hoursStepper.value singularTerm:@"Hour" pluralTerm:@"Hours"];

        [self indicateUpdateForLabel:self.hoursLabel];
    }
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
- (IBAction)datePickerValueDidChange:(id)sender
{
    [self updateStartDate];
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
- (IBAction)accountButtonPressed:(id)sender
{
    [self performSegueWithIdentifier:@"AccountSegue" sender:nil];
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
- (IBAction)continueButtonPressed:(id)sender
{
    AccountManager *accountManager = [[AccountManager alloc] init];

    if ([accountManager validate]) {
        [self performSegueWithIdentifier:@"AccountRequiredSegue" sender:nil];
    } else {
        [self performSegueWithIdentifier:@"ConfirmSegue" sender:nil];
    }
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
- (IBAction)unwindFromReservationType:(UIStoryboardSegue *)unwindSegue
{
    ReservationTypeTableViewController *reservationTypeTableViewController = unwindSegue.sourceViewController;

    self.reservationTypeIndex = reservationTypeTableViewController.reservationTypeIndex;
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
- (IBAction)unwindFromAccount:(UIStoryboardSegue *)unwindSegue
{
    AccountTableViewController *accountTableViewController = unwindSegue.sourceViewController;

    if (accountTableViewController.confirmSegueOnUnwind) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self performSegueWithIdentifier:@"ConfirmSegue" sender:nil];
        });
    }
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)unwindFromComplete:(UIStoryboardSegue *)unwindSegue
{
    [self setShowDatePicker:NO animated:NO];
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
- (void)applicationSignificantTimeChange:(NSNotification *)notification
{
    [self resetStartDate];
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)setHeaderView:(UIView *)headerView
{
    [_headerView removeFromSuperview];

    // Keep reference to header view
    _headerView = headerView;

    // Fill table view width
    CGRect frame = CGRectMake(0, 0, self.tableView.frame.size.width, headerView.frame.size.height);

    headerView.frame = frame;

    self.tableView.tableHeaderView = [[UIView alloc] initWithFrame:frame];
    self.tableView.tableHeaderView.userInteractionEnabled = NO;

    [self.tableView addSubview:headerView];
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)setShowDatePicker:(BOOL)showDatePicker animated:(BOOL)animated
{
    self.showDatePicker = showDatePicker;

    // Show active color on date label
    self.startDateCell.detailTextLabel.textColor = showDatePicker ? [UIColor redColor] : [UIColor blackColor];

    if (animated) {

        // Animate table view expansion
        [UIView animateWithDuration:kAnimationDatePickerDuration
                              delay:0
             usingSpringWithDamping:1
              initialSpringVelocity:1
                            options:0
                         animations:^{

                             // Show or hide date picker cell
                             [self.tableView beginUpdates];
                             [self.tableView reloadData];
                             [self.tableView endUpdates];

                             // Scroll to date picker
                             if (showDatePicker) {
                                 CGFloat offset = (self.datePicker.frame.size.height + self.startDateCell.frame.size.height) / 2;

                                 self.tableView.contentOffset = CGPointMake(0, offset);
                             } else {
                                 [self updateHeaderFrame];
                             }

                             [self.view layoutIfNeeded];
                         } completion:nil];
    } else {

        // Reload without animation
        [self.tableView reloadData];
    }
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)indicateUpdateForLabel:(UILabel *)label
{
    // Show active color on label
    label.textColor = [UIColor redColor];

    // Fade to default color
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, kAnimationIndicateUpdateDelay * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        [UIView transitionWithView:label
                          duration:kAnimationIndicateUpdateDuration
                           options:UIViewAnimationOptionTransitionCrossDissolve
                        animations:^{
                            label.textColor = [UIColor blackColor];
                        } completion:nil];
    });
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
- (void)updateStartDate
{
    self.startDateCell.detailTextLabel.text = [NSDateFormatter stringFromDate:self.datePicker.date
                                                                   dateFormat:@"EEE, MMM d    h:mm a"];
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)resetStartDate
{
    // Round up to the nearest date picker interval
    NSTimeInterval secondInterval = self.datePicker.minuteInterval * kTimeSecondsPerMinute;
    NSTimeInterval timeInterval = ceil([[NSDate date] timeIntervalSinceReferenceDate] / secondInterval) * secondInterval;

    self.datePicker.date = [NSDate dateWithTimeIntervalSinceReferenceDate:timeInterval];
    self.datePicker.minimumDate = [[NSDate date] beginningOfDay];

    // Display date
    [self updateStartDate];
}

@end
