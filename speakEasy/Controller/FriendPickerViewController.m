//
//  FriendPickerViewController.m
//  speakEasy
//
//  Created by Rick Sullivan on 5/26/14.
//
//

#import "FriendPickerViewController.h"
#import "User.h"
#import "Guess.h"
#include <Firebase/Firebase.h>
#include "Constants.h"

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
    Guess *guess = [[Guess alloc] initWithMessage:message];
    [[User currentUser].guesses addObject:guess];
    if ([message.authorID isEqualToString:friend.userID]) {
        NSLog(@"Correct");
        NSString *scoreURL = [NSString stringWithFormat:@"%@/users/%@/score", FIREBASE_PREFIX, [[User currentUser] userID]];
        Firebase *scoreFirebase = [[Firebase alloc] initWithUrl:scoreURL];
        
        __block FirebaseHandle handle = [scoreFirebase observeEventType:FEventTypeValue withBlock:^(FDataSnapshot *snapshot) {
            [scoreFirebase removeObserverWithHandle:handle];
            if(snapshot.value == [NSNull null]) {
                NSLog(@"this user has no score");
                [scoreFirebase setValue:@(1)];
            } else {
                NSNumber* data = snapshot.value;
                [scoreFirebase setValue:@(data.integerValue + 1)];
            }
        }];
        
        /* Persist Guess to DB */
        NSString *guessURL = [NSString stringWithFormat:@"%@/users/%@/guesses", FIREBASE_PREFIX, [[User currentUser] userID]];
        Firebase *guessFirebase = [[Firebase alloc] initWithUrl:guessURL];
        [[guessFirebase childByAutoId] setValue:@{@"authorID":guess.message.authorID, @"messageID":guess.message.messageID}];
        
    } else {
        NSLog(@"Wrong");
        /* Tell them they were wrong */
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:USER_INFO_UPDATE object:nil];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    /* Set delegate of FriendTableViewController when it is embedded in this VC */
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
