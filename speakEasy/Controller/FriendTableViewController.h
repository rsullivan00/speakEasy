//
//  FriendTableViewController.h
//  speakEasy
//
//  Created by Rick Sullivan on 5/25/14.
//
//

#import <UIKit/UIKit.h>
#import "User.h"

/* FriendTableDelegate will respond to the User selecting a friendCell */
@protocol FriendTableDelegate <NSObject>

- (void)handleFriendSelection:(User *)friend;

@end

@interface FriendTableViewController : UITableViewController

@property id<FriendTableDelegate> delegate;

@end

