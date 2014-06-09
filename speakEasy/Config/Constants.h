//
//  Constants.h
//  speakEasy
//
//  Created by Rick Sullivan on 5/19/14.
//
//  Contains configuration for the speakEasy app.

#import <Foundation/Foundation.h>

@interface Constants : NSObject

/* Firebase DB URL */
extern NSString *FIREBASE_PREFIX;
/* Placeholder text for PostStatusView */
extern NSString *TEXTVIEW_PLACEHOLDER;
/* Notification string for when the User's information is updated */
extern NSString *USER_INFO_UPDATE;
/* Notification string for when the User loads new messages */
extern NSString *USER_MESSAGES_TO_UPDATE;
extern NSString *BACKGROUND_IMAGE;
/* Default formatting string for dates */
extern NSString *DATE_DEFAULT;
extern int MAX_MESSAGE_LENGTH;
extern double SCORE_LOSS_PER_HOUR;

@end
