//
//  FriendPickerViewController.m
//  speakEasy
//
//  Created by Rick Sullivan on 5/26/14.
//
//

#import "FriendPickerViewController.h"
#import "User.h"

@implementation FriendPickerViewController

@synthesize messageLabel, message;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithWhite:1 alpha:0.5];
    if (message) {
        messageLabel.text = message.text;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)handleFriendSelection:(User *)friend
{
    if (message.authorID == friend.userID) {
        /* Give current user points and let them know they were correct */
    } else {
        /* Tell them they were wrong */
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"Embed"])
    {
        FriendTableViewController *vc = segue.destinationViewController;
        vc.delegate = self;
    }
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
