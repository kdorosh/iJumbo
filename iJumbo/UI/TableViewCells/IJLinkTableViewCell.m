//
//  IJLinkTableViewCell.m
//  iJumbo
//
//  Created by Amadou Crookes on 8/17/14.
//  Copyright (c) 2014 Amadou.It. All rights reserved.
//

#import "IJLinkTableViewCell.h"

@interface IJLinkTableViewCell ()
@property(nonatomic) UILabel *linkLabel;
@end

@implementation IJLinkTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
      UIView *backView = [[UIView alloc] initWithFrame:CGRectZero];
      self.backgroundView = backView;
      self.backgroundColor = [UIColor clearColor];
      const int padding = 20;
      CGFloat cellWidth = self.frame.size.width;
      self.linkLabel = [[UILabel alloc] initWithFrame:CGRectMake(padding, 0, cellWidth - (2 * padding), kLinkTableViewCellHeight)];
      [self addSubview:self.linkLabel];
    }
    return self;
}

- (void)addDataFromLink:(IJLink *)link {
  NSMutableAttributedString *underlinedString = [[NSMutableAttributedString alloc] initWithString:link.name];
  [underlinedString addAttribute:NSUnderlineStyleAttributeName
                          value:@(1)
                          range:(NSRange){0, [underlinedString length]}];
  self.linkLabel.attributedText = underlinedString;
}

@end
