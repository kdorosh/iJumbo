//
//  IJLocationTableViewCell.m
//  iJumbo
//
//  Created by Amadou Crookes on 8/17/14.
//  Copyright (c) 2014 Amadou.It. All rights reserved.
//

#import "IJLocationTableViewCell.h"

#import "UIColor+iJumboColors.h"

@interface IJLocationTableViewCell ()
@property(nonatomic) UILabel *nameLabel;
@property(nonatomic) UIButton *mapButton;
@property(nonatomic) UIButton *infoButton;
@property(nonatomic) IJLocation *location;
@end

@implementation IJLocationTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
  self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
  if (self) {
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    const CGFloat padding = 20;
    CGSize cellSize = self.frame.size;
    CGFloat width_third = (cellSize.width - (2 * padding))/3.0f;
    _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(padding, 0, 2 * width_third, kLocationTableViewCellHeight)];
    _mapButton = [[UIButton alloc] initWithFrame:CGRectMake(padding + (2 * width_third), 0, width_third/2.0f, kLocationTableViewCellHeight)];
    CGRect mapFrame = _mapButton.frame;
    _infoButton = [[UIButton alloc] initWithFrame:CGRectMake(mapFrame.origin.x + mapFrame.size.width, 0, mapFrame.size.width, mapFrame.size.height)];
    NSMutableAttributedString *underlinedMapString = [[NSMutableAttributedString alloc] initWithString:@"Map"];
    [underlinedMapString addAttribute:NSUnderlineStyleAttributeName
                                value:@(1)
                                range:(NSRange){0, [underlinedMapString length]}];
    NSMutableAttributedString *underlinedInfoString = [[NSMutableAttributedString alloc] initWithString:@"Info"];
    [underlinedInfoString addAttribute:NSUnderlineStyleAttributeName
                                 value:@(1)
                                 range:(NSRange){0, [underlinedInfoString length]}];

    [_mapButton setAttributedTitle:underlinedMapString forState:UIControlStateNormal];
    [_infoButton setAttributedTitle:underlinedInfoString forState:UIControlStateNormal];
    [_mapButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_infoButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    _nameLabel.font = [UIFont regularFontWithSize:17];
    _nameLabel.textColor = [UIColor iJumboBlackText];
    _mapButton.titleLabel.font = [UIFont lightFontWithSize:17];
    _infoButton.titleLabel.font = [UIFont lightFontWithSize:17];

    [_mapButton addTarget:self action:@selector(mapButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [_infoButton addTarget:self action:@selector(infoButtonAction) forControlEvents:UIControlEventTouchUpInside];
    
    [self addSubview:_nameLabel];
    [self addSubview:_mapButton];
    [self addSubview:_infoButton];
  }
  return self;
}

- (void)mapButtonAction {
  [self.delegate didClickMapButton:self];
}

- (void)infoButtonAction {
  [self.delegate didClickInfoButton:self];
}

- (void)addDataFromLocation:(IJLocation *)location {
  self.location = location;
  self.nameLabel.text = location.name;
}

@end
