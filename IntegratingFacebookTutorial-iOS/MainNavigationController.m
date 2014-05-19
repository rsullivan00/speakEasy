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
    Firebase* f = [[Firebase alloc] initWithUrl:@"https://speakeasy.firebaseapp.com"];
    [f setValue:@"Do you have data? You'll love Firebase."];
    Firebase* nameRef = [[Firebase alloc] initWithUrl:@"https://speakeasy.firebaseapp.com/users"];
    [nameRef setValue:@{@"first": @"Fred", @"last": @"Swanson"}];
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

@end
