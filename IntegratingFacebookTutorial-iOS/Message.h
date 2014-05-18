//
//  Message.h
//  AnonChat
//
//  Created by Rick Sullivan on 5/11/14.
//
//

#import <Foundation/Foundation.h>

@interface Message : NSObject

@property NSInteger *messageId;
@property int score;
@property NSString *text;
@property NSString *author;
@property NSInteger *authorId;
@property NSDate *date;

/* Designated initializer */
-(id) init;

@end
