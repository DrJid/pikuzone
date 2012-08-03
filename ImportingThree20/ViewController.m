//
//  ViewController.m
//  ImportingThree20
//
//  Created by Maijid Moujaled on 6/28/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ViewController.h"
#import "MockDataSource.h"
#import "SearchTestController.h"

#import <Three20UI/UIViewAdditions.h>


#import "RecipientViewController.h"


@implementation ViewController
@synthesize composeButton = _composeButton;
@synthesize sendTimer = _sendTimer;
@synthesize mainMessageController;

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    //    
    //    //We'll add the target right here in the ViewDidLoad. 
    //    
    //    CGRect appFrame = [UIScreen mainScreen].applicationFrame;
    //    //    self.view = [[UIView alloc] initWithFrame:appFrame];
    //    //    self.view.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1];;
    //
    //    
    //        UIButton* button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    //            [button setTitle:@"Show TTMessageController" forState:UIControlStateNormal];
    //            [button addTarget:@"tt://compose?to=Papa" action:@selector(openURL)
    //             forControlEvents:UIControlEventTouchUpInside];
    //            button.frame = CGRectMake(20, 20, appFrame.size.width - 40, 50);
    //            [self.view addSubview:button];
    //    
    //    [self.composeButton addTarget:@"tt://compose?to=Tej" action:@selector(openURL) forControlEvents:UIControlEventTouchUpInside];
    //    
    
}

- (void)viewDidUnload
{
    [self setComposeButton:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}




///////////////////////////////////////////////////////////////////////////////////////////////////
// private

- (UIViewController*)composeTo:(NSString*)recipient {
//    TTTableTextItem* item = [TTTableTextItem itemWithText:@"Cousin" URL:nil];
//    
//    TTTableTextItem* item2 = [TTTableTextItem itemWithText:@"Papa" URL:nil];
//    
    
    TTMessageController* controller = [[TTMessageController alloc] initWithRecipients:nil];
    controller.dataSource = [[MockSearchDataSource alloc] init];
    controller.delegate = self;
    controller.showsRecipientPicker = YES;
    
    return controller;
}

//- (UIViewController*)post:(NSDictionary*)query {
//    TTPostController* controller = [[TTPostController alloc] initWithNavigatorURL:nil
//                                                                             query:
//                                     [NSDictionary dictionaryWithObjectsAndKeys:@"Default Text", @"text", nil]];
//    controller.originView = [query objectForKey:@"__target__"];
//    return controller;
//    
//}

- (void)cancelAddressBook {
    //    [[TTNavigator navigator].visibleViewController dismissModalViewControllerAnimated:YES];
    //    [self.navigationController dismissModalViewControllerAnimated:YES];
    [self.presentingViewController  dismissViewControllerAnimated:YES completion:nil];
    
    
}

- (void)sendDelayed:(NSTimer*)timer {
    _sendTimer = nil;
    
    NSArray* fields = timer.userInfo;
    UIView* lastView = [self.view.subviews lastObject];
    CGFloat y = lastView.bottom + 20;
    
    TTMessageRecipientField* toField = [fields objectAtIndex:0];
    for (id recipient in toField.recipients) {
        UILabel* label = [[UILabel alloc] init];
        label.backgroundColor = self.view.backgroundColor;
        label.text = [NSString stringWithFormat:@"Message sent to: %@", recipient];
        [label sizeToFit];
        label.frame = CGRectMake(30, y, label.width, label.height);
        y += label.height;
        [self.view addSubview:label];
    }
    
    
    [self.modalViewController dismissModalViewControllerAnimated:YES];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
// NSObject

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        _sendTimer = nil;
        
        [[TTNavigator navigator].URLMap from:@"tt://compose?to=(composeTo:)"
                       toModalViewController:self selector:@selector(composeTo:)];
        
        [[TTNavigator navigator].URLMap from:@"tt://post"
                            toViewController:self selector:@selector(post:)];
    }
    return self;
}

