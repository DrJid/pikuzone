//
//  LoginViewController.h
//  PikuZone
//
//  Created by Maijid Moujaled on 7/2/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "User.h"

@interface LoginViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITextField *usernameField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;
@property (nonatomic, strong) User *currentUser;

- (IBAction)authenticate:(id)sender;
@end
