//
//  User.h
//  AnonChat
//
//  Created by Rick Sullivan on 5/11/14.
//
//

#import <Foundation/Foundation.h>

@interface User : NSObject
/* Singleton instance of User */
+(User *) currentUser;

/* Returns a key for the current User's persistent friend data */
+(NSString *) friendsKey;

/* Unique userId corresponding to our DB table */
@property NSString *userID;
@property NSMutableArray *friends;
@property NSMutableArray *messagesBy;
@property NSMutableArray *messagesTo;

/* Designated initializer */
- (id) initWithId: (NSString *) userID;
@end
