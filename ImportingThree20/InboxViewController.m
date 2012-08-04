//
//  InboxViewController.m
//  PikuZone
//
//  Created by Maijid Moujaled on 7/2/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "InboxViewController.h"
#import "MockDataSource.h"
#import "SearchTestController.h"
#import "MenuViewController.h"
#import "Message.h"
#import "EmailDetailViewController.h"
#import <Three20UI/UIViewAdditions.h>
#import "Contact.h"
#import "PikuZoneAPIClient.h"


#define kSenderLabel 1001
#define kTitleLabel 1002
#define kEmailDetailLabel 1003


@implementation InboxViewController
@synthesize theTableView;
@synthesize cellIdentifier;
@synthesize sendTimer = _sendTimer;
@synthesize mainMessageController;
@synthesize emailArray;
@synthesize statusLabel;
@synthesize contactArray;


#pragma mark - Custom Inbox Methods

- (void) showMenuOptions:(id)sender
{
    MenuViewController *menuViewController = [[MenuViewController alloc] init];
    UINavigationController *menuNavController = [[UINavigationController alloc] initWithRootViewController:menuViewController];

    [self.navigationController presentModalViewController:menuNavController animated:YES];
}

- (IBAction)refreshAction:(id)sender {
    
    //Get message called here. and the new data loaded up in a message object. And then added to the table. 
    
    Message *email6 = [[Message alloc] init];
    email6.senderName = @"Cynthia";
    email6.subject = @"PikuZone New Email";
    email6.messageBody = @"This is the new PikuZone email. The desire must be burning. Incessant. The power of desire backed by faith in yourself. can lift you up. Rob the grave of it's victims. But I must explain to you how all this mistaken idea of denouncing pleasure and praising pain was born and I will give you a complete account of the system, and expound the actual teachings of the great explorer of the truth, the master-builder of human happiness. No one rejects, dislikes, or avoids pleasure itself, because it is pleasure, but because those who do not know how to pursue pleasure rationally encounter consequences that are extremely painful. Nor again is there anyone who loves or pursues or desires to";
    
    Message *email7 = [[Message alloc] init];
    email7.senderName = @"Young Grandma";
    email7.subject = @"New Toy";
    email7.messageBody = @"This is the new toy email. The desire must be burning. Incessant. The power of desire backed by faith in yourself. can lift you up. Rob the grave of it's victims. But I must explain to you how all this mistaken idea of denouncing pleasure and praising pain was born and I will give you a complete account of the system, and expound the actual teachings of the great explorer of the truth, the master-builder of human happiness. No one rejects, dislikes, or avoids pleasure itself, because it is pleasure, but because those who do not know how to pursue pleasure rationally encounter consequences that are extremely painful. Nor again is there anyone who loves or pursues or desires to";

    
    
    int newRowIndex = 0 ; 
//    NSArray *newEmailArray = [NSArray arrayWithObjects:email6, email7, nil];
//    NSSet *newSet = [NSSet setWithObjects:0, 1, nil];

    [self.emailArray insertObject:email6 atIndex:0];
//    [self.emailArray insertObjects:newEmailArray atIndexes:newSet];
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:newRowIndex inSection:0];
    NSArray *indexPaths = [NSArray arrayWithObject:indexPath];
    [self.theTableView insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationFade];
    
    [self configureStatusLabel];
    
       
    BarButtonMethods *bbm = [[BarButtonMethods alloc] init];
    [bbm refreshAction]; 
}

-(void)configureStatusLabel {
    
    NSDate *now = [NSDate date];
	NSDateFormatter *formatter = nil;
    formatter = [[NSDateFormatter alloc] init];
	[formatter setTimeStyle:NSDateFormatterShortStyle];
    
    //    NSString *MyString;
    //	NSDate *now = [NSDate date];
    //	NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //	[dateFormatter setDateFormat:@"YY-MM-dd-HH-mm-ss"];
    //	MyString = [dateFormatter stringFromDate:now];
    //    
    NSDateFormatter *dateForm = [[NSDateFormatter alloc] init];
    [dateForm setDateFormat:@"MMM-dd"];
    
    
    NSString *update = [NSString stringWithFormat:@"Updated: %@ %@", [dateForm stringFromDate:now], [formatter stringFromDate:now]];
    
    //        NSString *update = [NSString stringWithFormat:@"Updated: %@", MyString];
    
    self.statusLabel.text =  update;
    [self.statusLabel sizeToFit];

    
}

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
    
    //Set up the screen navigation bar
    self.title = @"Inbox";
    self.navigationItem.rightBarButtonItem = self.editButtonItem;
    UIBarButtonItem *menuButton = [[UIBarButtonItem alloc] initWithTitle:@"Menu"
                                                                   style:UIBarButtonItemStyleBordered
                                                                  target:self
                                                                  action:@selector(showMenuOptions:)];
    self.navigationItem.leftBarButtonItem = menuButton;
    
    //Customize the navigation Toolbar! 
    self.navigationController.toolbarHidden = NO;
    
    self.statusLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 11, self.view.size.width/3, 21.0f)];
    
    self.statusLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:13];
    [self.statusLabel setTextAlignment:UITextAlignmentCenter];
    self.statusLabel.backgroundColor = [UIColor clearColor];
    self.statusLabel.textColor = [UIColor whiteColor];
    self.statusLabel.shadowColor = [UIColor colorWithRed:0.1 green:0.1 blue:0.1 alpha:1];
    self.statusLabel.shadowOffset = CGSizeMake(0, -0.7);
    
    [self configureStatusLabel];
    
    UIBarButtonItem *labelItem = [[UIBarButtonItem alloc] initWithCustomView:self.statusLabel];
    
    UIBarButtonItem *spaceItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];

    UIBarButtonItem *compose = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCompose target:self action:@selector(composeNewMessage:)];
    
    UIBarButtonItem *refreshAction = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(refreshAction:)];
    
    NSArray *toolbarItems = [NSArray arrayWithObjects:refreshAction, spaceItem, labelItem, spaceItem, compose, nil];
    
    [self setToolbarItems:toolbarItems animated:YES];
    
    //Register the NIB cell object
    self.cellIdentifier = @"InboxCell";
    [theTableView registerNib:[UINib nibWithNibName:@"EmailCell" bundle:nil] forCellReuseIdentifier:self.cellIdentifier];
    
    
    
