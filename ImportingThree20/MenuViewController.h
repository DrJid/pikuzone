//
//  MenuViewController.h
//  PikuZone
//
//  Created by Maijid Moujaled on 7/2/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "User.h"
#import "InboxViewController.h"

@interface MenuViewController : UITableViewController

@property (nonatomic, strong) User *currentUser;

//We give the Menu View Controller an Inbox View Controller since it's always already loaded. 
@property (nonatomic, strong) InboxViewController *inboxViewController;

@end
