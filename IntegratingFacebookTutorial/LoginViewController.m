//
//  Copyright (c) 2012 Parse. All rights reserved.

#import "LoginViewController.h"
#import "UserDetailsViewController.h"
#import "Parse/Parse.h"

@implementation LoginViewController

@synthesize activityIndicator;

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setTitle:@"Facebook Profile"];

    // Check if user is cached and linked to Facebook, if so, bypass login    
    if ([PFUser currentUser] && [[PFUser currentUser] hasFacebook]) 
    {
        [self.navigationController pushViewController:[[UserDetailsViewController alloc] initWithStyle:UITableViewStyleGrouped] animated:NO];
    }
}


#pragma mark - Login mehtods

/* Login to facebook method */
- (IBAction)loginButtonTouchHandler:(id)sender 
{
    // Set permissions required from the facebook user account
    NSArray *permissionsArray = [NSArray arrayWithObjects:@"user_about_me",@"user_relationships",@"user_birthday",@"user_location",@"offline_access", nil];
    
    // Login PFUser using facebook
    [PFUser logInWithFacebook:permissionsArray block:^(PFUser *user, NSError *error) 
    {
        [activityIndicator stopAnimating]; // Hide loading indicator
        
        if (!user) {
            NSLog(@"Uh oh. The user cancelled the Facebook login.");
        } else if (user.isNew) {
            NSLog(@"User with facebook id %@ signed up and logged in!", user.facebookId);
            [self.navigationController pushViewController:[[UserDetailsViewController alloc] initWithStyle:UITableViewStyleGrouped] animated:YES];
        } else {
            NSLog(@"User with facebook id %@ logged in!", user.facebookId);
            [self.navigationController pushViewController:[[UserDetailsViewController alloc] initWithStyle:UITableViewStyleGrouped] animated:YES];
        }
    }];
    
    [activityIndicator startAnimating]; // Show loading indicator until login is finished
}

@end
