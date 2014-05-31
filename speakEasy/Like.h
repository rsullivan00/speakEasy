//
//  Like.h
//  speakEasy
//
//  Created by Rick Sullivan on 5/30/14.
//
//

#import <Foundation/Foundation.h>
#import "Message.h"

@interface Like : NSObject

@property (strong) Message *message;

/* Designated initializer */
- (id) initWithMessage: (Message *)message;
- (id) initWithAuthorID: (NSString *)authorID messageID: (NSString *)messageID;

@end
