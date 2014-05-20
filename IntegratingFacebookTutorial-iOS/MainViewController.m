//
//  MainViewController.m
//  speakEasy
//
//  Created by Daljeet Virdi on 5/19/14.
//
//

#import "MainViewController.h"
#import "User.h"
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
    [self getUsers];
    // Do any additional setup after loading the view.
}
-(void)getUsers{
    
    [self getMyUserIdAndMyFriends];
    
    
}
-(void)getMyUserIdAndMyFriends{
    
    
    __block NSString *url = nil;
    
 
    
    [[FBRequest requestForMe] startWithCompletionHandler: ^(FBRequestConnection *connection, NSDictionary<FBGraphUser> *aUser, NSError *error) {
        if (!error) {
            NSLog(@"User id %@",[aUser objectForKey:@"id"]);
            NSString *user = [NSString stringWithFormat:@"%@", [aUser objectForKey:@"id"]];
            
            
            
            NSLog(@"The hyperlink is: %@", [NSString stringWithFormat:@"https://speakeasy.firebaseio.com/users/%@/friends", [aUser objectForKey:@"id"]]);
            url = [NSString stringWithFormat:@"https://speakeasy.firebaseio.com/users/%@/friends", [aUser objectForKey:@"id"]];
            
            NSLog(@"The url is %@", url);
            NSLog(@"The url issss %@", url);
            
            
            
            User *hello = [[User alloc] init];
            
            [[hello userID] isEqualToString:[NSString stringWithFormat:@"%@", [aUser objectForKey:@"id"]]];
            
            Firebase *nameRef = [[Firebase alloc] initWithUrl:url];
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
        
    }];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