//    //Create Email Test Data! 
//    Message *email1 = [[Message alloc] init];
//    email1.senderName = @"Steve";
//    email1.subject = @"How was the exam?";
//    email1.messageBody = @"I hope it was all okay. Did you remember Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.";
//    
//    Message *email2 = [[Message alloc] init];
//    email2.senderName = @"Young Grandma";
//    email2.subject = @"I found your toy!";
//    email2.messageBody = @"It was in the shower.";
//    
//    Message *email3 = [[Message alloc] init];
//    email3.senderName = @"Cousin Mary";
//    email3.subject = @"Medium Sized Message";
//    email3.messageBody = @"I forgot the name but... Sed ut perspiciatis unde omnis iste natus error sit voluptatem accusantium doloremque laudantium, totam rem aperiam, eaque ipsa quae ab illo inventore veritatis et quasi architecto beatae vitae dicta sunt explicabo. Nemo enim ipsam voluptatem quia voluptas sit aspernatur aut odit aut fugit, sed quia consequuntur magni dolores eos qui ratione voluptatem sequi nesciunt. Neque porro quisquam est, qui dolorem ipsum quia dolor sit amet, consectetur, adipisci velit, sed quia non numquam eius modi tempora";
//    
//    Message *email4 = [[Message alloc] init];
//    email4.senderName = @"Cynthia";
//    email4.subject = @"Who is Cicero?";
//    email4.messageBody = @"But I must explain to you how all this mistaken idea of denouncing pleasure and praising pain was born and I will give you a complete account of the system, and expound the actual teachings of the great explorer of the truth, the master-builder of human happiness. No one rejects, dislikes, or avoids pleasure itself, because it is pleasure, but because those who do not know how to pursue pleasure rationally encounter consequences that are extremely painful. Nor again is there anyone who loves or pursues or desires to";
//    
//    Message *email5 = [[Message alloc] init];
//    email5.senderName = @"Maijid";
//    email5.subject = @"PikuZone Progress";
//    email5.messageBody = @"But I must explain to you how all this mistaken idea of denouncing pleasure and praising pain was born and I will give you a complete account of the system, and expound the actual teachings of the great explorer of the truth, the master-builder of human happiness. No one rejects, dislikes, or avoids pleasure itself, because it is pleasure, but because those who do not know how to pursue pleasure rationally encounter consequences that are extremely painful. Nor again is there anyone who loves or pursues or desires to";
//    
//    self.emailArray = [NSMutableArray arrayWithObjects:email1, email2, email3, email4,  email5, nil ];
    self.emailArray = [NSMutableArray arrayWithCapacity:5];
    self.contactArray = [NSMutableArray arrayWithCapacity:5];
    
    //We can download the user's contacts and stuff with a method in here. It should do it on a different thread obviously.
    //getContacts(user.sessionTokenString) sends post and recieve an array of Contact Objects.
    
    NSDictionary *params = [NSDictionary dictionaryWithObject:self.currentUser.sessionToken forKey:@"sessionToken"];
    
    [[PikuZoneAPIClient sharedInstance] postPath:@"GetMessages.ashx"
                                      parameters:params
                                         success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                             //success
                                             
                                             //if status == 1 don't forget to check NTS. 
                                             NSDictionary *completeMessageDict = [responseObject objectForKey:@"Messages"];
//                                             NSLog(@"Count: %i", completeMessageDict.count);
                                             
                                             for (NSDictionary *singleMessageDict in completeMessageDict) {
                                                 Message *message = [[Message alloc] initWithMessageDictionary:singleMessageDict];
//                                                 NSLog(@"single: %@", singleMessageDict);
                                                 
                                                 [self.emailArray addObject:message];
                                             }
                                             
//                                             NSLog(@"response: %@", completeMessageDict);
                                             [theTableView reloadData];
                                         } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                             //failure
                                             NSLog(@"%@", [error localizedDescription]);
                                             
                                         }];
    
    
    [[PikuZoneAPIClient sharedInstance] postPath:@"GetContacts.ashx" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        //success
        
        //if status == 1 make sure you check
        NSDictionary *completeContactDict = [responseObject objectForKey:@"Contacts"];
        
        for (NSDictionary *singleContactDict in completeContactDict) {
            Contact *contact = [[Contact alloc] initWithContactDictionary:singleContactDict];
            
            [self.contactArray addObject:contact];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        //failure
        NSLog(@"%@", [error localizedDescription]);
        
    }];
    
    NSLog(@"self.contactarray %@", self.contactArray);
    
    
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



