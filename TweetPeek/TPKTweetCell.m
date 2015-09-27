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

@interface TPKTweetCell ()

@property (nonatomic, strong) NSMutableArray *regularConstraints;
@property (nonatomic, strong) NSMutableArray *compactConstraints;

@end

@implementation TPKTweetCell

#pragma mark - Initialization

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
    
    [self addSubview:userImageView];
    
    self.userImageView = userImageView;
    
    UILabel *userNameLabel = [[UILabel alloc] init];
    userNameLabel.textColor = UIColorWithRGB(94, 159, 202);
    userNameLabel.translatesAutoresizingMaskIntoConstraints = NO;
    
    [self addSubview:userNameLabel];
    
    self.userNameLabel = userNameLabel;
    
    UILabel *statusLabel = [[UILabel alloc] init];
    statusLabel.textColor = [UIColor colorWithWhite:.2f alpha:1.f];
    statusLabel.numberOfLines = 0;
    statusLabel.translatesAutoresizingMaskIntoConstraints = NO;
    
    [self addSubview:statusLabel];
    
    self.statusLabel = statusLabel;
    
    [self createConstraints];
}

#pragma mark - Properties
#pragma mark Set

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

#pragma mark - Layout

- (void)createConstraints
{
    NSDictionary *views = NSDictionaryOfVariableBindings(_userNameLabel, _userImageView, _statusLabel);
    
    NSMutableArray *regularConstraints = [[NSMutableArray alloc] init];
    NSMutableArray *compactConstraints = [[NSMutableArray alloc] init];
    
    NSArray *constraints;
    
    constraints = [NSLayoutConstraint constraintsWithVisualFormat:@"|-55-[_userImageView(==77)]-33-[_statusLabel]-66-|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:nil views:views];
    [regularConstraints addObjectsFromArray:constraints];
    [self addConstraints:constraints];
    
    constraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-33-[_userNameLabel(==25)]-6-[_statusLabel]-33-|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:nil views:views];
    [regularConstraints addObjectsFromArray:constraints];
    [self addConstraints:constraints];
    
    constraints = [NSLayoutConstraint constraintsWithVisualFormat:@"|-21-[_userImageView(==40)]-15-[_statusLabel]-30-|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:nil views:views];
    [compactConstraints addObjectsFromArray:constraints];
    [self addConstraints:constraints];
    
    constraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-15-[_userNameLabel(==18)]-6-[_statusLabel]-15-|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:nil views:views];
    [compactConstraints addObjectsFromArray:constraints];
    [self addConstraints:constraints];

    self.regularConstraints = regularConstraints;
    self.compactConstraints = compactConstraints;
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_userNameLabel attribute:NSLayoutAttributeLeftMargin relatedBy:NSLayoutRelationEqual toItem:_statusLabel attribute:NSLayoutAttributeLeftMargin multiplier:1.f constant:.0f]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_userNameLabel attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:_statusLabel attribute:NSLayoutAttributeWidth multiplier:1.f constant:.0f]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_userImageView attribute:NSLayoutAttributeTopMargin relatedBy:NSLayoutRelationEqual toItem:_userNameLabel attribute:NSLayoutAttributeTopMargin multiplier:1.f constant:0.f]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_userImageView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:_userImageView attribute:NSLayoutAttributeWidth multiplier:1.f constant:0.f]];
    
    [self validateConstraints];
}

- (void)validateConstraints
{
    if (self.traitCollection.horizontalSizeClass == UIUserInterfaceSizeClassCompact || self.traitCollection.verticalSizeClass == UIUserInterfaceSizeClassCompact)
    {
        self.userNameLabel.font = [UIFont fontWithName:@"HelveticaNeue-Medium" size:15.f];
        self.statusLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:15.f];
        
        [NSLayoutConstraint activateConstraints:self.compactConstraints];
        [NSLayoutConstraint deactivateConstraints:self.regularConstraints];
    }
    else
    {
        self.userNameLabel.font = [UIFont fontWithName:@"HelveticaNeue-Medium" size:22.f];
        self.statusLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:22.f];
        
        [NSLayoutConstraint activateConstraints:self.regularConstraints];
        [NSLayoutConstraint deactivateConstraints:self.compactConstraints];
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [self validateConstraints];
}

#pragma mark - Collection cell

- (void)prepareForReuse
{
    self.userImageView.image = nil;
    self.userImageView.alpha = 1.f;
    
    [[TPKTwitterService sharedService] cancelDownloadTaskForURL:self.tweet.sender.profileImageURL];
}

@end
