//
//  EmailDetailViewController.m
//  PikuZone
//
//  Created by Maijid Moujaled on 7/2/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "EmailDetailViewController.h"
#import "MockDataSource.h"
#import "SearchTestController.h"
#import <Three20UI/UIViewAdditions.h>


#define FromRow     0
#define SubjectRow  1
#define EmailRow    2

@implementation EmailDetailViewController
@synthesize email;
@synthesize theTableView;
@synthesize sendTimer = _sendTimer;
@synthesize mainMessageController;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.title = self.email.subject;
    NSLog(@"Email Subject %@", self.email.subject);
    
    self.theTableView.allowsSelection = NO;
    
    
    self.navigationController.toolbarHidden = NO;
    
    
    UIBarButtonItem *spaceItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
//    UIBarButtonItem *fixedSpaceItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    
    UIBarButtonItem *deleteItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemTrash target:self action:nil];
    
    UIBarButtonItem *compose = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCompose target:self action:@selector(composeNewMessage:)];
    
    UIBarButtonItem *refreshAction = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(refreshAction:)];
    
    UIBarButtonItem *replyButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemReply target:self action:@selector(replyAction:)];
    
    NSArray *toolbarItems = [NSArray arrayWithObjects:refreshAction, spaceItem, deleteItem, spaceItem, replyButton, spaceItem, compose, nil];
    
    [self setToolbarItems:toolbarItems animated:YES];

    
}

- (void)viewDidUnload
{
    [self setTheTableView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;

}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Other Bar Button Methods



- (IBAction)replyAction:(id)sender {
    
    self.mainMessageController = (TTMessageController *)[self composeTo:email.senderName];
    
    self.mainMessageController.delegate = self;
    NSString *replyTitle = [NSString stringWithFormat:@"Re: %@", email.subject];
    self.mainMessageController.subject = replyTitle;  
    self.mainMessageController.title = replyTitle;

 
    UINavigationController *messageNavController = [[UINavigationController alloc] initWithRootViewController:self.mainMessageController];
    
    //  [[TTNavigator navigator].visibleViewController presentModalViewController:messageComp animated:YES];
    //    [self.navigationController pushViewController:messageComp animated:YES];
 
    [self presentModalViewController:messageNavController animated:YES];

    
    [self.mainMessageController.bodyField setSelectedRange:NSMakeRange(0, 0)];
    
    NSString *replyToMessage = [NSString stringWithFormat:@"\n\n%@ wrote:\n\n%@", email.senderName, email.messageBody];
    
    [self.mainMessageController.bodyField setTextSpeciale:replyToMessage];
    
    [self.mainMessageController.bodyField setSelectedRange:NSMakeRange(0, 0)];
    
////    
//    [self.mainMessageController.scrollView setContentOffset:CGPointMake(0,0) animated:NO];
//    
//        [self.mainMessageController.scrollView scrollRectToVisible:CGRectMake(0, 0, 0, 0) animated:NO];
    
    
}

- (IBAction)refreshAction:(id)sender {
    BarButtonMethods *bbm = [[BarButtonMethods alloc] init];
    [bbm refreshAction]; 
}


#pragma mark - TableView methods

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == EmailRow) {
        
        CGSize emailSize = [email.messageBody sizeWithFont:[UIFont systemFontOfSize:16] constrainedToSize:CGSizeMake(320, 480) lineBreakMode:UILineBreakModeWordWrap];
        
//        NSLog(@"Size: %f", emailSize.height * 1.2);
        if (emailSize.height * 1.2 < 300 ) {
            return 300;
        }
        return emailSize.height * 1.2;
    }
    else return 44;
}

