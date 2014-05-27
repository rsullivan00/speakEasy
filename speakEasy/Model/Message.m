//  speakEasy
//
//  Created by Daljeet Virdi on 5/19/14.
//
//

#import "Message.h"
#import "User.h"
#import "FriendPickerViewController.h"

@implementation Message

@synthesize messageID = _messageID, score = _score, text = _text, authorName = _authorName, authorID = _authorID, date = _date;

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

- (id) initWithText:(NSString *)text authorName:(NSString *)authorName
{
    return [self initWithID:[Message newMessageID] authorName:authorName authorID:[User currentUser].userID text:text];
}

- (id) initWithID:(NSString *)messageID authorID:(NSString *)authorID text:(NSString *)text
{
    return [self initWithID:messageID authorName:nil authorID:authorID text:text];
}

- (id) initWithID:(NSString *)messageID authorName:(NSString *)authorName authorID:(NSString *)authorID text:(NSString *)text
{
    if (self = [super init]) {
        self.messageID = messageID;
        self.authorName = authorName;
        self.authorID = authorID;
        self.text = text;
        self.score = 0;
        self.date = [NSDate date];
    }
    
    return self;
}


@end
