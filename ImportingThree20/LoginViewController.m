//
//  LoginViewController.m
//  PikuZone
//
//  Created by Maijid Moujaled on 7/2/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "LoginViewController.h"
#import "InboxViewController.h"
#import "PikuZoneAPIClient.h"
#import "ActivityView.h"

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
    [usernameField resignFirstResponder];
    [passwordField resignFirstResponder];
    
    ActivityView *activityView = [[ActivityView alloc] initWithFrame:CGRectMake(0.f, 0.f, self.view.frame.size.width, self.view.frame.size.height)];
	UILabel *label = activityView.label;
	label.text = @"Logging in";
	label.font = [UIFont boldSystemFontOfSize:20.f];
	[activityView.activityIndicator startAnimating];
	[activityView layoutSubviews];
    
	[self.view addSubview:activityView];
    
    
    
    NSString *username = usernameField.text;
    NSString *password = passwordField.text;
    
    
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            username, @"username",
                            password, @"password", nil];
    
    [[PikuZoneAPIClient sharedInstance] postPath:@"Authenticate.ashx"
                                      parameters:params
                                         success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                             //HAndle success
//                                             NSLog(@"Response!!!!!!: %@", responseObject);
                                             if ([[responseObject objectForKey:@"Status"] intValue] == 1) //Login Successful
                                             {
                                                 //Create new user object
                                                 self.currentUser = [[User alloc] init];
                                                 self.currentUser.name = [responseObject objectForKey:@"Name"];
                                                 self.currentUser.userID = [[responseObject objectForKey:@"UserId"] intValue];
                                                 self.currentUser.sessionToken = [responseObject objectForKey:@"SessionToken"];
                                                 self.currentUser.emailAddress = [responseObject objectForKey:@"EmailAddress"];
                                                 NSLog(@"Current User name: %@", self.currentUser.name);
                                                 

                                                 NSString *title = [NSString stringWithFormat:@"Welcome %@!", self.currentUser.name];
                                                 
                                                 [activityView.activityIndicator stopAnimating];
                                                 [activityView removeFromSuperview];
                                                 UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:self.currentUser.emailAddress delegate:self cancelButtonTitle:@"Okay" otherButtonTitles:nil];
                                                 [alert show];
                                                 
                                                 
                                                     InboxViewController *inboxViewController = [[InboxViewController alloc] initWithNibName:@"InboxViewController" bundle:nil];
                                                 
                                                 //Pass the User object we get from the authenticate method into the inboxviewController.
                                                     inboxViewController.currentUser = self.currentUser;
                                                 
                                                     UINavigationController *mainNavigationController = [[UINavigationController alloc] initWithRootViewController:inboxViewController];
                                                 
                                                     [self.navigationController presentModalViewController:mainNavigationController animated:YES];
                                                 
                                                 
                                             } else //Login unsuccessful
                                             {
                                                 UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Login Failed" message:@"Invalid username and/or Password. Please check again" delegate:self cancelButtonTitle:@"Okay" otherButtonTitles:nil];
                                                 [alert show];
                                                 [activityView.activityIndicator stopAnimating];
                                                 [activityView removeFromSuperview];
                                                 [usernameField becomeFirstResponder];
                                                 
                                                 
                                             }
                                                                                          

                                             //You could do more stuff in here while it's logging you?
                                             //Tear down the view

                                         } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                             //handle failure
                                             NSLog(@"ERROR");
                                             NSLog(@"%@", [error localizedDescription]);
                                         }];

    
    
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
    
    usernameField.text = @"Kid1";
    passwordField.text = @"Password1";
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
