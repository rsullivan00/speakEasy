//  speakEasy
//
//  Created by Daljeet Virdi on 5/19/14.
//
//

#import "User.h"

@implementation User

static User *theOneInstance;

+ (User *) information
{
    @synchronized (self)
    {
        if (! theOneInstance)
        {
            theOneInstance = [[User alloc] init];
        }
    }
    return theOneInstance;
}


/* Array of userIds of the User's friends */

-(NSMutableArray *) friends{
    return [[User information] friends];
}
/* Array of messageIds for the user's messages */

-(NSMutableArray *) messages{
    return [[User information] messages];
}

- (id) init
{
    if (self = [super init]) {
        
        
    }
    return self;
}
@end

