//
//  User.h
//  AnonChat
//
//  Created by Rick Sullivan on 5/11/14.
//
//

#import <Foundation/Foundation.h>

@interface User : NSObject

/* Array of messageIds for the user's messages */
@property NSMutableArray *messages;

/* Array of userIds of the User's friends */
@property NSMutableArray *friends;

/* Unique userId corresponding to our DB table */
@property NSInteger userID;

@end
