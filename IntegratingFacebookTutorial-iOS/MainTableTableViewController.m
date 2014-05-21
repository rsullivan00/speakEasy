//  speakEasy
//
//  Created by Daljeet Virdi on 5/19/14.
//
//

#import "MainTableTableViewController.h"
#import "PostStatusViewController.h"
#import "Constants.h"
#import "User.h"
#import "Message.h"

@implementation MainTableTableViewController

@synthesize messageList;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor clearColor];

    User *currentUser = [User currentUser];
    [self reloadTableData];
    
    if (!currentUser) {
        /* Error, user should be logged in. Redirect to login view */
    } else if (!currentUser.friends.count) {
        /* Request friends */
        [currentUser populateFriendsFromFirebase];
        /* Iterate through friends and update messages */
    } else {
        /* currentUser has friends */
    }

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
}

- (void)viewWillAppear:(BOOL)animated
{
    [self reloadTableData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
                                 

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    if ([[User currentUser] messagesTo]) {
        return [[User currentUser] messagesTo].count;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"infoCell" forIndexPath:indexPath];
    cell.backgroundColor = [UIColor colorWithWhite:1 alpha:0];
    UILabel *label = (UILabel *)[cell.contentView viewWithTag:10];
    
    Message *message = [[[User currentUser] messagesTo] objectAtIndex:indexPath.item];
    label.text = message.text;
    // Configure the cell...
    
    return cell;
}

- (void)reloadTableData
{
    [self.tableView reloadData];
}

- (IBAction)goToPostStatusPage:(id)sender {
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Storyboard" bundle:nil];
    PostStatusViewController *vc = [storyBoard instantiateViewControllerWithIdentifier:@"PostStatusViewController"];
    [[UIApplication sharedApplication].delegate window].rootViewController = vc;

}
@end
