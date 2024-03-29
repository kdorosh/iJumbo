//
//  IJLinkCollectionViewCell.m
//  iJumbo
//
//  Created by Amadou Crookes on 9/23/14.
//  Copyright (c) 2014 Amadou.It. All rights reserved.
//

static const int kNameLabelHeight = 25;

#import "IJLinkCollectionViewCell.h"

#import "IJLink.h"

#import "UIColor+iJumboColors.h"

@interface IJLinkCollectionViewCell ()
@property(nonatomic) UILabel *nameLabel;
@end

@implementation IJLinkCollectionViewCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
      self.backgroundColor = [UIColor colorWithWhite:1 alpha:0.75];
      self.nameLabel = [[UILabel alloc] init];
      self.nameLabel.frame = CGRectMake(0, self.height/2.0f - kNameLabelHeight/2.0f, self.width, kNameLabelHeight);
      self.nameLabel.textAlignment = NSTextAlignmentCenter;
      self.nameLabel.font = [UIFont regularFontWithSize:16];
      [self addSubview:self.nameLabel];
      self.nameLabel.textColor = [UIColor iJumboBlackText];
    }
    return self;
}

- (void)addDataFromLink:(IJLink *)link {
  NSAttributedString *underlinedName =
      [[NSAttributedString alloc] initWithString:link.name
                                      attributes:@{NSUnderlineStyleAttributeName: @(1)}];
  self.nameLabel.attributedText = underlinedName;
}

@end
