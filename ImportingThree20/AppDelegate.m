//
//  AppDelegate.m
//  ImportingThree20
//
//  Created by Maijid Moujaled on 6/28/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AppDelegate.h"

#import "ViewController.h"
#import "LoginViewController.h"
#import "InboxViewController.h"
#import "MenuViewController.h"
#import "User.h"

@interface AppDelegate()
//    void uncaughtExceptionHandler(NSException *exception);
@end

@implementation AppDelegate

@synthesize window = _window;
@synthesize navigationController = _navigationController;
@synthesize viewController = _viewController;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    [[UINavigationBar appearance] setTintColor:[UIColor colorWithRed:0 green:100/255.f blue:0 alpha:1.0]];
    [[UIToolbar appearance] setTintColor:[UIColor colorWithRed:0 green:100/255.f blue:0 alpha:1.0]];

//    NSSetUncaughtExceptionHandler(&uncaughtExceptionHandler);
//    Left this as a quick way to take screenshots. This code is deprecated though and shouldn't be used in production'
  //  [application setStatusBarHidden:YES animated:NO];

    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.

    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    if ([userDefaults objectForKey:@"name"]) //Meaning we have a user logged in and cached
    {
        //Skip straight to the main View

        MenuViewController *menuViewController =[[MenuViewController alloc] initWithNibName:@"MenuViewController" bundle:nil];
        menuViewController.inboxViewController = [[InboxViewController alloc] initWithNibName:@"InboxViewController" bundle:nil];
        
        UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:menuViewController];

        
            //Resurge User from user defaults
            menuViewController.currentUser = [[User alloc] init];
            menuViewController.currentUser.sessionToken = [userDefaults objectForKey:@"sessionToken"];
            menuViewController.currentUser.name = [userDefaults objectForKey:@"name"];
            menuViewController.currentUser.emailAddress = [userDefaults objectForKey:@"emailAddress"];
        
        menuViewController.inboxViewController.currentUser = menuViewController.currentUser;
        menuViewController.inboxViewController.title = @"Inbox";
        menuViewController.inboxViewController.messageType = MessageTypeInbox;
        
        [navController pushViewController:menuViewController.inboxViewController animated:NO];
        
        
        self.viewController = navController;
        self.window.rootViewController = self.viewController;
    } else {
        [self presentLoginViewController];
    }
    
    
    
    [self.window makeKeyAndVisible];
    return YES;

}

- (void)presentLoginViewController
{
    LoginViewController *loginViewController = [[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:nil];
    
    // Go to the welcome screen and have them log in or create an account.
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:loginViewController];
    //loginViewController.title = @"Welcome to PikuZone";
    
    self.viewController = navController;
    self.window.rootViewController = self.viewController;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
     */
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    /*
     Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
     */
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    /*
     Called when the application is about to terminate.
     Save data if appropriate.
     See also applicationDidEnterBackground:.
     */
}


#pragma mark - Custom Methods


@end
