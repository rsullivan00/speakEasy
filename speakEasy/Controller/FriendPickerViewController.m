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
      
        UIImageView *imageToMove =
        [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"wrong.png"]];
        UIImageView *secondImageToMove = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"wrong.png"]];
        secondImageToMove.frame = CGRectMake(40,40,100,100);
        
        imageToMove.frame = CGRectMake(10, 10, 100, 100);
        [self.view addSubview:imageToMove];
        [self.view addSubview:secondImageToMove];
        
        // Move the image
        [self moveImage:imageToMove duration:3.0
                  curve:UIViewAnimationCurveLinear x:100.0 y:700.00];
        [self moveImage:secondImageToMove duration:3.0
                  curve:UIViewAnimationCurveLinear x:0 y:700.00];
        
        NSString *scoreURL = [NSString stringWithFormat:@"%@/users/%@/score", FIREBASE_PREFIX, [[User currentUser] userID]];
        Firebase *scoreFirebase = [[Firebase alloc] initWithUrl:scoreURL];
        
        __block FirebaseHandle handle = [scoreFirebase observeEventType:FEventTypeValue withBlock:^(FDataSnapshot *snapshot) {
            [scoreFirebase removeObserverWithHandle:handle];
            if(snapshot.value == [NSNull null]) {
                NSLog(@"this user has no score");
                [scoreFirebase setValue:@(0.1)];
            } else {
                NSNumber* data = snapshot.value;
                [scoreFirebase setValue:@(data.doubleValue + 0.1)];
            }
        }];
        
        /* Persist Guess to DB */
        NSString *guessURL = [NSString stringWithFormat:@"%@/users/%@/guesses", FIREBASE_PREFIX, [[User currentUser] userID]];
        Firebase *guessFirebase = [[Firebase alloc] initWithUrl:guessURL];
        [[guessFirebase childByAutoId] setValue:@{@"authorID":guess.message.authorID, @"messageID":guess.message.messageID}];
        
    } else {
        NSLog(@"Wrong");
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:USER_INFO_UPDATE object:nil];

    [self.navigationController popViewControllerAnimated:YES];
}

- (void)moveImage:(UIImageView *)image duration:(NSTimeInterval)duration
            curve:(int)curve x:(CGFloat)x y:(CGFloat)y
{
    // Setup the animation
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:duration];
    [UIView setAnimationCurve:curve];
    [UIView setAnimationBeginsFromCurrentState:YES];
    
    // The transform matrix
    CGAffineTransform transform = CGAffineTransformMakeTranslation(x, y);
    image.transform = transform;
    
    // Commit the changes
    [UIView commitAnimations];
    
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
