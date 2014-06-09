//  speakEasy
//
//  Created by Daljeet Virdi on 5/19/14.
//
//

#import <Foundation/Foundation.h>

@interface Message : NSObject

@property (copy) NSString *messageID;
@property (assign) int score;
@property (copy) NSString *text;
@property (copy) NSString *authorID;
@property (strong) NSDate *date;

-(id) init;
- (id) initWithText:(NSString *)text;
- (id) initWithID:(NSString *)messageID authorID:(NSString *)authorID text:(NSString *)text;
/* Designated initializer */
- (id) initWithID:(NSString *)messageID authorID:(NSString *)authorID text:(NSString *)text date:(NSDate *)date;

/* Returns a unique ID for a new message by the current User */
+(NSString *) newMessageID;

@end
