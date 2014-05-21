//  speakEasy
//
//  Created by Daljeet Virdi on 5/19/14.
//
//
#import "LoginViewController.h"
#import "UserDetailsViewController.h"
#import <Parse/Parse.h>
#import "MainViewController.h"

@implementation LoginViewController


#pragma mark - UIViewController

- (void)viewDidLoad {
    [super viewDidLoad];
     self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"Oceanic_Background_by_ka_chankitty.jpg"]];
    [[self navigationController] setNavigationBarHidden:YES animated:YES];

    // Check if user is cached and linked to Facebook, if so, bypass login    
    if ([PFUser currentUser] && [PFFacebookUtils isLinkedWithUser:[PFUser currentUser]]) {
        [self showMainViewController];
    }
}


#pragma mark - Login mehtods


- (void)showMainViewController
{
    NSLog(@"User with facebook signed up and logged in!");
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Storyboard" bundle:nil];
    MainViewController *vc = [storyBoard instantiateViewControllerWithIdentifier:@"MainViewController"];
    [[UIApplication sharedApplication].delegate window].rootViewController = vc;
}

/* Login to facebook method */
- (IBAction)loginButtonTouchHandler:(id)sender  {
    // Set permissions required from the facebook user account
    NSArray *permissionsArray = @[@"user_friends"];
    
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
            [self showMainViewController];
        } else {
            NSLog(@"User with facebook logged in!");
            [self showMainViewController];
        }
    }];
    
    [_activityIndicator startAnimating]; // Show loading indicator until login is finished
}


@end
