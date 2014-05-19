//
//  Copyright (c) 2013 Parse. All rights reserved.

#import "LoginViewController.h"
#import "UserDetailsViewController.h"
#import <Parse/Parse.h>
#import "MainNavigationController.h"

@implementation LoginViewController


#pragma mark - UIViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   // self.title = @"Facebook Profile";
    [[self navigationController] setNavigationBarHidden:YES animated:YES];

    // Check if user is cached and linked to Facebook, if so, bypass login    
    if ([PFUser currentUser] && [PFFacebookUtils isLinkedWithUser:[PFUser currentUser]]) {
        [self showMainNavigationController];
    }
}


#pragma mark - Login mehtods


- (void)showMainNavigationController
{
    NSLog(@"User with facebook signed up and logged in!");
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Storyboard" bundle:nil];
    MainNavigationController *vc = [storyBoard instantiateViewControllerWithIdentifier:@"MainNavigationController"];
    [[UIApplication sharedApplication].delegate window].rootViewController = vc;
}

/* Login to facebook method */
- (IBAction)loginButtonTouchHandler:(id)sender  {
    // Set permissions required from the facebook user account
    NSArray *permissionsArray = @[ @"user_friends"];
    
    // Login PFUser using facebook
    [PFFacebookUtils logInWithPermissions:permissionsArray block:^(PFUser *user, NSError *error) {
        [_activityIndicator stopAnimating]; // Hide loading indicator
        
        if (!user) {
            if (!error) {
                NSLog(@"Uh oh. The user cancelled the Facebook login.");
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Log In Error" message:@"Uh oh. The user cancelled the Facebook login." delegate:nil cancelButtonTitle:nil otherButtonTitles:@"Dismiss", nil];
                [alert show];
            } else {
                NSLog(@"Uh oh. An error occurred: %@", error);
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Log In Error" message:[error description] delegate:nil cancelButtonTitle:nil otherButtonTitles:@"Dismiss", nil];
                [alert show];
            }
        } else if (user.isNew) {
            NSLog(@"User with facebook signed up and logged in!");
            [self showMainNavigationController];
        } else {
            NSLog(@"User with facebook logged in!");
            [self showMainNavigationController];
        }
    }];
    
    [_activityIndicator startAnimating]; // Show loading indicator until login is finished
}


@end
