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
@property NSString *name;
@property NSMutableArray *friends;
@property NSMutableArray *messagesBy;
@property NSMutableArray *messagesTo;

/* Designated initializer */
- (id) initWithId:(NSString *)userID name:(NSString *)name;
- (id) initWithId:(NSString *) userID;

- (NSString *) imageURL;
- (void) getFriendMessages:(NSString*) friendID;
- (void) populateFriendsFromFirebase;
- (void) updateFireBaseFriends:(NSArray *) friendIDs;

@end
