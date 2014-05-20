//
//  User.m
//  AnonChat
//
//  Created by Rick Sullivan on 5/11/14.
//
//

#import "User.h"

@implementation User

@synthesize userID, friends, messagesBy, messagesTo;

/* Singleton User for the currently logged-in User */
static User *currentUser;

+ (User *) currentUser
{
    @synchronized (self)
    {
        if (!currentUser)
        {
            currentUser = [[User alloc] init];
        }
    }
    return currentUser;
}

+(NSString *) friendsKey
{
    return [NSString stringWithFormat:@"facebookFriends%@", currentUser.userID];
}

- (id) initWithId: (NSString *) userID
{
    if (self = [super init]) {
        self.userID = userID;
    }
    
    return self;
}
@end

