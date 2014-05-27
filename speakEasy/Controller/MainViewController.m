//  speakEasy
//
//  Created by Daljeet Virdi on 5/19/14.
//
//

#import "MainViewController.h"
#import "User.h"
#import "Constants.h"

@interface MainViewController ()

@end

@implementation MainViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self.tabBarController.tabBar setTranslucent:YES];
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Oceanic_Background_by_ka_chankitty.jpg"]];
    [[self view] addSubview:imageView];
    [[self view] sendSubviewToBack:imageView];
    [[self view] setOpaque:NO];
    [[self view] setBackgroundColor:[UIColor clearColor]];
    
    [self getUsers];
    
   
}
-(void)getUsers
{
    [self initializeCurrentUser];
}

-(void)initializeCurrentUser
{
    /* Populate currentUser singleton instance with appropriate data */
    [[FBRequest requestForMe] startWithCompletionHandler: ^(FBRequestConnection *connection, NSDictionary<FBGraphUser> *aUser, NSError *error) {
        if (!error) {
            NSString *userID = [NSString stringWithFormat:@"%@", [aUser objectForKey:@"id"]];
            User *currentUser = [User newCurrentUser:userID];
            
            /* Make Facebook request for all friends' user IDs */
            FBRequest *friendRequest = [FBRequest requestForGraphPath:@"me/friends?fields=id,name,picture"];
            [friendRequest startWithCompletionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
                if (!error) {
                    NSArray *data = [result objectForKey:@"data"];
                    NSMutableArray *idArray = [[NSMutableArray alloc] init];
                    for (FBGraphObject<FBGraphUser> *friend in data) {
                        
                        User *newFriend = [[User alloc] initWithId:friend.id name:friend.name];
                        [idArray addObject:friend.id];

                        [currentUser getFriendMessages:friend.id];
                        [currentUser.friends addObject:newFriend];
                    }
                    
                    /* Update friends on firebase */
                    [currentUser updateFireBaseFriends: idArray];
                } else {
                    NSLog(@"Some other error: %@", error);
                }
            }];
        }
        
    }];
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