// Customize the number of sections in the table view.
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    
    if (indexPath.row == FromRow) {
        
        
        CGRect frame=CGRectMake(10,2, 80, 40);
        UILabel *label1 = [[UILabel alloc]init];            
        label1.frame=frame;
        label1.textColor = [UIColor grayColor];
        label1.minimumFontSize = 8;
        label1.text=@"From:";
        label1.tag = 1001;
        [cell.contentView addSubview:label1];
        
    
        CGRect frame2=CGRectMake(60,2, 200, 40);
        UILabel *label2 = [[UILabel alloc]init];            
        label2.frame=frame2;
//        label2.textColor = [UIColor grayColor];
        label2.minimumFontSize = 7;
        label2.text=email.senderName;
        label2.tag = 1002;
        [cell.contentView addSubview:label2];
        
//        
//        
//        
//        cell.textLabel.text = @"From:";
//        cell.textLabel.minimumFontSize = 8;
//        cell.textLabel.textColor = [UIColor grayColor];
//        cell.textLabel.numberOfLines = 1;
//        cell.textLabel.adjustsFontSizeToFitWidth = YES;
        
        return cell;
    }
    
    //This is the subject field
    else if (indexPath.row == SubjectRow) {
        
        CGRect frame=CGRectMake(12,10, 310, 20);

        UILabel *subjectLabel = [[UILabel alloc]init];            
        subjectLabel.frame=frame;
        subjectLabel.font = [UIFont systemFontOfSize:15];
        subjectLabel.text=email.subject;
        subjectLabel.tag = 1004;
        [cell.contentView addSubview:subjectLabel];
        return cell;
    }
    
    else if (indexPath.row == EmailRow) {
        
        CGSize emailSize = [email.messageBody sizeWithFont:[UIFont systemFontOfSize:16] constrainedToSize:CGSizeMake(320, 480) lineBreakMode:UILineBreakModeWordWrap];
                
        UITextView *bodyTextView = [[UITextView alloc] initWithFrame:CGRectMake(5, 5, 310, emailSize.height + 100)];
        
        bodyTextView.text = email.messageBody;
        bodyTextView.font = [UIFont systemFontOfSize:16]; // [UIFont fontWithName:@"Cochin" size:16];
        bodyTextView.editable = NO;

        
        [cell.contentView addSubview:bodyTextView];
        
        


        
        return cell;
    }    

    return cell;
}

/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */

/*
 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
 {
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 // Delete the row from the data source.
 [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
 } else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
 }   
 }
 */

/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
 {
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //    if (!self.detailViewController) {
    //        self.detailViewController = [[MMDetailViewController alloc] initWithNibName:@"MMDetailViewController" bundle:nil];
    //    }
    //    [self.navigationController pushViewController:self.detailViewController animated:YES];
}





#pragma mark - Message Controller Delegate and Methods

///////////////////////////////////////////////////////////////////////////////////////////////////
// private

- (UIViewController*)composeTo:(NSString*)recipient {
    //    TTTableTextItem* item = [TTTableTextItem itemWithText:@"Cousin" URL:nil];
    //    
//        TTTableTextItem* item2 = [TTTableTextItem itemWithText:@"Papa" URL:nil];
    //    
    NSArray *recipients = [NSArray arrayWithObjects:recipient, nil];
    
    
    TTMessageController* controller = [[TTMessageController alloc] initWithRecipients:recipients];
    controller.dataSource = [[MockSearchDataSource alloc] init];
    controller.delegate = self;
    controller.showsRecipientPicker = YES;
    
    return controller;
}



- (void)cancelAddressBook {
    //    [[TTNavigator navigator].visibleViewController dismissModalViewControllerAnimated:YES];
    //    [self.navigationController dismissModalViewControllerAnimated:YES];
    [self.presentingViewController  dismissViewControllerAnimated:YES completion:nil];
    
    
}


///////////////////////////////////////////////////////////////////////////////////////////////////
// NSObject

//- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
//    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
//        _sendTimer = nil;
//        
//        [[TTNavigator navigator].URLMap from:@"tt://compose?to=(composeTo:)"
//                       toModalViewController:self selector:@selector(composeTo:)];
//        
//        [[TTNavigator navigator].URLMap from:@"tt://post"
//                            toViewController:self selector:@selector(post:)];
//    }
//    return self;
//}

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
    _sendTimer = [NSTimer scheduledTimerWithTimeInterval:2 
                                                  target:self
                                                selector:@selector(sendDelayed:) userInfo:fields 
                                                 repeats:NO];
    NSLog(@"Some messages are about to be sent");

}

- (void)sendDelayed:(NSTimer*)timer {
    _sendTimer = nil;
    
    NSArray* fields = timer.userInfo;
    
    TTMessageSubjectField *subjectField = [fields objectAtIndex:1];
    NSLog(@"Subject: %@", subjectField.text);
    
    TTMessageTextField *messageBodyField = [fields objectAtIndex:2];
    NSLog(@"Message Body: %@", messageBodyField.text);
    
    
    RecipientViewController *rvc = [[RecipientViewController alloc] init];
    
    TTMessageRecipientField* toField = [fields objectAtIndex:0];
    for (NSString *name in toField.recipients) {
        
        //Get the actual recipient class: 
        Recipient *recipient = [rvc getRecipientForName:name];
        NSLog(@"Name: %@, Email: %@", recipient.name, recipient.email);
        
    }
    
    
    [self.modalViewController dismissModalViewControllerAnimated:YES];
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
//    SearchTestController* searchController = [[SearchTestController alloc] init];
//    searchController.delegate = self;
//    searchController.title = @"Family Book";
//    searchController.navigationItem.prompt = @"Select a recipient";
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
//
//- (void)searchTestController:(SearchTestController*)controller didSelectObject:(id)object {
//    NSLog(@"Supposed to be the search");
//    //I need a reference to the TTMessage Controller
//
//    NSLog(@"Del Cont: %@", [self.mainMessageController class]);
//    
//    [self.mainMessageController addRecipient:object forFieldAtIndex:0];
//    [controller dismissModalViewControllerAnimated:YES];
//}

#pragma mark - Recipient View Controller Delegate

//- (void)recipientViewController:(RecipientViewController*)controller didSelectObject:(id)object {
//    NSLog(@"Supposed to be the search");
//    //I need a reference to the TTMessage Controller
//    
//    
//    TTMessageController* composeController = (TTMessageController*)controller;//controller.navigationController ;// self.navigationController.topViewController ;
//    NSLog(@"Del Cont: %@", [self.mainMessageController class]);
//    
//    [self.mainMessageController addRecipient:object forFieldAtIndex:0];
//    [controller dismissModalViewControllerAnimated:YES];
//}


- (void)recipientViewController:(RecipientViewController*)controller didSelectRecipient:(Recipient *)recipient {
    NSLog(@"Selected %@ email address: %@", recipient.name, recipient.email);    
    
    //    TTMessageController* composeController = (TTMessageController*)controller;//controller.navigationController ;// self.navigationController.topViewController ;
    //    NSLog(@"Del Cont: %@", [self.mainMessageController class]);
    //    
    NSString *recipientName = recipient.name;
    [self.mainMessageController addRecipient:recipientName forFieldAtIndex:0];
    [controller dismissModalViewControllerAnimated:YES];
}



- (void)recipientViewControllerdidCancel:(SearchTestController*)controller {
    [controller dismissModalViewControllerAnimated:YES];
}





- (IBAction)composeNewMessage:(id)sender {
    
    
    //    NSArray *recipients = [[NSArray alloc] initWithObjects:@"Dad", nil];
    //    TTMessageRecipientField *recipient = [[TTMessageRecipientField alloc] initWithTitle:@"Dad" required:NO];
    
    //    TTTableTextItem *item = [TTTableTextItem itemWithText:@"Test"];
    
    //    self.mainMessageController = [[TTMessageController alloc] init];
    //    NSLog(@"Class: %@", [messageComposer class]);
    
    //    TTMessageController *messageComp = [self composeTo:@"huh"];
    self.mainMessageController = [self composeTo:nil];
    
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
