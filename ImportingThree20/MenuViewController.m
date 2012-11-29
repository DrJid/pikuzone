//
//  MenuViewController.m
//  PikuZone
//
//  Created by Maijid Moujaled on 7/2/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MenuViewController.h"
#import "AppDelegate.h"
#import "InboxViewController.h"



#define InboxRow 0
#define DeletedRow 1
#define SentRow 2
#define LogOutRow 3


@implementation MenuViewController

@synthesize currentUser, inboxViewController;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:UITableViewStyleGrouped];
    if (self) {
        // Custom initialization
        self.title = @"Menu";
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

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;

    self.title = @"Menu";
    self.view.backgroundColor = [UIColor colorWithRed:240/255.f green:241/255.f blue:206/255.f alpha:1];

}


- (void)viewDidUnload
{
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
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return @"Other Boxes";
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleGray;

    
    // Configure the cell...
    if (indexPath.row == InboxRow) {
        cell.textLabel.text = @"Inbox";
        return cell;
    }
    
    else if (indexPath.row == DeletedRow) {
        cell.textLabel.text = @"Deleted";
        return cell;
    }
    
    else if (indexPath.row  == SentRow) {
        cell.textLabel.text = @"Sent";
        return cell;
    }
    
    else if (indexPath.row == LogOutRow) {
        cell.textLabel.text = @"Logout";
        cell.textLabel.textAlignment = UITextAlignmentCenter;
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
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
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

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{


    
    if (indexPath.row == InboxRow)
    {
        [self.navigationController pushViewController:self.inboxViewController animated:YES];
    }
    
    else if (indexPath.row == DeletedRow) {

        
        //Create a clone of the InboxViewController. But fill it with Deleted Messages instead.
        InboxViewController *deletedMessagesViewController = [[InboxViewController alloc] initWithNibName:@"InboxViewController" bundle:nil];
        deletedMessagesViewController.currentUser = self.currentUser;
        deletedMessagesViewController.messageType = MessageTypeDeleted;
        deletedMessagesViewController.title = @"Deleted";
        [self.navigationController pushViewController:deletedMessagesViewController animated:YES];

        
    }
    
    else if (indexPath.row  == SentRow)
    {
        InboxViewController *sentMessagesViewController = [[InboxViewController alloc] initWithNibName:@"InboxViewController" bundle:nil];
        sentMessagesViewController.currentUser = self.currentUser;
        sentMessagesViewController.messageType = MessageTypeSent;
        sentMessagesViewController.title = @"Sent";
        [self.navigationController pushViewController:sentMessagesViewController animated:YES];

    }
    
    else if (indexPath.row == LogOutRow) {
        //Log out by clearing NSUserDefaults
        //Save the current User in the User defaults.
        [[NSUserDefaults standardUserDefaults] setInteger:0 forKey:@"userID"];
        [[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"emailAddress"];
        [[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"name"];
        [[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"sessionToken"];

        [self.presentingViewController dismissModalViewControllerAnimated:YES];
        
        AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
        [appDelegate presentLoginViewController];

        
    }

    
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
