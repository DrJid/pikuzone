//
//  InboxViewController.h
//  PikuZone
//
//  Created by Maijid Moujaled on 7/2/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "Three20/Three20.h"
#import "SearchTestController.h"
#import "RecipientViewController.h"
#import "BarButtonMethods.h"

@interface InboxViewController : UIViewController <TTMessageControllerDelegate, RecipientViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UITableView *theTableView;
@property (nonatomic, copy) NSString *username;
@property (nonatomic, strong) NSString *cellIdentifier;
@property(nonatomic, strong) NSTimer* sendTimer;
@property(nonatomic, strong) TTMessageController *mainMessageController;
@property (nonatomic, strong) NSMutableArray *emailArray;
@property (nonatomic, strong) UILabel *statusLabel;



@end