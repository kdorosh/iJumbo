//
//  IJLocationTableViewCell.m
//  iJumbo
//
//  Created by Amadou Crookes on 8/17/14.
//  Copyright (c) 2014 Amadou.It. All rights reserved.
//

#import "IJLocationTableViewCell.h"

@interface IJLocationTableViewCell ()
@property(nonatomic) UILabel *nameLabel;
@property(nonatomic) UIButton *mapButton;
@property(nonatomic) UIButton *infoButton;
@end

@implementation IJLocationTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
  self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
  if (self) {
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
    // TODO(amadou): Add underline to map and info buttons.
    _nameLabel.font = [UIFont fontWithName:@"Roboto-Light" size:15];
    _mapButton.titleLabel.font = [UIFont fontWithName:@"Roboto-Light" size:15];
    _infoButton.titleLabel.font = [UIFont fontWithName:@"Roboto-Light" size:15];
    
    [self addSubview:_nameLabel];
    [self addSubview:_mapButton];
    [self addSubview:_infoButton];
  }
  return self;
}

- (void)addDataFromLocation:(IJLocation *)location {
  if (!location.section) {
    NSLog(@"%@", location);
  }
  self.nameLabel.text = location.name;
}

@end
