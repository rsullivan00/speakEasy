//  speakEasy
//
//  Created by Daljeet Virdi on 5/19/14.
//
//

#import <UIKit/UIKit.h>
#import <Firebase/Firebase.h>

@interface MainTableTableViewController : UITableViewController

- (IBAction)goToPostStatusView:(id)sender;
- (IBAction)goToFriendPickerView:(id)sender;
- (void)reloadTableData;

@property(strong) NSArray *messageList;

@end
