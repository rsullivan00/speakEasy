//  speakEasy
//
//  Created by Daljeet Virdi on 5/19/14.
//
//

#import "PostStatusViewController.h"
#import "Constants.h"
#import "Message.h"

@implementation PostStatusViewController

@synthesize messageTextView, submitButton;

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
    
    /* Initialize UI styling */
    self.view.backgroundColor = [UIColor clearColor];
    
    submitButton.layer.cornerRadius = 8.0f;
//    submitButton.layer.borderWidth = 1;
    submitButton.layer.borderColor = [UIColor grayColor].CGColor;
    submitButton.layer.backgroundColor=[[UIColor colorWithWhite:0 alpha:0.1] CGColor];
    submitButton.layer.borderWidth= 0.01f;

    messageTextView.layer.cornerRadius=8.0f;
    messageTextView.layer.masksToBounds=YES;
    messageTextView.layer.borderColor=[[UIColor blueColor]CGColor];
    messageTextView.layer.borderWidth= 0.01f;
    messageTextView.layer.backgroundColor=[[UIColor colorWithWhite:0 alpha:0.1] CGColor];
    messageTextView.placeholderText = TEXTVIEW_PLACEHOLDER;
    
    
    
    
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
    if ([text isEqualToString:@""]) {
        UIAlertView *a = [[UIAlertView alloc]initWithTitle:@"Empty message" message:@"Mr. T says \"Enter some text, foo!\"" delegate:nil cancelButtonTitle:@"OK Mr. T..." otherButtonTitles: nil];
        [a show];
        return;
    }
    Message *message = [[Message alloc] initWithText:text];
    [currentUser.messagesBy addObject:message];
    
    NSString *firebaseURL = [NSString stringWithFormat:@"%@/users/%@/messages/", FIREBASE_PREFIX, [currentUser userID]];

    Firebase *firebase = [[Firebase alloc] initWithUrl:firebaseURL];
    
    Firebase *firebaseLocation = [firebase childByAutoId];
    [firebaseLocation setValue:@{@"text":text, @"score":[NSNumber numberWithInt:message.score]}];
    
    /* Clear the text field and close the keyboard */
    messageTextView.text = @"";
    [messageTextView resignFirstResponder];
    
    NSString *scoreURL = [NSString stringWithFormat:@"%@/users/%@/score", FIREBASE_PREFIX, [[User currentUser] userID]];
    Firebase *scoreFirebase = [[Firebase alloc] initWithUrl:scoreURL];
    
    __block FirebaseHandle handle = [scoreFirebase observeEventType:FEventTypeValue withBlock:^(FDataSnapshot *snapshot) {
        [scoreFirebase removeObserverWithHandle:handle];
        if(snapshot.value == [NSNull null]) {
            NSLog(@"this user has no score");
            [scoreFirebase setValue:@(0.02)];
        } else {
            NSNumber* data = snapshot.value;
            [scoreFirebase setValue:@(data.doubleValue + 0.02)];
        }
    }];

    
    [[NSNotificationCenter defaultCenter] postNotificationName:USER_INFO_UPDATE object:nil];
    
}
@end
