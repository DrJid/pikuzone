//
//  EmailDetailViewController.h
//  PikuZone
//
//  Created by Maijid Moujaled on 7/2/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Message.h"

#import "Three20/Three20.h"
#import "SearchTestController.h"
#import "RecipientViewController.h"
#import "BarButtonMethods.h"

@interface EmailDetailViewController : UIViewController <TTMessageControllerDelegate, RecipientViewControllerDelegate>

@property(nonatomic, strong) Message *email;


@property (weak, nonatomic) IBOutlet UITableView *theTableView;
@property(nonatomic, strong) NSTimer* sendTimer;
@property(nonatomic, strong) TTMessageController *mainMessageController;

@property (nonatomic, strong) NSMutableArray *contactArray;


@end
