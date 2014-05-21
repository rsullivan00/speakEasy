//  speakEasy
//
//  Created by Daljeet Virdi on 5/19/14.
//
//
#import <Foundation/Foundation.h>

@interface User : NSObject
/* Singleton instance of User */
+(User *) currentUser;
+ (User *) newCurrentUser: (NSString *) userID;

/* Returns a key for the current User's persistent friend data */
+(NSString *) friendsKey;

/* Unique userId corresponding to our DB table */
@property NSString *userID;
@property NSMutableArray *friends;
@property NSMutableArray *messagesBy;
@property NSMutableArray *messagesTo;

/* Designated initializer */
- (id) initWithId: (NSString *) userID;

- (void) getFriendMessages: (NSString*) friendID;
- (void) populateFriendsFromFirebase;
- (void) updateFireBaseFriends: (NSArray *) friendIDs;

@end
