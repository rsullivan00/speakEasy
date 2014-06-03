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
    
    // ****************************************************************************
    // Fill in with your Parse credentials:
    // ****************************************************************************
    [Parse setApplicationId:@"HBBbbNkgmmZW6RjDLkDZ3CRKhBXmHI3koMAFf2Xt" clientKey:@"0rDGYbGbL098LXg0EiUXAcnpnsUYMUot1OUu22So"];

    // ****************************************************************************
    // Your Facebook application id is configured in Info.plist.
    // ****************************************************************************
    [PFFacebookUtils initializeFacebook];

    // Override point for customization after application launch.
    self.window.rootViewController = [[UINavigationController alloc] initWithRootViewController:[[LoginViewController alloc] init]];
    self.window.backgroundColor = [UIColor whiteColor];
   
    [self.window makeKeyAndVisible];
    
    NSString *dateURL = [NSString stringWithFormat:@"%@/users/%@/lastTimeAppWasUsed", FIREBASE_PREFIX, [[User currentUser] userID]];
    Firebase *date = [[Firebase alloc] initWithUrl:dateURL];
    [date observeEventType:FEventTypeValue withBlock:^(FDataSnapshot *snapshot) {
        NSLog(@"fred's first name is: %@", [NSString stringWithFormat:@"%@", snapshot.value]);
    }];
    
    NSLog(@"HELLO!!!!");
    

    
    return YES;
}

// ****************************************************************************
// App switching methods to support Facebook Single Sign-On.
// ****************************************************************************
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    return [FBAppCall handleOpenURL:url
                  sourceApplication:sourceApplication
                        withSession:[PFFacebookUtils session]];
} 

- (void)applicationDidBecomeActive:(UIApplication *)application {
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
    
    [FBAppCall handleDidBecomeActiveWithSession:[PFFacebookUtils session]];
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
    NSString *dateURL = [NSString stringWithFormat:@"%@/users/%@/lastTimeAppWasUsed", FIREBASE_PREFIX, [[User currentUser] userID]];
    NSDate *start = [NSDate date];

    Firebase *date = [[Firebase alloc] initWithUrl:dateURL];
    [date setValue:[NSString stringWithFormat:@"%@", start]];
    NSLog(@"Updating date");

}


@end
