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
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"infoCell" forIndexPath:indexPath];
    cell.backgroundColor = [UIColor clearColor];

    /* Configure label with message text */
    Message *message = [currentUser.messagesTo objectAtIndex:indexPath.row];
    cell.textLabel.text = message.text;
    cell.textLabel.numberOfLines = 0;
    cell.textLabel.lineBreakMode = NSLineBreakByWordWrapping;
    cell.textLabel.textColor = [UIColor lightTextColor];
    
    /* Configure guess button */
    UIButton *guessButton = [UIButton buttonWithType:UIButtonTypeSystem];
    guessButton.frame = CGRectMake(cell.contentView.frame.origin.x + 20, cell.contentView.frame.origin.y + 50, 41, 30);
    guessButton.tag = indexPath.row;
    [guessButton setTitle:@"guess" forState:UIControlStateNormal];
    [guessButton addTarget:self action:@selector(goToFriendPickerView:) forControlEvents:UIControlEventTouchUpInside];
    guessButton.backgroundColor = [UIColor clearColor];
    if (!message.hasGuessed) {
        guessButton.hidden = NO;
    }else{
        guessButton.hidden = YES;
    }
    [cell.contentView addSubview:guessButton];
    
    /* Configure score label */
    UILabel *scoreLabel = [[UILabel alloc] init];
    scoreLabel.frame = CGRectMake(cell.contentView.frame.origin.x + 250, cell.contentView.frame.origin.y + 50, 41, 30);
    scoreLabel.tag = indexPath.row;
    scoreLabel.text = [NSString stringWithFormat:@"%d", message.score];
    scoreLabel.textColor = [UIColor lightTextColor];
    [cell.contentView addSubview:scoreLabel];
    
    /* Configure like button */
    UIButton *likeButton = [UIButton buttonWithType:UIButtonTypeSystem];
    likeButton.frame = CGRectMake(cell.contentView.frame.origin.x + 270, cell.contentView.frame.origin.y + 50, 41, 30);
    likeButton.tag = indexPath.row;
    [likeButton setTitle:@"like" forState:UIControlStateNormal];
    [likeButton addTarget:self action:@selector(likeMessage:) forControlEvents:UIControlEventTouchUpInside];
    likeButton.backgroundColor = [UIColor clearColor];
    [cell.contentView addSubview:likeButton];
    
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
    Message *message = [[[User currentUser] messagesTo] objectAtIndex:button.tag];
    message.score++;
    NSString *firebaseURL = [NSString stringWithFormat:@"%@/users/%@/messages/%@", FIREBASE_PREFIX, message.authorID,message.messageID];
    
    Firebase *firebase = [[Firebase alloc] initWithUrl:firebaseURL];
    
    [firebase setValue:[NSString stringWithFormat:@"%d", message.score] forKey:@"score"];
}

- (void)goToFriendPickerView:(id)sender
{
    UIButton *button = (UIButton *)sender;
    if ([(Message *)[[[User currentUser] messagesTo] objectAtIndex:button.tag] hasGuessed]) {
        UIAlertView *a = [[UIAlertView alloc]initWithTitle:@"Guessed" message:@"You have already guessed this one" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [a show];
    }else{
        UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Storyboard" bundle:nil];
        FriendPickerViewController *vc = [storyBoard instantiateViewControllerWithIdentifier:@"FriendPickerViewController"];
        vc.message = [[[User currentUser] messagesTo] objectAtIndex:button.tag];
        [self.navigationController pushViewController:vc animated:YES];
    }
}



@end
