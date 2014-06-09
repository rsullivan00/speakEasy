//  speakEasy
//
//  Created by Daljeet Virdi on 5/19/14.
//
//
#import "AppDelegate.h"

#import <Parse/Parse.h>
#import "LoginViewController.h"
#import <Firebase/Firebase.h>
#import "Constants.h"
#import "User.h"
@implementation AppDelegate


#pragma mark - UIApplicationDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    /* Parse credentials for FB login */
    [Parse setApplicationId:@"HBBbbNkgmmZW6RjDLkDZ3CRKhBXmHI3koMAFf2Xt" clientKey:@"0rDGYbGbL098LXg0EiUXAcnpnsUYMUot1OUu22So"];

    [PFFacebookUtils initializeFacebook];

    // Override point for customization after application launch.
    self.window.rootViewController = [[UINavigationController alloc] initWithRootViewController:[[LoginViewController alloc] init]];
    self.window.backgroundColor = [UIColor whiteColor];
   
    [self.window makeKeyAndVisible];
    
    return YES;
}

/* App switching methods to support Facebook Single Sign-On. */
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    return [FBAppCall handleOpenURL:url
                  sourceApplication:sourceApplication
                        withSession:[PFFacebookUtils session]];
} 

- (void)applicationDidBecomeActive:(UIApplication *)application {
    [FBAppCall handleDidBecomeActiveWithSession:[PFFacebookUtils session]];
    /* Reduce current User's score according to inactive time */
    [[User currentUser] getScoreFromFirebase];
}

- (void)applicationWillTerminate:(UIApplication *)application {
    /*
     Called when the application is about to terminate.
     Save data if appropriate.
     See also applicationDidEnterBackground:.
     */
    [[PFFacebookUtils session] close];
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    /* Store timestamp for user when they close the app */
    NSString *dateURL = [NSString stringWithFormat:@"%@/users/%@/lastTimeAppWasUsed", FIREBASE_PREFIX, [[User currentUser] userID]];
    NSDate *start = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:DATE_DEFAULT];

    Firebase *date = [[Firebase alloc] initWithUrl:dateURL];
    NSString *dateString = [dateFormatter stringFromDate:start];
    [date setValue:dateString];
}


@end
