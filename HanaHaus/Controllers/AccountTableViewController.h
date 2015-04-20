//
//  AccountTableViewController.h
//  HanaHaus
//
//  Created by Chris Nolet on 4/9/15.
//  Copyright (c) 2015 Relaunch. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AccountTableViewController : UITableViewController

@property (strong, nonatomic) IBOutlet UITextField *nameTextField;
@property (strong, nonatomic) IBOutlet UITextField *emailTextField;
@property (strong, nonatomic) IBOutlet UITextField *phoneTextField;
@property (strong, nonatomic) IBOutlet UITextField *zipTextField;

- (IBAction)cancelBarButtonItemPressed:(id)sender;
- (IBAction)doneBarButtonItemPressed:(id)sender;

@end
