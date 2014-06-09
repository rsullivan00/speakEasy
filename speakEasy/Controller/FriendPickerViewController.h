//
//  FriendPickerViewController.h
//  speakEasy
//
//  Created by Rick Sullivan on 5/26/14.
//
//

#import <UIKit/UIKit.h>
#import "Message.h"
#import "FriendTableViewController.h"

@interface FriendPickerViewController : UIViewController <FriendTableDelegate>

@property (weak, nonatomic) IBOutlet UILabel *messageLabel;
@property Message *message;

@end
