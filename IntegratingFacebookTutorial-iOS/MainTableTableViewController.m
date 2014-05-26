//  speakEasy
//
//  Created by Daljeet Virdi on 5/19/14.
//
//

#import "MainTableTableViewController.h"
#import "PostStatusViewController.h"
#import "FriendPickerViewController.h"
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

    /* Configure label with message text */
    Message *message = [[[User currentUser] messagesTo] objectAtIndex:indexPath.row];
    cell.textLabel.text = message.text;
    cell.textLabel.numberOfLines = 0;
    cell.textLabel.lineBreakMode = NSLineBreakByWordWrapping;
    
    /* Configure guess button */
    UIButton *guessButton = [UIButton buttonWithType:UIButtonTypeSystem];
    guessButton.frame = CGRectMake(cell.contentView.frame.origin.x + 20, cell.contentView.frame.origin.y + 50, 41, 30);
    guessButton.tag = indexPath.row;
    [guessButton setTitle:@"guess" forState:UIControlStateNormal];
    [guessButton addTarget:self action:@selector(goToFriendPickerView:) forControlEvents:UIControlEventTouchUpInside];
    guessButton.backgroundColor = [UIColor clearColor];
    [cell.contentView addSubview:guessButton];
    
    return cell;
}

- (void)reloadTableData
{
    [self.tableView reloadData];
}

- (IBAction)goToPostStatusView:(id)sender
{
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Storyboard" bundle:nil];
    PostStatusViewController *vc = [storyBoard instantiateViewControllerWithIdentifier:@"PostStatusViewController"];
    [[UIApplication sharedApplication].delegate window].rootViewController = vc;
}

- (void)goToFriendPickerView:(id)sender
{
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Storyboard" bundle:nil];
    FriendPickerViewController *vc = [storyBoard instantiateViewControllerWithIdentifier:@"FriendPickerViewController"];
    UIButton *button = (UIButton *)sender;
    vc.message = [[[User currentUser] messagesTo] objectAtIndex:button.tag];
    [self presentViewController:vc animated:YES completion:nil];
    //[[UIApplication sharedApplication].delegate window].rootViewController = vc;
}


@end
