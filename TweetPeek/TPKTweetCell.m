//
//  TPKTweetCell.m
//  TweetPeek
//
//  Created by Felipe Lobo on 9/24/15.
//  Copyright © 2015 Felipe Lobo. All rights reserved.
//

#import "TPKTweetCell.h"
#import "TPKTweet.h"
#import "TPKTwitterUser.h"
#import "TPKTwitterService.h"
#import "UIColor+TPK.h"

@implementation TPKTweetCell

- (instancetype)init
{
    self = [super init];
    if (self)
        [self initialize];
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
        [self initialize];
    return self;
}

- (void)initialize
{
    self.backgroundColor = [UIColor colorWithWhite:.98f alpha:1.f];
    
    UIImageView *userImageView = [[UIImageView alloc] init];
    userImageView.contentMode = UIViewContentModeScaleAspectFit;
    userImageView.translatesAutoresizingMaskIntoConstraints = NO;
    
    [userImageView addObserver:self forKeyPath:@"frame" options:NSKeyValueObservingOptionNew context:nil];
    
    [self addSubview:userImageView];
    
    self.userImageView = userImageView;
    
    UILabel *userNameLabel = [[UILabel alloc] init];
    userNameLabel.font = [UIFont fontWithName:@"HelveticaNeue-Medium" size:22.f];
    userNameLabel.textColor = UIColorWithRGB(94, 159, 202);
    userNameLabel.translatesAutoresizingMaskIntoConstraints = NO;
    
    [self addSubview:userNameLabel];
    
    self.userNameLabel = userNameLabel;
    
    UILabel *statusLabel = [[UILabel alloc] init];
    statusLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:22.f];
    statusLabel.textColor = [UIColor colorWithWhite:.2f alpha:1.f];
    statusLabel.numberOfLines = 0;
    statusLabel.translatesAutoresizingMaskIntoConstraints = NO;
    
    [self addSubview:statusLabel];
    
    self.statusLabel = statusLabel;
    
    NSDictionary *views = NSDictionaryOfVariableBindings(userNameLabel, userImageView, statusLabel);
    
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|-55-[userImageView(==77)]-33-[statusLabel]-66-|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:nil views:views]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:userNameLabel attribute:NSLayoutAttributeLeftMargin relatedBy:NSLayoutRelationEqual toItem:statusLabel attribute:NSLayoutAttributeLeftMargin multiplier:1.f constant:.0f]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:userNameLabel attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:statusLabel attribute:NSLayoutAttributeWidth multiplier:1.f constant:.0f]];
    
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-33-[userNameLabel(==25)]-6-[statusLabel]-33-|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:nil views:views]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:userImageView attribute:NSLayoutAttributeTopMargin relatedBy:NSLayoutRelationEqual toItem:userNameLabel attribute:NSLayoutAttributeTopMargin multiplier:1.f constant:0.f]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:userImageView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.f constant:77.f]];
}

- (void)setTweet:(TPKTweet *)tweet
{
    _tweet = tweet;
    
    self.userNameLabel.text = tweet.sender.name;
    self.statusLabel.text = tweet.text;

    if (tweet.sender.profileImage)
        self.userImageView.image = tweet.sender.profileImage;
    else
    {
        self.userImageView.alpha = .0f;
        [[TPKTwitterService sharedService] loadImageWithURL:tweet.sender.profileImageURL completion:^(UIImage *image) {
            tweet.sender.profileImage = image;
            self.userImageView.image = image;
            
            [UIView animateWithDuration:.2f animations:^{
                self.userImageView.alpha = 1.f;
            }];
        }];
    }
}

- (void)prepareForReuse
{
    self.userImageView.image = nil;
    self.userImageView.alpha = 1.f;
    
    [[TPKTwitterService sharedService] cancelDownloadTaskForURL:self.tweet.sender.profileImageURL];
}

@end
