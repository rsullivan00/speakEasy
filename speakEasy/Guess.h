//
//  Guess.h
//  speakEasy
//
//  Created by Rick Sullivan on 5/30/14.
//
//

#import <Foundation/Foundation.h>
#import "Message.h"

@interface Guess : NSObject

@property Message *message;

/* Designated initializer */
- (id) initWithAuthorID:authorID messageID:messageID;

@end
