//
//  MainNavigationController.m
//  IntegratingFacebookTutorial
//
//  Created by Rick Sullivan on 5/17/14.
//
//

#import "MainNavigationController.h"
#import "User.h"
@interface MainNavigationController ()

@end
NSString *userID;

@implementation MainNavigationController
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
    [self getUsers];
        // Do any additional setup after loading the view.
}
-(void)getUsers{
    [self getMyUserId];
    [self getFriends];
}
-(void)getMyUserId{
   
   // Firebase* nameRef = [[Firebase alloc] initWithUrl:@"https://speakeasy.firebaseio.com/users"];
    
    [[FBRequest requestForMe] startWithCompletionHandler:
     ^(FBRequestConnection *connection, NSDictionary<FBGraphUser> *aUser, NSError *error) {
         if (!error) {
             userID = [aUser objectForKey:@"id"];
             NSLog(@"User id %@",[aUser objectForKey:@"id"]);
             NSLog(@"the real User id %@",userID);
             NSLog(@"%@", [NSString stringWithFormat:@"https://speakeasy.firebaseio.com/users/%@/friends", userID]);
         }
     }];
}
-(void)getFriends{
    Firebase* f = [[Firebase alloc] initWithUrl:@"https://speakeasy.firebaseapp.com"];
    [f setValue:@"Do you have data? You'll love Firebase."];
    NSString *url = [NSString stringWithFormat:@"https://speakeasy.firebaseio.com/users/hello/friends"];
    Firebase* nameRef = [[Firebase alloc] initWithUrl:url];
    
    
    FBRequest *friendRequest = [FBRequest requestForGraphPath:@"me/friends?fields=id"];
    [friendRequest startWithCompletionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
        if (!error) {
            NSArray *data = [result objectForKey:@"data"];
            for (FBGraphObject<FBGraphUser> *friend in data) {
                int i = 0;
                NSLog(@"%@", [friend id]);
                NSString *intro = [NSString stringWithFormat:@"%d", i];
                [nameRef setValue:@{intro: [friend id]}];
                i++;
            }
            
            NSArray *facebookFriends = data;
            [[PFUser currentUser] setObject:facebookFriends forKey:@"facebookFriends"];
            [[PFUser currentUser] saveInBackground];
        }
        else {
            NSLog(@"Some other error: %@", error);
        }
    }];
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
