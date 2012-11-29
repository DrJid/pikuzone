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
#import "AppDelegate.h"


#define kSenderLabel 1001
#define kTitleLabel 1002
#define kEmailDetailLabel 1003
#define kReadTag 1004


@implementation InboxViewController {
    UIAlertView *sendingErrorAlert;
    BOOL lastMessageErred;
    NSString *savedMessageBodyTextFromError;
    NSString *savedTitleTextFromError;
}
@synthesize theTableView;
@synthesize cellIdentifier;
@synthesize sendTimer = _sendTimer;
@synthesize mainMessageController;
@synthesize emailArray;
@synthesize statusLabel;
@synthesize contactArray;
@synthesize testImageview;
@synthesize emailDetailViewController;
@synthesize useOfViewController;
@synthesize messageType;

#pragma mark - Custom Inbox Methods

- (void) showMenuOptions:(id)sender
{
    MenuViewController *menuViewController = [[MenuViewController alloc] init];
    menuViewController.currentUser = self.currentUser;
    UINavigationController *menuNavController = [[UINavigationController alloc] initWithRootViewController:menuViewController];

//    [self.navigationController presentModalViewController:menuNavController animated:YES];
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (IBAction)refreshAction:(id)sender
{
    
    //Get message called here. and the new data loaded up in a message object. And then added to the table.
    
    Message *email6 = [[Message alloc] init];
    email6.senderName = @"Cynthia";
    email6.subject = @"PikuZone New Email";
    email6.messageBody = @"This is the new PikuZone email. The desire must be burning. Incessant. The power of desire backed by faith in yourself. can lift you up. Rob the grave of it's victims. But I must explain to you how all this mistaken idea of denouncing pleasure and praising pain was born and I will give you a complete account of the system, and expound the actual teachings of the great explorer of the truth, the master-builder of human happiness. No one rejects, dislikes, or avoids pleasure itself, because it is pleasure, but because those who do not know how to pursue pleasure rationally encounter consequences that are extremely painful. Nor again is there anyone who loves or pursues or desires to";
    
    Message *email7 = [[Message alloc] init];
    email7.senderName = @"Young Grandma";
    email7.subject = @"Second PikuZone new Email";
    email7.messageBody = @"This is the new toy email. The desire must be burning. Incessant. The power of desire backed by faith in yourself. can lift you up. Rob the grave of it's victims. But I must explain to you how all this mistaken idea of denouncing pleasure and praising pain was born and I will give you a complete account of the system, and expound the actual teachings of the great explorer of the truth, the master-builder of human happiness. No one rejects, dislikes, or avoids pleasure itself, because it is pleasure, but because those who do not know how to pursue pleasure rationally encounter consequences that are extremely painful. Nor again is there anyone who loves or pursues or desires to";
    
    
    NSMutableArray *newMessages = [[NSMutableArray alloc] initWithCapacity:5];
  
    
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            self.currentUser.sessionToken , @"sessionToken",
                            [NSNumber numberWithInt:self.messageType], @"messageType", nil];
    
    [[PikuZoneAPIClient sharedInstance] postPath:@"GetMessages.ashx"
                                      parameters:params
                                         success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                             //success
                                             
                                             if ([[responseObject objectForKey:@"Status"] intValue] == 1)  //Connection successful
                                             {
                                                 NSDictionary *completeMessageDict = [responseObject objectForKey:@"Messages"];
                                                 
                                                 
                                                 for (NSDictionary *singleMessageDict in completeMessageDict) {
                                                     Message *message = [[Message alloc] initWithMessageDictionary:singleMessageDict];
                                                     BOOL found = NO;
                                                     for (Message *currentMessage in self.emailArray)
                                                     {
                                                         if (currentMessage.messageID == message.messageID)
                                                         {
                                                             found = YES;
                                                         }
                                                     }
                                                     if (!found)
                                                     {
                                                         [newMessages addObject:message];
                                                     }
                                                 }
                                                 
                                                 //Add new Messages to the new Email Array
                                                 NSArray *newEmailArray = [NSArray arrayWithObjects:email6, email7, nil];
                                                 for (Message *message in newMessages)
                                                 {
                                                     int index = 0;
                                                     [self.emailArray insertObject:message atIndex:index];
                                                     index++;
                                                 }
                                                 
                                                 //Create an array of indexPaths
                                                 NSMutableArray *insertIndexPaths = [[NSMutableArray alloc] initWithCapacity:3];
                                                 for (int i = 0; i < newMessages.count ; i++)
                                                 {
                                                     [insertIndexPaths addObject:[NSIndexPath indexPathForRow:i inSection:0]];
                                                 }
                                                 
                                                 [self.theTableView insertRowsAtIndexPaths:insertIndexPaths withRowAnimation:UITableViewRowAnimationMiddle];
                                                 
                                              //   NSLog(@"New messages: %@", newMessages);
                                                 
                                                 [self configureStatusLabel];

                                             }
                                             else if ([[responseObject objectForKey:@"Status"] intValue] == -100 ) //Session invalidated
                                             {
                                                 //Return to Login Screen
                                                 UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"[Dev Note]You have been logged out. Perhaps you logged in a different device. or your session timed out. Pressing okay will send you to the login page" delegate:self cancelButtonTitle:@"Okay" otherButtonTitles:nil];
                                                 [alert show];
                                                 
                                             }
                                             
                                         } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                             //failure
                                             NSLog(@"%@", [error localizedDescription]);
                                             
                                         }];

  
    
}

