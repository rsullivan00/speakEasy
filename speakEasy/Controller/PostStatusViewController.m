//  speakEasy
//
//  Created by Daljeet Virdi on 5/19/14.
//
//

#import "PostStatusViewController.h"
#import "Constants.h"
#import "Message.h"

@implementation PostStatusViewController

@synthesize messageTextView, submitButton,scoreLabel;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Default-568h@2x.png"]];
    [[self view] addSubview:imageView];
    [[self view] sendSubviewToBack:imageView];
    [[self view] setOpaque:NO];
    
    if(!([User currentUser].score == 0))
        scoreLabel.text = [NSString stringWithFormat:@"B.A.C. = %0.02f", [User currentUser].score];
    [self reloadData];
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    /*gesture control */
    UISwipeGestureRecognizer *swipeLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeLeft:)];
    swipeLeft.direction = UISwipeGestureRecognizerDirectionLeft;
    [self.view addGestureRecognizer:swipeLeft];
    swipeLeft.delegate = self;
    
    UISwipeGestureRecognizer *swipeRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeRight:)];
    swipeRight.direction = UISwipeGestureRecognizerDirectionRight;
    [self.view addGestureRecognizer:swipeRight];
    swipeRight.delegate = self;
    
    
    /* Initialize UI styling */
    self.view.backgroundColor = [UIColor clearColor];
    
    submitButton.layer.cornerRadius = 8.0f;
    submitButton.layer.borderColor = [UIColor grayColor].CGColor;
    submitButton.layer.backgroundColor=[[UIColor colorWithWhite:0 alpha:0.2] CGColor];
    submitButton.layer.borderWidth= 0.01f;

    messageTextView.layer.cornerRadius=8.0f;
    messageTextView.layer.masksToBounds=YES;
    messageTextView.layer.borderColor=[[UIColor blueColor]CGColor];
    messageTextView.layer.borderWidth= 0.01f;
    messageTextView.layer.backgroundColor=[[UIColor colorWithWhite:0 alpha:0.2] CGColor];
    messageTextView.placeholderText = TEXTVIEW_PLACEHOLDER;
    
}

-(void) swipeRight:(UISwipeGestureRecognizer *) recognizer {
    if (recognizer.direction == UISwipeGestureRecognizerDirectionRight)
        NSLog(@"swipe right");
    [self.tabBarController setSelectedIndex:0];

}

-(void) swipeLeft:(UISwipeGestureRecognizer *) recognizer {
    if (recognizer.direction == UISwipeGestureRecognizerDirectionLeft)
        NSLog(@"swipe left");
    [self.tabBarController setSelectedIndex:2];
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
        UIAlertView *a = [[UIAlertView alloc]initWithTitle:@"Empty message"
                                                   message:@"Mr. T says \"Enter some text, foo!\""
                                                  delegate:nil cancelButtonTitle:@"OK Mr. T..."
                                         otherButtonTitles: nil];
        [a show];
        return;
    } else if ([text length] > MAX_MESSAGE_LENGTH) {
        UIAlertView *a = [[UIAlertView alloc]initWithTitle:@"Message too long"
                                                   message:[NSString stringWithFormat:@"Messages have a limit of %d characters. Yours has %d.", MAX_MESSAGE_LENGTH, [text length]]
                                                  delegate:nil cancelButtonTitle:@"Back"
                                         otherButtonTitles: nil];
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
    [self reloadData];
}


- (void)reloadData
{
    NSString *scoreURL = [NSString stringWithFormat:@"%@/users/%@/", FIREBASE_PREFIX, [[User currentUser] userID]];
    Firebase *scoreFirebase = [[Firebase alloc] initWithUrl:scoreURL];
    
    __block FirebaseHandle handle = [scoreFirebase observeEventType:FEventTypeValue withBlock:^(FDataSnapshot *snapshot) {
        [scoreFirebase removeObserverWithHandle:handle];
        if(snapshot.value == [NSNull null]) {
            NSLog(@"this user has no score");
            scoreLabel.text = @"You're sober! B.A.C. = 0";
        } else {
            NSDictionary* data = snapshot.value;
            
            for (NSString *key in data) {
                if([key isEqualToString:@"score"]){
                    
                    [User currentUser].score = [[data valueForKey:key] doubleValue];
                    scoreLabel.text = [NSString stringWithFormat:@"B.A.C. = %0.02f", [User currentUser].score];
                }
                
            }
        }
    }];
}

@end
