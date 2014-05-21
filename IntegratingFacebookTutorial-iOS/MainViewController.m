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
            
            NSString *firebaseURL = [NSString stringWithFormat:@"%@/users/%@/friends", FIREBASE_PREFIX, userID];
            
            Firebase *firebase = [[Firebase alloc] initWithUrl:firebaseURL];
            /* Make Facebook request for all friends' user IDs */
            FBRequest *friendRequest = [FBRequest requestForGraphPath:@"me/friends?fields=id"];
            [friendRequest startWithCompletionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
                if (!error) {
                    NSArray *data = [result objectForKey:@"data"];
                    int i = 0;
                    NSMutableArray *idArray = [[NSMutableArray alloc] init];
                    for (FBGraphObject<FBGraphUser> *friend in data) {
                        NSString *friendIndex = [NSString stringWithFormat:@"%d", i];
                        /* Add friend id to User's friends array on Firebase */
                        //[firebase setValue:@{friendIndex: friend.id}];
                        [idArray addObject:friend.id];
                        i++;
                        [currentUser getFriendMessages:friend.id];
                    }
                    
                    /* Update friends on firebase */
                    //[currentUser updateFireBaseFriends: idArray];
                    
                    /* Store updated user in Parse cloud */
                    /*
                    [[PFUser currentUser] setObject:currentUser.friends forKey:@"friends"];
                    [[PFUser currentUser] saveInBackground];
                     */
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
