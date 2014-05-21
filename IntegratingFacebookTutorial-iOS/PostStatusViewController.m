//  speakEasy
//
//  Created by Daljeet Virdi on 5/19/14.
//
//

#import "PostStatusViewController.h"
#import "Constants.h"
#import "Message.h"

@implementation PostStatusViewController

@synthesize messageTextView;

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
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"Oceanic_Background_by_ka_chankitty.jpg"]];
    messageTextView.layer.cornerRadius=8.0f;
    messageTextView.layer.masksToBounds=YES;
    messageTextView.layer.borderColor=[[UIColor blueColor]CGColor];
    messageTextView.layer.borderWidth= 0.1f;
    [UIFont fontWithName:@"riesling" size:64.0];
    
       // Do any additional setup after loading the view.
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

- (IBAction)addMessage:(id)sender {
    User *currentUser = [User currentUser];
    NSLog(@"%@", [currentUser userID]);

    
    NSString *text = messageTextView.text;
    NSLog(@"%@", messageTextView.text);
    NSString *firebaseURL = [NSString stringWithFormat:@"%@/users/%@/messages", FIREBASE_PREFIX, [currentUser userID]];

    
    Firebase *firebase = [[Firebase alloc] initWithUrl:firebaseURL];
    
    Firebase *firebaseLocation = [firebase childByAutoId];
    NSLog(@"%@", firebaseLocation);

    
    [firebaseLocation setValue:text];
    
    
    
    //Post message to each of his friends.

}
@end
