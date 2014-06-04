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
        
        UIImageView *imageToMove =[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"right.png"]];
        UIImageView *imageView =[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"right1.png"]];

        UIImageView *secondImageToMove = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"right.png"]];
        UIImageView *correctImageToMove = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"right1.png"]];
        correctImageToMove.frame = CGRectMake(0,0,100,100);

        secondImageToMove.frame = CGRectMake(700,700,100,100);
        imageToMove.frame = CGRectMake(0, 0, 100, 100);
        imageView.frame = CGRectMake(0, 0, 100, 100);
        [self.view addSubview:imageView];

        [self.view addSubview:imageToMove];
        [self.view addSubview:secondImageToMove];
        [self.view addSubview:correctImageToMove];

        
        // Move the image
        [UIView animateWithDuration:3.0 animations:^{
            imageToMove.frame = CGRectMake(700, 700.0, imageToMove.frame.size.width, imageToMove.frame.size.width);
            secondImageToMove.frame = CGRectMake(0.0, 700.0, secondImageToMove.frame.size.width, secondImageToMove.frame.size.width);
            imageView.frame = CGRectMake(700, 700.0, imageToMove.frame.size.width, imageView.frame.size.width);
            correctImageToMove.frame = CGRectMake(0.0, 700.0, correctImageToMove.frame.size.width, correctImageToMove.frame.size.width);
            
            } completion:^(BOOL finished){
                [self.navigationController popViewControllerAnimated:YES];
            }
         ];
        
        NSString *scoreURL = [NSString stringWithFormat:@"%@/users/%@/score", FIREBASE_PREFIX, [[User currentUser] userID]];
        Firebase *scoreFirebase = [[Firebase alloc] initWithUrl:scoreURL];
        
        __block FirebaseHandle handle = [scoreFirebase observeEventType:FEventTypeValue withBlock:^(FDataSnapshot *snapshot) {
            [scoreFirebase removeObserverWithHandle:handle];
            if(snapshot.value == [NSNull null]) {
                NSLog(@"this user has no score");
                [scoreFirebase setValue:@(0.05)];
            } else {
                NSNumber* data = snapshot.value;
                [scoreFirebase setValue:@(data.doubleValue + 0.05)];
            }
        }];
        
    } else {
        NSLog(@"Wrong");
        
        UIImageView *imageToMove =
        [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"wrong.png"]];
        UIImageView *secondImageToMove = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"wrong.png"]];
        secondImageToMove.frame = CGRectMake(100,100,100,100);
        imageToMove.frame = CGRectMake(0, 0, 100, 100);
        [self.view addSubview:imageToMove];
        [self.view addSubview:secondImageToMove];
        
        // Move the image
        [UIView animateWithDuration:3.0 animations:^{
            imageToMove.frame = CGRectMake(0, 700.0, imageToMove.frame.size.width, imageToMove.frame.size.width);
            secondImageToMove.frame = CGRectMake(0.0, 700.0, secondImageToMove.frame.size.width, secondImageToMove.frame.size.width);
        } completion:^(BOOL finished){
            [self.navigationController popViewControllerAnimated:YES];
        }
         ];

    }
    
    /* Persist Guess to DB */
    NSString *guessURL = [NSString stringWithFormat:@"%@/users/%@/guesses", FIREBASE_PREFIX, [[User currentUser] userID]];
    Firebase *guessFirebase = [[Firebase alloc] initWithUrl:guessURL];
    [[guessFirebase childByAutoId] setValue:@{@"authorID":guess.message.authorID, @"messageID":guess.message.messageID}];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:USER_INFO_UPDATE object:nil];
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
