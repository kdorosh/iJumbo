//
//  IJNewsTableViewCell.m
//  iJumbo
//
//  Created by Amadou Crookes on 8/16/14.
//  Copyright (c) 2014 Amadou.It. All rights reserved.
//

#import "IJNewsTableViewCell.h"

@interface IJNewsTableViewCell ()
@property(nonatomic) UILabel *titleLabel;
@property(nonatomic) UILabel *authorLabel;
@property(nonatomic) CGRect originalTitleLabelFrame;
@end

@implementation IJNewsTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
  self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
  if (self) {
    UIView *backView = [[UIView alloc] initWithFrame:CGRectZero];
    self.backgroundView = backView;
    self.backgroundColor = [UIColor clearColor];
    CGFloat width = self.frame.size.width;
    CGFloat contentInset = 5;
    
    UIView *contentView =
        [[UIView alloc] initWithFrame:
            CGRectMake(contentInset, contentInset, width - (2 * contentInset), kNewsTableViewCellHeight - (2 * contentInset))];
    contentView.backgroundColor = kIJumboGrey;
    CGSize contentSize = contentView.frame.size;
    
    self.imageView.frame = CGRectMake(0, 0, contentSize.height + 20, contentSize.height);
    self.imageView.backgroundColor = [UIColor blackColor];
    self.imageView.image = nil;
    UIView *imageBack = [[UIView alloc] initWithFrame:self.imageView.frame];
    imageBack.backgroundColor = [UIColor darkGrayColor];
    [imageBack addSubview:self.imageView];
    [self.imageView removeFromSuperview];
    [contentView addSubview:imageBack];
    CGFloat imageWidth = self.imageView.frame.size.width;
    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(contentInset + imageWidth, contentInset, contentSize.width - (2 * contentInset) - imageWidth, contentSize.height - (2 * contentInset))];
    self.titleLabel.numberOfLines = 0;
    self.titleLabel.textColor = [UIColor blackColor];
    self.titleLabel.font = [UIFont fontWithName:@"Roboto-Light" size:13];
    self.originalTitleLabelFrame = self.titleLabel.frame;
    CGSize titleSize = self.titleLabel.frame.size;
    self.authorLabel = [[UILabel alloc] initWithFrame:CGRectMake(contentInset + imageWidth, kNewsTableViewCellHeight - (5.5 * contentInset), titleSize.width, kNewsTableViewCellHeight - titleSize.height)];
    self.authorLabel.font = [UIFont fontWithName:@"Roboto-Light" size:10];
    self.authorLabel.textColor = [UIColor colorWithWhite:0 alpha:0.70];
    [contentView addSubview:self.titleLabel];
    [contentView addSubview:self.authorLabel];
    self.authorLabel.text = @"";
    [self addSubview:contentView];
  }
  return self;
}

- (void)addDataFromArticle:(IJArticle *)article {
  [self setTitleText:article.title];
  if (article.author) {
    self.authorLabel.text = [NSString stringWithFormat:@"by %@", article.author];
  } else {
    self.authorLabel.text = @"";
  }
}

- (void)setTitleText:(NSString *)text {
  self.titleLabel.frame = self.originalTitleLabelFrame;
  self.titleLabel.text = text;
  [self.titleLabel sizeToFit];
}

@end
