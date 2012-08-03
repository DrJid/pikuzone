//
//  LoginViewController.m
//  PikuZone
//
//  Created by Maijid Moujaled on 7/2/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "LoginViewController.h"
#import "InboxViewController.h"

@implementation LoginViewController
@synthesize usernameField;
@synthesize passwordField;

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

#pragma mark - Login Methods
- (IBAction)authenticate:(id)sender {
    NSString *username = usernameField.text;
    NSString *password = passwordField.text;
    
    NSString *message = [NSString stringWithFormat:@"Welcome %@!", username];
    
//    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Test Alert" message:message delegate:self cancelButtonTitle:@"Okay" otherButtonTitles:nil];
//    [alert show];
    
    
//    InboxViewController *inboxViewController = [[InboxViewController alloc] initWithNibName:@"InboxViewController" bundle:nil];
    
    //Pass the username object we get from the authenticate method into the inboxviewController. 
//    inboxViewController.username = username;
    
//    UINavigationController *mainNavigationController = [[UINavigationController alloc] initWithRootViewController:inboxViewController];
        
//    [self.navigationController presentModalViewController:mainNavigationController animated:YES];
    
}


#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.title = @"Login";
    [usernameField becomeFirstResponder];
}

- (void)viewDidUnload
{
    [self setUsernameField:nil];
    [self setPasswordField:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


@end
