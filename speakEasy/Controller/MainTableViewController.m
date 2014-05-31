//  speakEasy
//
//  Created by Daljeet Virdi on 5/19/14.
//
//

#import "MainTableViewController.h"
#import "PostStatusViewController.h"
#import "FriendPickerViewController.h"
#import "Constants.h"
#import "User.h"
#import "Message.h"
#import "MessageTableViewCell.h"
#import "Like.h"

@implementation MainTableViewController

@synthesize messageList = _messageList, spinner = _spinner;

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
    self.view.backgroundColor = [UIColor clearColor];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(reloadTableData) name:USER_INFO_UPDATE object:nil];
    
    self.tableView.separatorColor = [UIColor lightGrayColor];
    
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
    if ([[User currentUser] messagesTo]) {
        return [[User currentUser] messagesTo].count;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    User *currentUser = [User currentUser];
    if (currentUser == nil)
        return nil;
    
    MessageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"infoCell" forIndexPath:indexPath];
    cell.backgroundColor = [UIColor clearColor];

    /* Configure label with message text */
    Message *message = [currentUser.messagesTo objectAtIndex:indexPath.row];
    cell.textLabel.text = message.text;
    cell.textLabel.numberOfLines = 0;
    cell.textLabel.lineBreakMode = NSLineBreakByWordWrapping;
    cell.textLabel.textColor = [UIColor lightTextColor];
    
    /* Configure guess button */
    if (cell.guessButton == nil) {
        cell.guessButton = [UIButton buttonWithType:UIButtonTypeSystem];
        cell.guessButton.frame = CGRectMake(cell.contentView.frame.origin.x + 20, cell.contentView.frame.origin.y + 50, 41, 30);
        [cell.guessButton setTitle:@"guess" forState:UIControlStateNormal];
        [cell.guessButton addTarget:self action:@selector(goToFriendPickerView:) forControlEvents:UIControlEventTouchUpInside];
        cell.guessButton.backgroundColor = [UIColor clearColor];
        [cell.contentView addSubview:cell.guessButton];
    }
    cell.guessButton.tag = indexPath.row;
    
    if (!message.hasGuessed) {
        cell.guessButton.hidden = NO;
    } else {
        cell.guessButton.hidden = YES;
    }

    
    /* Configure score label */
    if (cell.scoreLabel == nil) {
        cell.scoreLabel = [[UILabel alloc] init];
        cell.scoreLabel.frame = CGRectMake(cell.contentView.frame.origin.x + 240, cell.contentView.frame.origin.y + 50, 41, 30);
        cell.scoreLabel.textColor = [UIColor lightTextColor];
        cell.scoreLabel.textAlignment = NSTextAlignmentCenter;
        [cell.contentView addSubview:cell.scoreLabel];
    }
    cell.scoreLabel.tag = indexPath.row;
    cell.scoreLabel.text = [NSString stringWithFormat:@"%d", message.score];
    
    /* Configure like button */
    if (cell.likeButton == nil) {
        cell.likeButton = [UIButton buttonWithType:UIButtonTypeSystem];
        cell.likeButton.frame = CGRectMake(cell.contentView.frame.origin.x + 270, cell.contentView.frame.origin.y + 50, 41, 30);
        [cell.likeButton setTitle:@"like" forState:UIControlStateNormal];
        [cell.likeButton addTarget:self action:@selector(likeMessage:) forControlEvents:UIControlEventTouchUpInside];
        cell.likeButton.backgroundColor = [UIColor clearColor];
        [cell.contentView addSubview:cell.likeButton];
    }
    cell.likeButton.tag = indexPath.row;
    
    return cell;
}

- (void)reloadTableData
{
    [self.tableView reloadData];
    if ([self.tableView numberOfRowsInSection:0] > 0) {
        [_spinner stopAnimating];
    }
}

-(void)likeMessage:(id)sender
{
    UIButton *button = (UIButton *)sender;
    User *currentUser = [User currentUser];
    Message *message = [currentUser.messagesTo objectAtIndex:button.tag];
    
    if ([currentUser hasLikedMessage:message]) {
        UIAlertView *a = [[UIAlertView alloc]initWithTitle:@"Liked" message:@"You have already liked this one" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [a show];
    } else {
        /* Update message */
        message.score++;
        NSString *firebaseURL = [NSString stringWithFormat:@"%@/users/%@/messages/%@/", FIREBASE_PREFIX, message.authorID, message.messageID];
        
        Firebase *firebase = [[Firebase alloc] initWithUrl:firebaseURL];
        
        [firebase updateChildValues:@{@"score":[NSNumber numberWithInt:message.score]}];
        
        /* Add Like to current User */
        Like *like = [[Like alloc] initWithMessage:message];
        [currentUser.likes addObject:like];
        
        firebaseURL = [NSString stringWithFormat:@"%@/users/%@/likes", FIREBASE_PREFIX, currentUser.userID];
        
        firebase = [[Firebase alloc] initWithUrl:firebaseURL];
        
        [[firebase childByAutoId] setValue:@{@"authorID":like.message.authorID, @"messageID":like.message.messageID}];
    }
}

- (void)goToFriendPickerView:(id)sender
{
    UIButton *button = (UIButton *)sender;
    Message *message = (Message *)[[[User currentUser] messagesTo] objectAtIndex:button.tag];
    if ([[User currentUser] hasGuessedOnMessage:message]) {
        UIAlertView *a = [[UIAlertView alloc]initWithTitle:@"Guessed" message:@"You have already guessed this one" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [a show];
    } else {
        UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Storyboard" bundle:nil];
        FriendPickerViewController *vc = [storyBoard instantiateViewControllerWithIdentifier:@"FriendPickerViewController"];
        vc.message = [[[User currentUser] messagesTo] objectAtIndex:button.tag];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

@end