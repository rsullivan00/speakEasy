//
//  PostStatusViewController.m
//  speakEasy
//
//  Created by Daljeet Virdi on 5/19/14.
//
//

#import "PostStatusViewController.h"

@interface PostStatusViewController ()

@end

@implementation PostStatusViewController
@synthesize textViewValue;

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
    textViewValue.layer.cornerRadius=8.0f;
    textViewValue.layer.masksToBounds=YES;
    textViewValue.layer.borderColor=[[UIColor blueColor]CGColor];
    textViewValue.layer.borderWidth= 0.1f;
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
    User *hello = [[User alloc] init];
    NSLog(@"%@", [hello userID]);
//    Firebase *nameRef = [[Firebase alloc] initWithUrl:url];
    
}
@end