-(void)configureStatusLabel
{
    
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
    
    // NSString *update = [NSString stringWithFormat:@"Updated: %@", MyString];
    
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

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
       
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    //Set up the screen navigation bar
    if (self.messageType != MessageTypeDeleted)
    {
        self.navigationItem.rightBarButtonItem = self.editButtonItem;

    }
    
    
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
   
//    self.emailArray = [NSMutableArray arrayWithObjects:email1, email2, email3, email4,  email5, nil ];
    self.emailArray = [NSMutableArray arrayWithCapacity:5];
    self.contactArray = [NSMutableArray arrayWithCapacity:5];
    
    //We can download the user's contacts and stuff with a method in here. It should do it on a different thread obviously.
    //getContacts(user.sessionTokenString) sends post and recieve an array of Contact Objects.
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    if (!self.currentUser) {
        self.currentUser.sessionToken = [userDefaults objectForKey:@"sessionToken"];
        self.currentUser.name = [userDefaults objectForKey:@"name"];
        self.currentUser.emailAddress = [userDefaults objectForKey:@"emailAddress"];
    }
    
  //  NSLog(@"Called ViewDidLoad!! - Right before Params %@ %@ %@", self.currentUser.sessionToken, self.currentUser.emailAddress, self.currentUser.name);

  
        [self getEmails];
        [self getContacts];

     

}

- (void)getEmails
{
//    NSLog(@"Get-Emails was called");
//    
//
//
//    if (self.messageType == MessageTypeInbox)
//    {
//        messageType = MessageTypeInbox;
//        NSLog(@"set to inbox");
//    }
//    else if (self.messageType == MessageTypeDeleted)
//    {
//        messageType = MessageTypeDeleted;
//        NSLog(@"set to delete");
//    }
//    NSLog(@"messageType: %d", messageType);
    
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            self.currentUser.sessionToken , @"sessionToken",
                            [NSNumber numberWithInt:self.messageType], @"messageType", nil];
    

    [[PikuZoneAPIClient sharedInstance] postPath:@"GetMessages.ashx"
                                      parameters:params
                                         success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                             //success
                                             
                                             //if status == 1 don't forget to check NTS.
                                             if ([[responseObject objectForKey:@"Status"] intValue] == 1)  //Login Successful
                                             {
                                                 
                                                 NSDictionary *completeMessageDict = [responseObject objectForKey:@"Messages"];
                                                 
                                                 
                                                 for (NSDictionary *singleMessageDict in completeMessageDict) {
                                                     Message *message = [[Message alloc] initWithMessageDictionary:singleMessageDict];
                                                     NSLog(@"Message ID: %i", message.messageID);
                                                     if (message.read) {
                                                         NSLog(@"Is Read!");
                                                     } else NSLog(@"Not Read!");
                                                     
                                                     [self.emailArray addObject:message];
                                                 }
                                                 
                                                 [theTableView reloadData];
                                             }
                                             else if ([[responseObject objectForKey:@"Status"] intValue] == -100 ) //Session invalidated
                                             {
                                                 //Return to Login Screen
                                               //  NSLog(@"Return to logonvc");
                                                 UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"[Dev Note]You have been logged out. Perhaps you logged in a different device. or your session timed out. Pressing okay will send you to the login page" delegate:self cancelButtonTitle:@"Okay" otherButtonTitles:nil];
                                                 [alert show];
                                                 
                                             }
                                         } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                             //failure
                                           //  NSLog(@"%@", [error localizedDescription]);
                                             UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:[error localizedDescription] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                                             [alert show];
                                         }];

}

