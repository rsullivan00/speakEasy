//  speakEasy
//
//  Created by Daljeet Virdi on 5/19/14.
//
//
#import <Foundation/Foundation.h>
#import "Message.h"

@interface User : NSObject
/* Singleton instance of User */
+(User *) currentUser;
+ (User *) newCurrentUser: (NSString *) userID;

/* Returns a key for the current User's persistent friend data */
+(NSString *) friendsKey;

/* Unique userId corresponding to our DB table */
@property NSString *userID;
@property (readwrite, assign) int score;
@property NSString *name;
@property NSMutableArray *friends;
@property NSMutableArray *messagesBy;
@property NSMutableArray *messagesTo;
@property NSMutableArray *guesses;

/* Designated initializer */
- (id) initWithId:(NSString *)userID name:(NSString *)name;
- (id) initWithId:(NSString *) userID;

- (BOOL) hasGuessedOnMessage: (Message *)message;
- (NSString *) imageURL;
- (void) getFriendMessages:(User *) friend;
- (void) populateFriendsFromFirebase;
- (void) updateFireBaseFriends:(NSArray *) friendIDs;
-(void) addOneToScore;

@end
