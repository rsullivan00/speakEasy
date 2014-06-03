//  speakEasy
//
//  Created by Daljeet Virdi on 5/19/14.
//
//

#import "Message.h"
#import "User.h"
#import "FriendPickerViewController.h"

@implementation Message

@synthesize messageID = _messageID, score = _score, text = _text, authorID = _authorID, date = _date;

+(NSString *) newMessageID;
{
    User *currentUser = [User currentUser];
    return [NSString stringWithFormat:@"%@%lu", currentUser.userID, (unsigned long)currentUser.messagesBy.count];
}

- (id) init
{
    return [self initWithText:nil];
}

- (id) initWithText:(NSString *)text
{
    return [self initWithID:[Message newMessageID] authorID:[User currentUser].userID text:text];
}

- (id) initWithID:(NSString *)messageID authorID:(NSString *)authorID text:(NSString *)text
{
    return [self initWithID:messageID authorID:authorID text:text date:[NSDate date]];
}

- (id) initWithID:(NSString *)messageID authorID:(NSString *)authorID text:(NSString *)text date:(NSDate *)date
{
    if (self = [super init]) {
        self.messageID = messageID;
        self.authorID = authorID;
        self.text = text;
        self.score = 0;
        self.date = date;
    }
    
    return self;
}

- (id) initWithMessage:(Message *)message
{
    return [self initWithID:message.messageID authorID:message.authorID text:message.text date:message.date];
}


@end
