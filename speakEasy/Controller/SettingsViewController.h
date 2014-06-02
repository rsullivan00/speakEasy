//  speakEasy
//
//  Created by Daljeet Virdi on 5/19/14.
//
//

#import <UIKit/UIKit.h>
#import "FriendTableViewController.h"

@protocol FriendTableDelegate <NSObject>

- (void)handleFriendSelection:(User *)friend;

@end

@interface SettingsViewController : UITableViewController <UIGestureRecognizerDelegate>


@property id<FriendTableDelegate> delegate;

@end


