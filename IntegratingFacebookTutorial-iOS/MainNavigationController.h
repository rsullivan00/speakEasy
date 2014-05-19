//
//  MainNavigationController.h
//  IntegratingFacebookTutorial
//
//  Created by Rick Sullivan on 5/17/14.
//
//
#import <Firebase/Firebase.h>
#import <QuartzCore/QuartzCore.h>
#import <Parse/Parse.h>

#import <UIKit/UIKit.h>

@interface MainNavigationController : UINavigationController
@property (nonatomic, strong) NSMutableArray *friendsArray;

@end
