//
//  Like.m
//  speakEasy
//
//  Created by Rick Sullivan on 5/30/14.
//
//

#import "Like.h"
#import "User.h"

@implementation Like

@synthesize message = _message, authorID = _authorID, messageID = _messageID;

/* Designated initializer */
- (id) initWithMessage: (Message *)message
{
    if (self = [super init]) {
        self.message = message;
        if (message != nil) {
            self.authorID = message.authorID;
            self.messageID = message.messageID;
        }
    }
    
    return self;
}

- (id) initWithAuthorID: (NSString *)authorID messageID: (NSString *)messageID
{
    if (self = [self initWithMessage:nil]) {
        _authorID = authorID;
        _messageID = messageID;
        [self setMessageFromIDs];
    }
    
    return self;
}

- (void) setMessageFromIDs
{
    if (_message != nil)
        return;
    
    User *currrentUser = [User currentUser];
    for (User *friend in currrentUser.friends) {
        if ([friend.userID isEqual:_authorID]) {
            for (Message *message in friend.messagesBy) {
                if ([message.messageID isEqual:_messageID]) {
                    _message = message;
                }
            }
        }
    }
}

@end
