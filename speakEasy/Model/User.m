//  speakEasy
//
//  Created by Daljeet Virdi on 5/19/14.
//
//

#import "User.h"
#import "Message.h"
#import "Constants.h"
#import <Firebase/Firebase.h>

@implementation User

@synthesize userID = _userID, name = _name, friends = _friends, messagesBy = _messagesBy, messagesTo = _messagesTo;

/* Singleton User for the currently logged-in User */
static User *currentUser;

+ (User *) currentUser
{
    @synchronized (self)
    {
        if (!currentUser)
        {
            NSLog(@"Error, there is no logged in user");
            /* Go to login view */
        }
    }
    return currentUser;
}

+ (User *) newCurrentUser: (NSString *) userID
{
    @synchronized (self)
    {
        currentUser = [[User alloc] initWithId:userID];
    }
    
    return currentUser;
}

+(NSString *) friendsKey
{
    return [NSString stringWithFormat:@"facebookFriends%@", currentUser.userID];
}

- (id) initWithId: (NSString *) userID
{
    return [self initWithId:userID name:nil];
}

- (id) initWithId:(NSString *)userID name:(NSString *)name
{
    if (self = [super init]) {
        self.userID = userID;
        self.name = name;
        self.friends = [[NSMutableArray alloc] init];
        self.messagesTo = [[NSMutableArray alloc] init];
        self.messagesBy = [[NSMutableArray alloc] init];
    }
    
    return self;
}

/* Returns the URL of a thumbnail image for the user */
- (NSString *) imageURL
{
    return [NSString stringWithFormat:@"http://graph.facebook.com/%@/picture?type=square", self.userID];
}


/* Populates the friends array with Friend objects using the data on Firebase */
- (void) populateFriendsFromFirebase
{
    NSString *firebaseURL = [NSString stringWithFormat:@"%@/users/%@/friends", FIREBASE_PREFIX, self.userID];
    Firebase *firebase = [[Firebase alloc] initWithUrl:firebaseURL];
    
    [firebase observeEventType:FEventTypeValue withBlock:^(FDataSnapshot *snapshot) {
        /* This block will be triggered whenever the user's friends change on firebase */
        if(snapshot.value == [NSNull null]) {
            NSLog(@"this user has no friends with the app");
        } else {
            NSDictionary* data = snapshot.value;
            for (NSString *friendID in data) {
                User *friend = [[User alloc] initWithId:friendID];
                [self.friends addObject:friend];
            }
        }
    }];
}

/* Rewrites the friend array on firebase for this user using the friendIDs array */
- (void) updateFireBaseFriends: (NSArray *) friendIDs
{
    NSString *firebaseURL = [NSString stringWithFormat:@"%@/users/%@/friends", FIREBASE_PREFIX, self.userID];
    Firebase *firebase = [[Firebase alloc] initWithUrl:firebaseURL];
    
    for (int i = 0; i < friendIDs.count; i++) {
        NSString *friendID = friendIDs[i];
        [firebase setValue:friendID forKey:[NSString stringWithFormat:@"%d",i]];
    }
}

/* Gets all friend messages and appends to message attribute using the given friendID */
- (void) getFriendMessages: (NSString*) friendID
{
    NSString *firebaseURL = [NSString stringWithFormat:@"%@/users/%@/messages", FIREBASE_PREFIX, friendID];
    
    Firebase *firebase = [[Firebase alloc] initWithUrl:firebaseURL];
    
    [firebase observeEventType:FEventTypeValue withBlock:^(FDataSnapshot *snapshot) {
        if(snapshot.value == [NSNull null]) {
            NSLog(@"this user has no friends");
        } else {
            NSDictionary* data = snapshot.value;
            for (NSString *text in data) {
                Message *message = [[Message alloc] initWithText:[data valueForKey:text]];
                [self.messagesTo addObject:message];
            }
        }
    }];
}
@end

