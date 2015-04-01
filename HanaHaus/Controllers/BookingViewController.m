//
//  BookingViewController.m
//  HanaHaus
//
//  Created by Chris Nolet on 3/28/15.
//  Copyright (c) 2015 Relaunch. All rights reserved.
//

#import "BookingViewController.h"

@implementation BookingViewController

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - UIViewController

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)viewDidLoad
{
    [super viewDidLoad];

    [self.navigationController.navigationBar setBackgroundImage:[[UIImage alloc] init]
                                                  forBarMetrics:UIBarMetricsDefault];

    self.navigationController.navigationBar.shadowImage = [[UIImage alloc] init];

//    self.navigationItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Title.png"]];
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

//    [self.navigationController setNavigationBarHidden:YES animated:animated];
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];

//    [self.navigationController setNavigationBarHidden:NO animated:animated];
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)viewDidLayoutSubviews
{
//    CGRect frame = self.navigationController.navigationBar.frame;
//    frame.size.height = 0.0f;
//
//    self.navigationController.navigationBar.frame = frame;
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
    // Keep the balance view pinned (floating) when the user pulls to refresh
    CGFloat offset = self.tableView.contentOffset.y;
    NSLog(@"%f", offset);
    if (offset < 0) {

        // Pulled to refresh
        self.tableView.tableHeaderView.transform = CGAffineTransformMakeTranslation(0, offset);

    } else {

        // Partially visible
        if (offset < self.tableView.tableHeaderView.frame.size.height) {
            self.tableView.tableHeaderView.transform = CGAffineTransformIdentity;
        }
    }
}

@end
