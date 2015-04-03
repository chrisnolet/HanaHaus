//
//  ConfirmViewController.h
//  HanaHaus
//
//  Created by Chris Nolet on 4/2/15.
//  Copyright (c) 2015 Relaunch. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ConfirmViewController : UIViewController

@property (strong, nonatomic) IBOutlet UILabel *detailLabel;
@property (nonatomic, assign) NSInteger bookingTypeIndex;
@property (nonatomic, assign) NSInteger numberOfPeople;
@property (nonatomic, assign) NSInteger hours;

@end
