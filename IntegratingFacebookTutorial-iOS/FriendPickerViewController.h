//
//  FriendPickerViewController.h
//  speakEasy
//
//  Created by Rick Sullivan on 5/26/14.
//
//

#import <UIKit/UIKit.h>
#import "Message.h"

@interface FriendPickerViewController : UIViewController

@property IBOutlet UILabel *messageLabel;
@property Message *message;

@end
