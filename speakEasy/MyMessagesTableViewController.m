//  speakEasy
//
//  Created by Daljeet Virdi on 5/19/14.
//
//

#import "MyMessagesTableViewController.h"
#import "PostStatusViewController.h"
#import "FriendPickerViewController.h"
#import "Constants.h"
#import "User.h"
#import "Message.h"
#import "MessageTableViewCell.h"

@implementation MyMessagesTableViewController

@synthesize spinner = _spinner;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:BACKGROUND_IMAGE]];
    self.tableView.backgroundView = imageView;
    //self.view.backgroundColor = [UIColor clearColor];
    [self setTitle:@"My posts"]; 
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(reloadTableData) name:USER_INFO_UPDATE object:nil];
    
    self.tableView.separatorColor = [UIColor lightGrayColor];
    self.tableView.rowHeight = 80;

    /* Start spinner until data is loaded */
    [_spinner setHidesWhenStopped:YES];
    [_spinner startAnimating];
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
    if ([[User currentUser] messagesBy]) {
        return [[User currentUser] messagesBy].count;
    }
    return 0;
}

/* Added to set custom heights for cells */
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return the number of rows in the section.
    if ([[User currentUser] messagesBy]) {
        NSString *messageText = [[[[User currentUser] messagesBy] objectAtIndex:indexPath.row] text];
        UILabel *gettingSizeLabel = [[UILabel alloc] init];
        gettingSizeLabel.font = [UIFont systemFontOfSize:17];
        gettingSizeLabel.text = messageText;
        gettingSizeLabel.numberOfLines = 0;
        gettingSizeLabel.lineBreakMode = NSLineBreakByWordWrapping;
        CGSize maximumLabelSize = CGSizeMake(310, 9999);
        
        CGSize expectSize = [gettingSizeLabel sizeThatFits:maximumLabelSize];
        return expectSize.height + 80;
    }
    
    return 80;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    User *currentUser = [User currentUser];
    if (currentUser == nil)
        return nil;
    
    MessageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"myMessageCell" forIndexPath:indexPath];
    cell.backgroundColor = [UIColor clearColor];
    
    /* Configure label with message text */
    Message *message = [currentUser.messagesBy objectAtIndex:indexPath.row];
    cell.textLabel.text = message.text;
    cell.textLabel.numberOfLines = 0;
    cell.textLabel.lineBreakMode = NSLineBreakByWordWrapping;
    cell.textLabel.textColor = [UIColor lightTextColor];
    
    /* Configure score label */
    if (cell.scoreLabel == nil) {
        cell.scoreLabel = [[UILabel alloc] init];
        cell.scoreLabel.frame = CGRectMake(cell.frame.origin.x + 240, cell.frame.size.height - 30, 41, 30);
        cell.scoreLabel.textColor = [UIColor lightTextColor];
        cell.scoreLabel.textAlignment = NSTextAlignmentCenter;
        [cell.contentView addSubview:cell.scoreLabel];
    }
    cell.scoreLabel.tag = indexPath.row;
    cell.scoreLabel.text = [NSString stringWithFormat:@"%d", message.score];
    
    return cell;
}

- (void)reloadTableData
{
    [self.tableView reloadData];
    if ([self.tableView numberOfRowsInSection:0] > 0) {
        [_spinner stopAnimating];
    }
}


@end
