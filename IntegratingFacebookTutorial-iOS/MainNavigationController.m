//
//  MainNavigationController.m
//  IntegratingFacebookTutorial
//
//  Created by Rick Sullivan on 5/17/14.
//
//

#import "MainNavigationController.h"

@interface MainNavigationController ()

@end

@implementation MainNavigationController

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
    Firebase* f = [[Firebase alloc] initWithUrl:@"https://speakeasy.firebaseapp.com"];
    [f setValue:@"Do you have data? You'll love Firebase."];
    Firebase* nameRef = [[Firebase alloc] initWithUrl:@"https://speakeasy.firebaseio.com/users"];
    
    // And then we write data to his first and last name locations:
    [[nameRef childByAppendingPath:@"first"] setValue:@"jim"];
    [[nameRef childByAppendingPath:@"last"] setValue:@"john"];  
   
    NSLog(@"Hello");

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

@end
