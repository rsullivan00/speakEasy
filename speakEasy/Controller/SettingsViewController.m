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
{
    NSArray *friendsByScore;
}

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
    
    friendsByScore = [[User currentUser].friends sortedArrayUsingComparator: ^(id a, id b) {
        User *first = a;
        User *second = b;
        if (first.score > second.score) {
            return NSOrderedDescending;
        } else if (first.score < second.score) {
            return NSOrderedAscending;
        } else {
            return NSOrderedSame;
        }
    }];
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
    User *friend = [friendsByScore objectAtIndex:indexPath.item];
    cell.textLabel.text = friend.name;

    /* Add thumbnail image to cell */
    NSURL *url = [NSURL URLWithString:friend.imageURL];
    NSData *data = [NSData dataWithContentsOfURL:url];
    cell.imageView.image = [[UIImage alloc] initWithData:data];
    
    return cell;
}

@end
