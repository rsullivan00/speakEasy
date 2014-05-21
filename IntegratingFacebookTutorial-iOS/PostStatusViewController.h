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

@interface PostStatusViewController : UIViewController

- (IBAction)addMessage:(id)sender;
- (IBAction) screenTouch;

@property (weak, nonatomic) IBOutlet MPTextView *messageTextView;
@property (weak, nonatomic) IBOutlet UIButton *submitButton;

@end
