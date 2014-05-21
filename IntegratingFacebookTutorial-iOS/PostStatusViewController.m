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

- (IBAction)addMessage:(id)sender {
    User *currentUser = [User currentUser];
    
    NSString *text = messageTextView.text;
    Message *message = [[Message alloc] initWithText:text];
    [currentUser.messagesBy addObject:message];
    
    NSString *firebaseURL = [NSString stringWithFormat:@"%@/users/%@/messages", FIREBASE_PREFIX, [currentUser userID]];

    Firebase *firebase = [[Firebase alloc] initWithUrl:firebaseURL];
    
    Firebase *firebaseLocation = [firebase childByAutoId];
    [firebaseLocation setValue:text];
    
    /* Clear the text field and close the keyboard */
    messageTextView.text = @"";
    [messageTextView resignFirstResponder];
}
@end