- (void)dealloc {
    [[TTNavigator navigator].URLMap removeURL:@"tt://compose?to=(composeTo:)"];
    [[TTNavigator navigator].URLMap removeURL:@"tt://post"];
    [_sendTimer invalidate];
    //[super dealloc];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
// UIViewController

//- (void)loadView {
//    CGRect appFrame = [UIScreen mainScreen].applicationFrame;
//    self.view = [[UIView alloc] initWithFrame:appFrame];
//    self.view.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1];;
//    
//    UIButton* button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
//    [button setTitle:@"Show TTMessageController" forState:UIControlStateNormal];
//    [button addTarget:@"tt://compose?to=Alan%20Jones" action:@selector(openURL)
//     forControlEvents:UIControlEventTouchUpInside];
//    button.frame = CGRectMake(20, 20, appFrame.size.width - 40, 50);
//    [self.view addSubview:button];
//    
//    UIButton* button2 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
//    [button2 setTitle:@"Show TTPostController" forState:UIControlStateNormal];
//    [button2 addTarget:@"tt://post" action:@selector(openURLFromButton:)
//      forControlEvents:UIControlEventTouchUpInside];
//    button2.frame = CGRectMake(20, button.bottom + 20, appFrame.size.width - 40, 50);
//    [self.view addSubview:button2];
//}

//- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
//    return TTIsSupportedOrientation(interfaceOrientation);
//}

///////////////////////////////////////////////////////////////////////////////////////////////////
// TTMessageControllerDelegate

- (void)composeController:(TTMessageController*)controller didSendFields:(NSArray*)fields {
    _sendTimer = [NSTimer scheduledTimerWithTimeInterval:2 target:self
                                                selector:@selector(sendDelayed:) userInfo:fields repeats:NO];
}

- (void)composeControllerWillCancel:(TTMessageController *)controller {
    NSLog(@"It's about to cancel");
}

- (void)composeControllerDidCancel:(TTMessageController*)controller {
    [_sendTimer invalidate];
    _sendTimer = nil;
    
    [controller dismissModalViewControllerAnimated:YES];
    NSLog(@"Called it");
}

- (void)composeControllerShowRecipientPicker:(TTMessageController*)controller {
    
    
    //Will make MY own view and place it here... 
    //    
    SearchTestController* searchController = [[SearchTestController alloc] init];
    searchController.delegate = self;
    searchController.title = @"Family Book";
    searchController.navigationItem.prompt = @"Select a recipient";
//    searchController.navigationItem.rightBarButtonItem =
//    [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
//                                                  target:self action:@selector()];
    
    //    UINavigationController* navController = [[UINavigationController alloc] init];
    //    [navController pushViewController:searchController animated:NO];
    
    
    //    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Test" message:@"Control" delegate:self cancelButtonTitle:@"Okay" otherButtonTitles: nil];
    //    [alert show];
    
    
    RecipientViewController *recipientController = [[RecipientViewController alloc] init];
    recipientController.delegate = self;
    recipientController.title = @"Family Book";
    recipientController.navigationItem.prompt = @"Select a recipient";
    
        UINavigationController* navController = [[UINavigationController alloc] initWithRootViewController:recipientController];
    
    [controller presentModalViewController:navController animated:YES];

    
    
}

///////////////////////////////////////////////////////////////////////////////////////////////////
// SearchTestControllerDelegate

- (void)searchTestController:(SearchTestController*)controller didSelectObject:(id)object {
    NSLog(@"Supposed to be the search");
    //I need a reference to the TTMessage Controller
    
    
    TTMessageController* composeController = (TTMessageController*)controller;//controller.navigationController ;// self.navigationController.topViewController ;
    NSLog(@"Del Cont: %@", [self.mainMessageController class]);
    
    [self.mainMessageController addRecipient:object forFieldAtIndex:0];
    [controller dismissModalViewControllerAnimated:YES];
}


- (void)recipientViewController:(RecipientViewController*)controller didSelectObject:(id)object {
    NSLog(@"Supposed to be the search");
    //I need a reference to the TTMessage Controller
    
    
    TTMessageController* composeController = (TTMessageController*)controller;//controller.navigationController ;// self.navigationController.topViewController ;
    NSLog(@"Del Cont: %@", [self.mainMessageController class]);
    
    [self.mainMessageController addRecipient:object forFieldAtIndex:0];
    [controller dismissModalViewControllerAnimated:YES];
}

//- (void)searchTestControllerdidCancel:(SearchTestController*)controller {
//    [controller dismissModalViewControllerAnimated:YES];
//}


- (void)recipientViewControllerdidCancel:(SearchTestController*)controller {
    [controller dismissModalViewControllerAnimated:YES];
}






- (IBAction)compose:(id)sender {
    
    //    NSArray *recipients = [[NSArray alloc] initWithObjects:@"Dad", nil];
    //    TTMessageRecipientField *recipient = [[TTMessageRecipientField alloc] initWithTitle:@"Dad" required:NO];
    
    //    TTTableTextItem *item = [TTTableTextItem itemWithText:@"Test"];
    
    //    self.mainMessageController = [[TTMessageController alloc] init];
    //    NSLog(@"Class: %@", [messageComposer class]);
    
    //    TTMessageController *messageComp = [self composeTo:@"huh"];
    self.mainMessageController = [self composeTo:@"huh"];
    
    self.mainMessageController.delegate = self;
    
    //    TTNavigator *messagNavCon = [[TTNavigator alloc] pr
    
    UINavigationController *messageNavController = [[UINavigationController alloc] initWithRootViewController:self.mainMessageController];
    
    //  [[TTNavigator navigator].visibleViewController presentModalViewController:messageComp animated:YES];
    [self presentModalViewController:messageNavController animated:YES];
    //    [self.navigationController pushViewController:messageComp animated:YES];
    
    
    //    UIButton* button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    //    [button setTitle:@"Show TTMessageController" forState:UIControlStateNormal];
    //    [button addTarget:@"tt://compose?to=Alan%20Jones" action:@selector(openURL)
    //     forControlEvents:UIControlEventTouchUpInside];
    //    button.frame = CGRectMake(20, 20, appFrame.size.width - 40, 50);
    //    [self.view addSubview:button];
    
    
    
}


@end
