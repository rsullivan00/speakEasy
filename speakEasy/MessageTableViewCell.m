//
//  MessageTableViewCell.m
//  speakEasy
//
//  Created by Rick Sullivan on 5/30/14.
//
//

#import "MessageTableViewCell.h"

@implementation MessageTableViewCell

@synthesize scoreLabel = _scoreLabel, guessButton = _guessButton, likeButton = _likeButton;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
