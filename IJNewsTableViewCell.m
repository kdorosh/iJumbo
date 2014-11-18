//
//  IJNewsTableViewCell.m
//  iJumbo
//
//  Created by Amadou Crookes on 8/16/14.
//  Copyright (c) 2014 Amadou.It. All rights reserved.
//

#import "IJNewsTableViewCell.h"
#import "IJServer.h"

static NSDateFormatter *kNewsCellDateFormatter;

@interface IJNewsTableViewCell ()
@property(nonatomic) UILabel *titleLabel;
@property(nonatomic) UILabel *authorLabel;
@property(nonatomic) CGRect originalTitleLabelFrame;
@property(nonatomic) CGRect originalSectionLabelFrame;
@property(nonatomic) UILabel *dateLabel;
@property(nonatomic) UILabel *sectionLabel;
@property(nonatomic) IJArticle *article;
@end

@implementation IJNewsTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
  self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
  if (self) {
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    UIView *backView = [[UIView alloc] initWithFrame:CGRectZero];
    self.backgroundView = backView;
    self.backgroundColor = [UIColor clearColor];
    CGFloat width = self.frame.size.width;
    
    CGFloat contentInsetX = 10;
    CGFloat contentInsetY = 4;

    UIView *contentView =
        [[UIView alloc] initWithFrame:
            CGRectMake(contentInsetX, contentInsetY, width - (2 * contentInsetX), kNewsTableViewCellHeight - (2 * contentInsetY))];
    contentView.backgroundColor = [UIColor iJumboGrey];
    width = contentView.width;

    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(contentInsetX, contentInsetY, 3 * width / 4.0f - 20, contentView.height/2.0f)];
    self.titleLabel.numberOfLines = 0;
    self.titleLabel.textColor = [UIColor iJumboBlackText];
    self.titleLabel.font = [UIFont regularFontWithSize:15];
    
    self.sectionLabel = [[UILabel alloc] initWithFrame:CGRectMake(3 * width / 4, contentInsetY, width / 4.0f - 10, contentView.height/5.0f)];
    self.originalSectionLabelFrame = self.sectionLabel.frame;
    self.sectionLabel.font = [UIFont regularFontWithSize:12];
    self.sectionLabel.numberOfLines = 0;
    self.sectionLabel.textAlignment = NSTextAlignmentRight;
    self.sectionLabel.textColor = [UIColor colorWithWhite:0 alpha:0.55];

    self.dateLabel = [[UILabel alloc ] initWithFrame:CGRectMake(contentInsetX, self.titleLabel.maxY, self.titleLabel.width, kNewsTableViewCellHeight/4)];
    self.dateLabel.font = [UIFont lightFontWithSize:12];

    self.originalTitleLabelFrame = self.titleLabel.frame;
    CGSize titleSize = self.titleLabel.frame.size;
    const CGFloat authorHeight = kNewsTableViewCellHeight/4.0f;
    self.authorLabel = [[UILabel alloc] initWithFrame:CGRectMake(contentInsetX, contentView.height -  authorHeight, titleSize.width, authorHeight)];
    self.authorLabel.font = [UIFont lightFontWithSize:12];
    self.authorLabel.textColor = [UIColor colorWithWhite:0 alpha:0.70];
    [contentView addSubview:self.titleLabel];
    [contentView addSubview:self.authorLabel];
    [contentView addSubview:self.dateLabel];
    [contentView addSubview:self.sectionLabel];
    self.authorLabel.text = @"";
    [self addSubview:contentView];
  }
  return self;
}

- (void)addDataFromArticle:(IJArticle *)article {
  self.article = article;
  [self setTitleText:article.title];
  [self setSectionText:article.section];
  if (article.author) {
    self.authorLabel.text = [NSString stringWithFormat:@"by %@", article.author];
  } else {
    self.authorLabel.text = @"N/A";
  }
  if (!kNewsCellDateFormatter) {
    kNewsCellDateFormatter = [[NSDateFormatter alloc] init];
    [kNewsCellDateFormatter setDateFormat:@"MMM, d YYYY"];
    NSTimeZone *timeZone = [[NSTimeZone alloc] initWithName:@"GMT"];
    [kNewsCellDateFormatter setTimeZone:timeZone];
  }
  self.dateLabel.text = [kNewsCellDateFormatter stringFromDate:article.posted];
}

- (void)setTitleText:(NSString *)text {
  self.titleLabel.frame = self.originalTitleLabelFrame;
  self.titleLabel.text = text;
  [self.titleLabel sizeToFit];
  if (self.titleLabel.height > self.originalTitleLabelFrame.size.height) {
    self.titleLabel.frame = self.originalTitleLabelFrame;
  }
  self.dateLabel.frame = CGRectMake(self.titleLabel.frame.origin.x, self.titleLabel.maxY - 4, 3 * self.width / 4, kNewsTableViewCellHeight/4.0f);
}

- (void)setSectionText:(NSString *)text {
  self.sectionLabel.text = text;
  self.sectionLabel.frame = self.originalSectionLabelFrame;
  [self.sectionLabel sizeToFit];
  CGPoint oldCenter = self.sectionLabel.center;
  self.sectionLabel.center = CGPointMake(self.sectionLabel.superview.width - self.sectionLabel.width / 2.0f - 10, oldCenter.y);
}

@end
