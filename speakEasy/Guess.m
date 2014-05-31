//
//  Guess.m
//  speakEasy
//
//  Created by Rick Sullivan on 5/30/14.
//
//

#import "Guess.h"
#import "User.h"

@implementation Guess

@synthesize message = _message;

/* Designated initializer */
- (id) initWithMessage: (Message *)message
{
    if (self = [super init]) {
        self.message = message;
    }
    
    return self;
}

- (id) initWithAuthorID: (NSString *)authorID messageID: (NSString *)messageID
{
    User *currrentUser = [User currentUser];
    for (User *friend in currrentUser.friends) {
        if ([friend.userID isEqual:authorID]) {
            for (Message *message in friend.messagesBy) {
                if ([message.messageID isEqual:messageID]) {
                    return [self initWithMessage:message];
                }
            }
        }
    }
    
    return self;
}

@end
