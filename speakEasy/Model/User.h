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
@property (strong) NSString *userID;
@property (readwrite, assign) int score;
@property (copy) NSString *name;
@property (strong) NSMutableArray *friends;
@property (strong) NSMutableArray *messagesBy;
@property (strong) NSMutableArray *messagesTo;
@property (strong) NSMutableArray *guesses;
@property (strong) NSMutableArray *likes;

/* Designated initializer */
- (id) initWithId:(NSString *)userID name:(NSString *)name;
- (id) initWithId:(NSString *) userID;

- (BOOL) hasGuessedOnMessage: (Message *)message;
- (BOOL) hasLikedMessage: (Message *)message;
- (NSString *) imageURL;
- (void) getFriendMessages:(User *) friend;
- (void) getLikes;
- (void) getGuesses;
- (void) populateFriendsFromFirebase;
- (void) updateFireBaseFriends:(NSArray *) friendIDs;
-(void) addOneToScore;

@end
