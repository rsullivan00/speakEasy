//  speakEasy
//
//  Created by Daljeet Virdi on 5/19/14.
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
