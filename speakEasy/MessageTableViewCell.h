//
//  MessageTableViewCell.h
//  speakEasy
//
//  Created by Rick Sullivan on 5/30/14.
//
//

#import <UIKit/UIKit.h>

@interface MessageTableViewCell : UITableViewCell

@property (retain, nonatomic) UILabel *scoreLabel;
@property (weak, nonatomic) UIButton *guessButton;
@property (weak, nonatomic) UIButton *likeButton;

@end
