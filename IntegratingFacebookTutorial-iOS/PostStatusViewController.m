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
    self.view.backgroundColor = [UIColor clearColor];
    
    messageTextView.layer.cornerRadius=8.0f;
    messageTextView.layer.masksToBounds=YES;
    messageTextView.layer.borderColor=[[UIColor blueColor]CGColor];
    messageTextView.layer.borderWidth= 0.1f;
    messageTextView.layer.backgroundColor=[[UIColor colorWithWhite:0 alpha:0.5] CGColor];
    messageTextView.placeholderText = TEXTVIEW_PLACEHOLDER;
    [UIFont fontWithName:@"riesling" size:64.0];
    
       // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/* Whenever the background is touched, we want to check if the keyboard is open and close it if so. */
-(IBAction) screenTouch
{
    if (messageTextView.isFirstResponder) {
        [messageTextView resignFirstResponder];
    }
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
    Message *message = [[Message alloc] initWithText:text];
    [currentUser.messagesBy addObject:message];
    
    NSString *firebaseURL = [NSString stringWithFormat:@"%@/users/%@/messages", FIREBASE_PREFIX, [currentUser userID]];

    Firebase *firebase = [[Firebase alloc] initWithUrl:firebaseURL];
    
    Firebase *firebaseLocation = [firebase childByAppendingPath:message.messageID];
    [firebaseLocation setValue:text];
}
@end
