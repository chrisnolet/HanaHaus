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

@interface BookingViewController ()

@property (strong, nonatomic) UIView *headerView;
@property (nonatomic, assign) NSInteger bookingTypeIndex;

@end

@implementation BookingViewController

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - UIViewController

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)viewDidLoad
{
    [super viewDidLoad];

    // Remove navigation bar shadow
    [self.navigationController.navigationBar setBackgroundImage:[[UIImage alloc] init]
                                                  forBarMetrics:UIBarMetricsDefault];

    self.navigationController.navigationBar.shadowImage = [[UIImage alloc] init];

    // Add header view
    self.headerView = [[[UINib nibWithNibName:@"Header" bundle:nil] instantiateWithOwner:self options:nil] firstObject];

    [self.tableView addSubview:self.headerView];

    // Set header width and height
    CGRect frame = CGRectMake(0, 0, self.tableView.frame.size.width, self.headerView.frame.size.height);

    self.headerView.frame = frame;
    self.tableView.tableHeaderView = [[UIView alloc] initWithFrame:frame];
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    [self.navigationController setNavigationBarHidden:YES animated:animated];
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];

    [self.navigationController setNavigationBarHidden:NO animated:animated];
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
#pragma mark - UITableViewDelegate

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
    // Pin the header view to the top of the table view
    CGFloat offset = self.tableView.contentOffset.y;

    self.headerView.frame = CGRectMake(0,
                                       offset,
                                       self.tableView.bounds.size.width,
                                       MAX(self.tableView.tableHeaderView.bounds.size.height - offset, 0));
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Public methods

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
- (IBAction)unwindFromBookingType:(UIStoryboardSegue *)unwindSegue
{
    BookingTypeTableViewController *bookingTypeTableViewController = unwindSegue.sourceViewController;

    self.bookingTypeIndex = bookingTypeTableViewController.bookingTypeIndex;
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
- (IBAction)stepperValueDidChange:(id)sender
{
    self.numberOfPeopleLabel.text = [NSString stringWithFormat:@"%.0f", self.numberOfPeopleStepper.value];
    self.hoursLabel.text = [NSString stringWithFormat:@"%.0f", self.hoursStepper.value];
}

@end
