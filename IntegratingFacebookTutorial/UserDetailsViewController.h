//
//  Copyright (c) 2012 Parse. All rights reserved.

#import <UIKit/UIKit.h>
#import "Parse/Parse.h"

@interface UserDetailsViewController : UITableViewController <PF_FBRequestDelegate, NSURLConnectionDelegate>

// UITableView header view properties
@property (nonatomic, strong) IBOutlet UIView *headerView;
@property (nonatomic, strong) IBOutlet UILabel *headerNameLabel;
@property (nonatomic, strong) IBOutlet UIImageView *headerImageView;

// UITableView row data properties
@property (nonatomic, strong) NSArray *rowTitleArray;
@property (nonatomic, strong) NSMutableArray *rowDataArray;
@property (nonatomic, strong) NSMutableData *imageData;

// UINavigationBar button touch handler
- (void)logoutButtonTouchHandler:(id)sender;


@end
