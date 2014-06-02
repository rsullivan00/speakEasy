//  speakEasy
//
//  Created by Daljeet Virdi on 5/19/14.
//
//

#import "SettingsViewController.h"
#import "User.h"
#import "Constants.h"
#include <Firebase/Firebase.h>

@implementation SettingsViewController
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
    
    /*gesture control */
    UISwipeGestureRecognizer *swipeLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeLeft:)];
    swipeLeft.direction = UISwipeGestureRecognizerDirectionLeft;
    [self.view addGestureRecognizer:swipeLeft];
    swipeLeft.delegate = self;
    
    UISwipeGestureRecognizer *swipeRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeRight:)];
    swipeRight.direction = UISwipeGestureRecognizerDirectionRight;
    [self.view addGestureRecognizer:swipeRight];
    swipeRight.delegate = self;

    
    self.view.backgroundColor = [UIColor clearColor];
    self.tableView.separatorColor = [UIColor lightGrayColor];
    self.tableView.rowHeight = 80;
    

    // Do any additional setup after loading the view.
}

-(void) swipeRight:(UISwipeGestureRecognizer *) recognizer {
    if (recognizer.direction == UISwipeGestureRecognizerDirectionRight)
        NSLog(@"swipe right");
    [self.tabBarController setSelectedIndex:1];
    
}

-(void) swipeLeft:(UISwipeGestureRecognizer *) recognizer {
    if (recognizer.direction == UISwipeGestureRecognizerDirectionLeft)
        NSLog(@"swipe left");
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([[User currentUser] friends]) {
        
        return [[User currentUser] friends].count;
    }
    
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"friendCell" forIndexPath:indexPath];
    cell.backgroundColor = [UIColor clearColor];
    User *friend = [[[User currentUser] friends] objectAtIndex:indexPath.item];
    cell.textLabel.text = friend.name;
    NSString *firebaseURL = [NSString stringWithFormat:@"%@/users/%@/score",FIREBASE_PREFIX, [[[User currentUser] friends] objectAtIndex:indexPath.item]];
    Firebase *firebase = [[Firebase alloc] initWithUrl:firebaseURL];
    
    [firebase observeEventType:FEventTypeValue withBlock:^(FDataSnapshot *snapshot) {
        if(snapshot.value == [NSNull null]) {
            NSLog(@"this friend has no score");
            
        } else {
        }
    }];

    
    
    /* Add thumbnail image to cell */
    NSURL *url = [NSURL URLWithString:friend.imageURL];
    NSData *data = [NSData dataWithContentsOfURL:url];
    cell.imageView.image = [[UIImage alloc] initWithData:data];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    User *friend = [[[User currentUser] friends] objectAtIndex:indexPath.row];
    [self.delegate handleFriendSelection:friend];
}


@end