- (void)getContacts
{
    NSDictionary *params = [NSDictionary dictionaryWithObject:self.currentUser.sessionToken forKey:@"sessionToken"];
    
    
    
    [[PikuZoneAPIClient sharedInstance] postPath:@"GetContacts.ashx" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        //success
        
        if ([[responseObject objectForKey:@"Status"] intValue] == 1)  //Login Successful
        {

            NSDictionary *completeContactDict = [responseObject objectForKey:@"Contacts"];
            
            for (NSDictionary *singleContactDict in completeContactDict)
            {
                Contact *contact = [[Contact alloc] initWithContactDictionary:singleContactDict];
                
                
                    //Obtain the contact image here with another request.
                NSDictionary *getfileParams = [NSDictionary dictionaryWithObjectsAndKeys:
                                               self.currentUser.sessionToken, @"SessionToken",
                                               contact.photoFilePath, @"FilePath" , nil];

               [[PikuZoneAPIClient sharedInstance] setDefaultHeader:@"Accept" value:@"image/jpg"];
                
                
                [[PikuZoneAPIClient sharedInstance] postPath:@"GetFile.ashx" parameters:getfileParams
                                                     success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                                         
                                                         
                                                         //By default, this responds to only JSON request, so we switch the headers so it can grab down images and then switch back. For some reason, I have to put it in here... Wierd.. 
                                                         [[PikuZoneAPIClient sharedInstance] setDefaultHeader:@"Accept" value:@"image/jpg"];

                                                         contact.contactImage = [UIImage imageWithData:responseObject];
                                                         
                                                         [[PikuZoneAPIClient sharedInstance] setDefaultHeader:@"Accept" value:@"application/json"];

                                                                
                                                     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                                         //Handle Failure
                                                       //  NSLog(@"%@", [error localizedDescription]);

                                                     }];
                
                
                [self.contactArray addObject:contact];
            }
        } else if ([[responseObject objectForKey:@"Status"] intValue] == -100 ) //Session invalidated
        {
            //Return to Login Screen - Handled above in getEmail since that's called in first. 
            
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        //failure
        NSLog(@"%@", [error localizedDescription]);
        
    }];

    //Set back to receiving JSON
    [[PikuZoneAPIClient sharedInstance] setDefaultHeader:@"Accept" value:@"application/json"];

}



