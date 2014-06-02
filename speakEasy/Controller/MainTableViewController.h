//  speakEasy
//
//  Created by Daljeet Virdi on 5/19/14.
//
//

#import <UIKit/UIKit.h>
#import <Firebase/Firebase.h>

@interface MainTableViewController : UITableViewController <UIGestureRecognizerDelegate>

- (void)goToFriendPickerView:(id)sender;
- (void)likeMessage:(id)sender;

- (void)reloadTableData;

@property(strong) NSArray *messageList;
@property(weak, nonatomic) IBOutlet UIActivityIndicatorView *spinner;

@end
