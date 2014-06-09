//  speakEasy
//
//  Created by Daljeet Virdi on 5/19/14.
//
//

#import <Foundation/Foundation.h>

@interface Message : NSObject

@property NSString *messageID;
@property int score;
@property NSString *text;
@property NSString *authorID;
@property NSDate *date;

-(id) init;
- (id) initWithText:(NSString *)text;
- (id) initWithID:(NSString *)messageID authorID:(NSString *)authorID text:(NSString *)text;
/* Designated initializer */
- (id) initWithID:(NSString *)messageID authorID:(NSString *)authorID text:(NSString *)text date:(NSDate *)date;

/* Returns a unique ID for a new message by the current User */
+(NSString *) newMessageID;

@end
