//
//  User.h
//  AnonChat
//
//  Created by Rick Sullivan on 5/11/14.
//
//

#import <Foundation/Foundation.h>

@interface User : NSObject

+(User *) information;
/* Unique userId corresponding to our DB table */


@property NSString *userID;


-(NSMutableArray *) friends;
/* Array of messageIds for the user's messages */

-(NSMutableArray *) messages;
@end
