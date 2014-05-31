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
- (id) initWithAuthorID:authorID messageID:messageID
{
    if (self = [super init]) {
        User *currrentUser = [User currentUser];
        for (User *friend in currrentUser.friends) {
            if (friend.userID == authorID) {
                for (Message *message in friend.messagesBy) {
                    if (message.messageID == messageID) {
                        self.message = message;
                        return self;
                    }
                }
            }
        }
    }
    
    return self;
}


@end
