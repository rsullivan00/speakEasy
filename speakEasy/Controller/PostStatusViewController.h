//  speakEasy
//
//  Created by Daljeet Virdi on 5/19/14.
//
//
#import <Firebase/Firebase.h>
#import "User.h"
#import "MPTextView.h"
#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface PostStatusViewController : UIViewController <UIGestureRecognizerDelegate>

/* Adds message under the current User */
- (IBAction) addMessage:(id)sender;
/* Registers screen touches to close the keyboard if open */
- (IBAction) screenTouch;

@property (weak, nonatomic) IBOutlet MPTextView *messageTextView;
@property (weak, nonatomic) IBOutlet UIButton *submitButton;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;

/* Reloads and displays the current User's score */
- (void) reloadData;

@end
