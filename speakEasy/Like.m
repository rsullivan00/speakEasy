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
        if (friend.userID == authorID) {
            for (Message *message in friend.messagesBy) {
                if (message.messageID == messageID) {
                    return [self initWithMessage:message];
                }
            }
        }
    }
    
    return self;
}

@end
