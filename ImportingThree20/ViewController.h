//
//  ViewController.h
//  ImportingThree20
//
//  Created by Maijid Moujaled on 6/28/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

@class MockDataSource;


#import <UIKit/UIKit.h>
#import "Three20/Three20.h"
#import "SearchTestController.h"
#import "RecipientViewController.h"


@interface ViewController : UIViewController <TTMessageControllerDelegate, SearchTestControllerDelegate, RecipientViewControllerDelegate>
//- (IBAction)compose:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *composeButton;

@property(nonatomic, strong) NSTimer* sendTimer;

@property(nonatomic, strong) TTMessageController *mainMessageController;

@end