- (void)viewDidUnload
{
    [self setTheTableView:nil];
    [self setTestImageview:nil];
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
    UIImageView *readView = (UIImageView *)[cell viewWithTag:kReadTag];
    
    
    
    Message *email = [self.emailArray objectAtIndex:indexPath.row];
//
    
    if (self.messageType == MessageTypeDeleted || self.messageType == MessageTypeSent)
    {

    }
    
    if (self.messageType == MessageTypeInbox)
    {
        if (!email.read)
        {
            readView.alpha = 1;
        }
    }

    
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
    

//        UIView *selectionView = [[UIView alloc]initWithFrame:cell.bounds];
//        
//        [selectionView setBackgroundColor:LIGHTGREEN];
//        
//        cell.selectedBackgroundView = selectionView;
    
    cell.selectionStyle = UITableViewCellSelectionStyleGray;
        
    
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


 //Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    //Only let you delete if MessageTypeDeleted isn't on. 
    if (self.messageType != MessageTypeDeleted) {
        if (editingStyle == UITableViewCellEditingStyleDelete) {
            //Put it in the deleted inbox here.
            
            //Get message Id
            Message *selectedEmail = [self.emailArray objectAtIndex:indexPath.row];

            //Get sessiontoken
            
            //Create params
            NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                                           self.currentUser.sessionToken, @"SessionToken",
                                           [NSNumber numberWithInt:selectedEmail.messageID], @"MessageId" , nil];
            
            [[PikuZoneAPIClient sharedInstance] postPath:@"deletemessage.ashx" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
                //Handle success
                // Delete the row from the data source.
               // NSLog(@"delete response: %@", responseObject);
                [self.emailArray removeObjectAtIndex:indexPath.row];
                [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
                
                        
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                NSLog(@"%@", [error localizedDescription]);
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Unable to delete on server" message:[error localizedDescription] delegate:self cancelButtonTitle:nil otherButtonTitles:@"Okay",nil];
                [alert show];
            }];
            
    
            
        } else if (editingStyle == UITableViewCellEditingStyleInsert) {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
        }
        
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"Message already deleted" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
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
    Message *selectedEmail = [self.emailArray objectAtIndex:indexPath.row];

    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    UIImageView *readView = (UIImageView *)[cell viewWithTag:kReadTag];
    readView.alpha = 0;
        
    self.emailDetailViewController = [[EmailDetailViewController alloc] initWithNibName:@"EmailDetailViewController" bundle:nil];
    self.emailDetailViewController.email = selectedEmail;
    self.emailDetailViewController.currentUser = self.currentUser;
    self.emailDetailViewController.contactArray = self.contactArray;

  //  NSLog(@"Subject: %@", selectedEmail.subject);

    if (!selectedEmail.read)
    {
        //Mark it as read on the server

        NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                                self.currentUser.sessionToken, @"SessionToken",
                                [NSNumber numberWithInt:selectedEmail.messageID], @"MessageId", nil];

        [[PikuZoneAPIClient sharedInstance] postPath:@"readmessage.ashx" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
            //Handle success
          //  NSLog(@"read resp: %@", responseObject);

            if ([[responseObject objectForKey:@"Status"] intValue] == 0) {
                //Message is now read on server
                selectedEmail.read = YES;
            } 
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            //Handle failure
            NSLog(@"%@", [error localizedDescription]);
        }];
    }
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
  
    
    TTMessageController* controller = [[TTMessageController alloc] initWithRecipients:nil];
    controller.navigationBarTintColor = [UIColor colorWithRed:0 green:100/255.f blue:0 alpha:1.0];
    
    controller.dataSource =  [[MockSearchDataSource alloc] init];
    controller.delegate = self;
    controller.showsRecipientPicker = YES;
    
    return controller;
}



- (void)cancelAddressBook {

    [self.presentingViewController  dismissViewControllerAnimated:YES completion:nil];
    
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
//   return TTIsSupportedOrientation(interfaceOrientation);
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
   // NSLog(@"Controller did send Field: Some messages are about to be sent");
    
}

