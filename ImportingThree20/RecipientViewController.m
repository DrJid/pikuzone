//
//  RecipientViewController.m
//  ImportingThree20
//
//  Created by Maijid Moujaled on 6/29/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "RecipientViewController.h"
#import "PikuZoneAPIClient.h"

@implementation RecipientViewController
@synthesize delegate =_delegate;
@synthesize contactArray;





- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
        self.title = @"Family Book";
        
        
    }
    return self;
}

- (id)initWithStyle:(UITableViewStyle)style contacts:(NSMutableArray *)contactsArray
{
    if ((self = [super initWithStyle:style]))
    {
        self.title = @"FamilyBook";
        self.contactArray = [[NSMutableArray alloc] initWithCapacity:5];
        self.contactArray = contactsArray;
//        self.contactArray = [[NSMutableArray alloc] initWithArray:contactsArray];
        
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (Contact *)getRecipientForName:(NSString *)name {
    [self viewDidLoad];
    
    for (Contact *r in self.contactArray) {
        if ([r.name isEqualToString:name]) {
            return r;
        }
    }
    return nil;
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelsend)];
    
    //Create Recipient Test Data. 
    Contact *bill = [[Contact alloc] initWithname:@"Bill" email:@"bill@msft.com" image:[UIImage imageNamed:@"avatar1.png"]];

    Contact *mary = [[Contact alloc] initWithname:@"Cousin Mary" email:@"mary@scdsm.com" image:[UIImage imageNamed:@"avatar5.png"]];
    
    Contact *jo = [[Contact alloc] initWithname:@"Cynthia" email:@"joe@joe.com" image:[UIImage imageNamed:@"avatar3.png"]];
    
    Contact *grandma = [[Contact alloc] initWithname:@"Young Grandma" email:@"grandma@scdsm.com" image:[UIImage imageNamed:@"avatar4.png"]];
    
    Contact *maijid = [[Contact alloc] initWithname:@"Maijid" email:@"maijid@gmail.com" image:[UIImage imageNamed:@"maijid.jpeg"]];
    
    Contact *steve = [[Contact alloc] initWithname:@"Steve" email:@"steve@papasite.com" image:[UIImage imageNamed:@"avatar2.png"]];


    

    
//    self.contactArray = [NSMutableArray arrayWithObjects:bill, mary, jo, grandma, maijid, steve, nil];
    
    
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

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return self.contactArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    // Configure the cell...
    Contact *recipient = [self.contactArray objectAtIndex:indexPath.row];
    cell.textLabel.text = recipient.name;
    cell.imageView.image = recipient.contactImage;
    
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


//Delegate Methods to be implemented.
- (void)recipientViewController:(RecipientViewController*)controller didSelectObject:(id)object {
    
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
    
    //Get the object selected
    
    Contact *recipient = [self.contactArray objectAtIndex:indexPath.row];
    
    [self.delegate recipientViewController:self didSelectRecipient:recipient];
}


- (void)recipientViewControllerdidCancel:(RecipientViewController*)controller {
    
}

- (void)cancelsend {
    [self.delegate recipientViewControllerdidCancel:self];
}
     

@end
