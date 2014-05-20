//
//  PostStatusViewController.m
//  speakEasy
//
//  Created by Daljeet Virdi on 5/19/14.
//
//

#import "PostStatusViewController.h"
#import "Constants.h"
#import "Message.h"

@implementation PostStatusViewController

@synthesize messageTextView, authorTextView;

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
    NSString *authorName = authorTextView.text;
    
    Message *newMessage = [[Message alloc] initWithText:text authorName:authorName];
    [[User currentUser].messagesBy addObject:newMessage];

    NSString *firebaseURL = [NSString stringWithFormat:@"%@/messages/%@", FIREBASE_PREFIX, newMessage.messageID];
    Firebase *firebase = [[Firebase alloc] initWithUrl:firebaseURL];
    [firebase setValue:@{newMessage.messageID: @{@"text":newMessage.text, @"authorID":newMessage.authorID, @"authorName":newMessage.authorName, @"date":newMessage.date, @"score":[NSString stringWithFormat:@"%d", newMessage.score]}}];
}
@end
