//
//  FriendTableViewController.m
//  speakEasy
//
//  Created by Rick Sullivan on 5/25/14.
//
//

#import "FriendTableViewController.h"
#import "User.h"

@implementation FriendTableViewController

@synthesize delegate;

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
    self.tableView.backgroundColor = [UIColor clearColor];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([[User currentUser] friends]) {
        return [[User currentUser] friends].count;
    }
    
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"friendCell" forIndexPath:indexPath];
    cell.backgroundColor = [UIColor clearColor];
    
    User *friend = [[[User currentUser] friends] objectAtIndex:indexPath.item];
    cell.textLabel.text = friend.name;
    
    /* Add thumbnail image to cell */
    NSURL *url = [NSURL URLWithString:friend.imageURL];
    NSData *data = [NSData dataWithContentsOfURL:url];
    cell.imageView.image = [[UIImage alloc] initWithData:data];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    User *friend = [[[User currentUser] friends] objectAtIndex:indexPath.row];
    [self.delegate handleFriendSelection:friend];
}

@end
