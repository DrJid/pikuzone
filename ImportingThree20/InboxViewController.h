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
#import "User.h"
#import "BarButtonMethods.h"
#import "EmailDetailViewController.h"

typedef enum
{
    MessageTypeInbox = 1,
    MessageTypeSent,
    MessageTypeDeleted,
}MessageType;

@interface InboxViewController : UIViewController <TTMessageControllerDelegate, RecipientViewControllerDelegate, UIAlertViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *theTableView;
@property (nonatomic, strong) NSString *cellIdentifier;
@property(nonatomic, strong) NSTimer* sendTimer;
@property(nonatomic, strong) TTMessageController *mainMessageController;
@property (nonatomic, strong) NSMutableArray *emailArray;
@property (nonatomic, strong) UILabel *statusLabel;

@property (nonatomic, strong) User *currentUser;
@property (nonatomic, strong) NSMutableArray *contactArray;
@property (nonatomic, strong) EmailDetailViewController *emailDetailViewController;
@property (nonatomic, copy) NSString *useOfViewController;
@property (nonatomic) MessageType messageType;


@property (weak, nonatomic) IBOutlet UIImageView *testImageview;


@end
