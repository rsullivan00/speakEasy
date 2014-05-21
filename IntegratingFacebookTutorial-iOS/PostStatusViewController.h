//  speakEasy
//
//  Created by Daljeet Virdi on 5/19/14.
//
//
#import <Firebase/Firebase.h>
#import "User.h"
#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface PostStatusViewController : UIViewController

- (IBAction)addMessage:(id)sender;

@property (weak, nonatomic) IBOutlet UITextView *messageTextView;

@end