- (void)sendDelayed:(NSTimer*)timer {
    _sendTimer = nil;
    
    NSArray* fields = timer.userInfo;
    
    TTMessageSubjectField *subjectField = [fields objectAtIndex:1];
   // NSLog(@"Subject: %@", subjectField.text);
    
    TTMessageTextField *messageBodyField = [fields objectAtIndex:2];
   // NSLog(@"Message Body: %@", messageBodyField.text);
    
    
    RecipientViewController *rvc = [[RecipientViewController alloc] initWithStyle:UITableViewStylePlain contacts:self.contactArray];
    
    NSMutableString *recipientString = [[NSMutableString alloc] initWithCapacity:5];
    
    TTMessageRecipientField* toField = [fields objectAtIndex:0];
    BOOL secondplusgo = NO;
    for (NSString *name in toField.recipients) {
        if (secondplusgo) { [recipientString appendString:@","]; }
        
        //Get the actual recipient class:
        Contact *recipient = [rvc getRecipientForName:name];
      //  NSLog(@"Name: %@, Id: %i", recipient.name, recipient.contactID);
        [recipientString appendString:[NSString stringWithFormat:@"%i", recipient.contactID]];
        secondplusgo = YES;
    }
    
    
 //   NSLog(@"recipient string: %@",  recipientString);
#pragma mark - WIll SEND MESSAGES HERE
    // Will do the sending of a message RIGHT HEREREERERERERE
    
    NSDictionary *sendMessageParams = [NSDictionary dictionaryWithObjectsAndKeys:
                                       self.currentUser.sessionToken, @"SessionToken",
                                       recipientString, @"Recipients",
                                       subjectField.text, @"Subject",
                                       messageBodyField.text, @"Body", nil];
    
   // NSLog(@"%@", sendMessageParams);
    
    [[PikuZoneAPIClient sharedInstance] postPath:@"sendmessage.ashx" parameters:sendMessageParams
                                         success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                             
                                             if ([[responseObject objectForKey:@"Status"] intValue] == 0)
                                             {
                                                 
                                               //  NSLog(@"resp: %@", responseObject);
                                                 lastMessageErred = NO;
                                                 [self.modalViewController dismissModalViewControllerAnimated:YES];
                                             }
                                             else {
                                                 UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error in sending this message" message:[responseObject objectForKey:@"Message"] delegate:self cancelButtonTitle:nil otherButtonTitles:@"Okay", nil];
                                                 [alert show];
                                             }
                                             
                                             
                                             
                                         } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                             NSLog(@"%@", [error localizedDescription]);
                                             sendingErrorAlert = [[UIAlertView alloc] initWithTitle:@"Error in sending this message" message:[error localizedDescription] delegate:self cancelButtonTitle:nil otherButtonTitles:@"Okay", nil];
                                             savedMessageBodyTextFromError = messageBodyField.text;
                                             savedTitleTextFromError = subjectField.text;
                                             lastMessageErred = YES;
                                             [sendingErrorAlert   show];
                                             
                                         }];
    
    
    
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
    

    //Here we use the contact array we got from the GetContacts method and send it to the recipientsController. And will be used as the datasource.

    RecipientViewController *recipientController = [[RecipientViewController alloc] initWithStyle:UITableViewStylePlain contacts:self.contactArray];

    recipientController.delegate = self;
    recipientController.title = @"Family Book";
    recipientController.navigationItem.prompt = @"Select a recipient";
    
    UINavigationController* navController = [[UINavigationController alloc] initWithRootViewController:recipientController];
    
    [controller presentModalViewController:navController animated:YES];
    
}



#pragma mark - Recipient View Controller Delegate
- (void)recipientViewController:(RecipientViewController*)controller didSelectRecipient:(Contact *)recipient {
   // NSLog(@"Selected %@ id: %i", recipient.name, recipient.contactID);
    
//    TTMessageController* composeController = (TTMessageController*)controller;//controller.navigationController ;// self.navigationController.topViewController ;
//    NSLog(@"Del Cont: %@", [self.mainMessageController class]);
//    
    NSString *recipientName = recipient.name;
    [self.mainMessageController addRecipient:recipientName forFieldAtIndex:0];
    [controller dismissModalViewControllerAnimated:YES];
}



- (void)recipientViewControllerdidCancel:(SearchTestController*)controller
{
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
    
    if (lastMessageErred) {
        [self.mainMessageController setSubject:savedTitleTextFromError];
        [self.mainMessageController setBody:savedMessageBodyTextFromError];
    }
    
    
    UINavigationController *messageNavController = [[UINavigationController alloc] initWithRootViewController:self.mainMessageController];
    
    //  [[TTNavigator navigator].visibleViewController presentModalViewController:messageComp animated:YES];
    [self presentModalViewController:messageNavController animated:YES];

}


#pragma mark UIAlertViewDelegate Methods

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSString *title = [alertView buttonTitleAtIndex:buttonIndex];
    if([title isEqualToString:@"OK"])  {
        //Do nothing...
        return;
    }
    
    if (buttonIndex == alertView.cancelButtonIndex) {
        AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
        [appDelegate presentLoginViewController];
    }
    
    if (alertView == sendingErrorAlert ) {
        //Will be nice to reload that messageController page with the same details instead of seding him back..
       
        [self.mainMessageController removeActivityView];
        
    }
    
}


@end