#pragma mark - TableViewController Methods

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 66;
}

// Customize the number of sections in the table view.
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.emailArray.count;
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
//       static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:self.cellIdentifier];
    
    UILabel *senderLabel = (UILabel *)[cell viewWithTag:kSenderLabel];
    UILabel *titleLabel = (UILabel *)[cell viewWithTag:kTitleLabel];
    UILabel *previewLabel = (UILabel *)[cell viewWithTag:kEmailDetailLabel];
    
    
    
    Message *email = [self.emailArray objectAtIndex:indexPath.row];
//    
    senderLabel.text = email.senderName;
    titleLabel.text = email.subject;
    previewLabel.text = email.messageBody;
    
    
//       if (cell == nil) {
//            //Create cell structure here. 
//            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:self.cellIdentifier];
//           cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
//        }
//    
//    // Configure the cell and custom content
//        cell.textLabel.text = email.subject;
    
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


// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source.
        [self.emailArray removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
        
        //Put it in the deleted inbox here. 
        
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
    }   
}


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
    
    Message *selectedEmail = [self.emailArray objectAtIndex:indexPath.row];
    
    EmailDetailViewController *emailDetailViewController = [[EmailDetailViewController alloc] init];
    emailDetailViewController.email = selectedEmail;
    
    NSLog(@"%@", selectedEmail.subject);
    
    [self.theTableView deselectRowAtIndexPath:indexPath animated:YES];
    [self.navigationController pushViewController:emailDetailViewController animated:YES];
}

-(void)setEditing:(BOOL)editing animated:(BOOL)animated {
    [super setEditing:editing animated:animated];
    [theTableView setEditing:editing animated:animated];
}


#pragma mark - Message Controller Delegate and Methods

///////////////////////////////////////////////////////////////////////////////////////////////////
// private

- (UIViewController*)composeTo:(NSString*)recipient {
    //    TTTableTextItem* item = [TTTableTextItem itemWithText:@"Cousin" URL:nil];
    //    
    //    TTTableTextItem* item2 = [TTTableTextItem itemWithText:@"Papa" URL:nil];
    //    
    
    TTMessageController* controller = [[TTMessageController alloc] initWithRecipients:nil];
    controller.dataSource =  [[MockSearchDataSource alloc] init];
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

#pragma mark - Sending messages methods
- (void)composeController:(TTMessageController*)controller didSendFields:(NSArray*)fields {
    _sendTimer = [NSTimer scheduledTimerWithTimeInterval:1 
                                                  target:self
                                                selector:@selector(sendDelayed:) 
                                                userInfo:fields 
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
        Contact *recipient = [rvc getRecipientForName:name];
        NSLog(@"Name: %@, Email: %@", recipient.name, recipient.email);
        
    }
    
    
    [self.modalViewController dismissModalViewControllerAnimated:YES];
}


- (void)composeControllerWillCancel:(TTMessageController *)controller {
    //It just cancels. Wanna do anything here? Don't really think so..
}

- (void)composeControllerDidCancel:(TTMessageController*)controller {
    [_sendTimer invalidate];
    _sendTimer = nil;
    [controller dismissModalViewControllerAnimated:YES];
}

- (void)composeControllerShowRecipientPicker:(TTMessageController*)controller {
    
//    WE ARENT USING THE SEARCH TEST controller AT ATLL
    
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
    
    
    RecipientViewController *recipientController = [[RecipientViewController alloc] initWithStyle:UITableViewStylePlain contacts:self.contactArray];
    
    //Here we use the contact array we got from the GetContacts method and send it to the recipientsController. And will be used as the datasource. 
    
    
    recipientController.delegate = self;
    recipientController.title = @"Family Book";
    recipientController.navigationItem.prompt = @"Select a recipient";
    
    UINavigationController* navController = [[UINavigationController alloc] initWithRootViewController:recipientController];
    
    [controller presentModalViewController:navController animated:YES];
    
}

///////////////////////////////////////////////////////////////////////////////////////////////////
// SearchTestControllerDelegate

//- (void)searchTestController:(SearchTestController*)controller didSelectObject:(id)object {
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



#pragma mark - Recipient View Controller Delegate
- (void)recipientViewController:(RecipientViewController*)controller didSelectRecipient:(Contact *)recipient {
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
    self.mainMessageController = (TTMessageController *)[self composeTo:nil];
    self.mainMessageController.delegate = self;
    
    
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
