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


@interface MainTableTableViewController (){
    NSArray *_listOfMessages;
}

@end

@implementation MainTableTableViewController

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
    NSLog(@"%@", [currentUser userID]);
    
    NSString *firebaseURL = [NSString stringWithFormat:@"%@/users/%@/friends", FIREBASE_PREFIX, [currentUser userID]];
    Firebase *firebase = [[Firebase alloc] initWithUrl:firebaseURL];
    
    [firebase observeEventType:FEventTypeValue withBlock:^(FDataSnapshot *snapshot) {
        if(snapshot.value == [NSNull null]) {
            NSLog(@"this user has no friends");
        } else {
            NSString* listOfFriends = snapshot.value;
            // NSString* lastName = snapshot.value[@"name"][@"last"];
            NSLog(@"%@", listOfFriends);
            
            //WHAT DO WE DO WITH LIST OF FRIENDS???
            //WE GO through each of the friends for and get the messages of those friends.
            //first we have to get the ids of each of the friends.

            //which we did above with listOFfriends.
            
            
            //NOW Below we are getting the messages of each of the friends
            
            //******** WE NEED TO MAKE THIS WORK FOR A USER THAT HAS MORE THAN ONE FRIEND *******
            
            NSString *firebaseURL = [NSString stringWithFormat:@"%@/users/%@/messages", FIREBASE_PREFIX, [currentUser userID]];
            Firebase *firebase = [[Firebase alloc] initWithUrl:firebaseURL];
            
            [firebase observeEventType:FEventTypeValue withBlock:^(FDataSnapshot *snapshot) {
                if(snapshot.value == [NSNull null]) {
                    NSLog(@"this user has no friends");
                } else {
                    if ([snapshot.value isKindOfClass:[NSDictionary class]]) {
                        _listOfMessages = [snapshot.value allValues];
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [self.tableView reloadData];
                        });
                        NSLog(@"the list is %@", _listOfMessages);

                    }
                    
                   // NSArray *components = [listOfMessagesFromFriend componentsSeparatedByString:@"="];
                    //NSString *query = [components lastObject];

                   // NSArray *hello = [listOfMessagesFromFriend componentsSeparatedByString:@"="];
                    //NSLog(@"This is the array %@", hello );
                    
                }
            }];
        }
        
       
        
    }];
                                 // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
                                 

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
#warning Incomplete method implementation.
    // Return the number of rows in the section.
    if (_listOfMessages) {
        return _listOfMessages.count;
    }
    return 0;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"infoCell" forIndexPath:indexPath];
    cell.backgroundColor = [UIColor colorWithWhite:1 alpha:0.5];
    UILabel *label = (UILabel *)[cell.contentView viewWithTag:10];
    
    label.text = [_listOfMessages objectAtIndex:indexPath.item];
    // Configure the cell...
    
    return cell;
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)goToPostStatusPage:(id)sender {
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Storyboard" bundle:nil];
    PostStatusViewController *vc = [storyBoard instantiateViewControllerWithIdentifier:@"PostStatusViewController"];
    [[UIApplication sharedApplication].delegate window].rootViewController = vc;

}
@end
