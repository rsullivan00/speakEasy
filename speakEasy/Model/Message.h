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
@property NSString *authorName;
@property NSString *authorID;
@property NSDate *date;

@property (nonatomic, readwrite) BOOL hasGuessed;

-(id) init;
- (id) initWithText:(NSString *)text;
- (id) initWithText:(NSString *)text authorName:(NSString *)authorName;
- (id) initWithID:(NSString *)messageID authorID:(NSString *)authorID text:(NSString *)text;
/* Designated initializer */
- (id) initWithID:(NSString *)messageID authorName:(NSString *)authorName authorID:(NSString *)authorID text:(NSString *)text;

/* Returns a unique ID for a new message by the current User */
+(NSString *) newMessageID;

@end