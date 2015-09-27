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

@property (nonatomic, strong) UIView *contentContainerView;
@property (nonatomic, strong) UIView *actionsContainerView;

@property (nonatomic, strong) NSArray *actionButtons;

@property (nonatomic, strong) NSMutableArray *regularConstraints;
@property (nonatomic, strong) NSMutableArray *compactConstraints;

@property (nonatomic, strong) NSMutableArray *actionsContentContainerConstraints;
@property (nonatomic, strong) NSMutableArray *defaultContentContainerConstraints;

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

    UIView *actionsContainerView = [[UIView alloc] init];
    actionsContainerView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"action_background.png"]];
    actionsContainerView.translatesAutoresizingMaskIntoConstraints = NO;
    
    [self.contentView addSubview:actionsContainerView];
    
    self.actionsContainerView = actionsContainerView;
    
    NSMutableArray *mutableButtons = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < 4; i++)
    {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.translatesAutoresizingMaskIntoConstraints = NO;
        [button setImage:[UIImage imageNamed:@"botao_generico_off.png"] forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:@"botao_generico_on.png"] forState:UIControlStateSelected];
        [button addTarget:self action:@selector(didTapActionButton:) forControlEvents:UIControlEventTouchUpInside];
        
        [mutableButtons addObject:button];
        
        [actionsContainerView addSubview:button];
    }
    
    self.actionButtons = [NSArray arrayWithArray:mutableButtons];
    
    UIView *contentContainerView = [[UIView alloc] init];
    contentContainerView.backgroundColor = self.backgroundColor;
    contentContainerView.translatesAutoresizingMaskIntoConstraints = NO;

    [self.contentView addSubview:contentContainerView];
    
    self.contentContainerView = contentContainerView;
    
    UIImageView *userImageView = [[UIImageView alloc] init];
    userImageView.contentMode = UIViewContentModeScaleAspectFit;
    userImageView.translatesAutoresizingMaskIntoConstraints = NO;
    
    [contentContainerView addSubview:userImageView];
    
    self.userImageView = userImageView;
    
    UILabel *userNameLabel = [[UILabel alloc] init];
    userNameLabel.textColor = UIColorWithRGB(94, 159, 202);
    userNameLabel.translatesAutoresizingMaskIntoConstraints = NO;
    
    [contentContainerView addSubview:userNameLabel];
    
    self.userNameLabel = userNameLabel;
    
    UILabel *statusLabel = [[UILabel alloc] init];
    statusLabel.textColor = [UIColor colorWithWhite:.2f alpha:1.f];
    statusLabel.numberOfLines = 0;
    statusLabel.translatesAutoresizingMaskIntoConstraints = NO;
    
    [contentContainerView addSubview:statusLabel];
    
    self.statusLabel = statusLabel;
    
    UISwipeGestureRecognizer *swipeGestureRecognizer;
    
    swipeGestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(didSwipe:)];
    swipeGestureRecognizer.direction = UISwipeGestureRecognizerDirectionRight;
    
    [self addGestureRecognizer:swipeGestureRecognizer];
    
    swipeGestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(didSwipe:)];
    swipeGestureRecognizer.direction = UISwipeGestureRecognizerDirectionLeft;

    [self addGestureRecognizer:swipeGestureRecognizer];
    
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

#pragma mark - Actions

- (void)didTapActionButton:(UIButton *)sender
{
    sender.selected = !sender.selected;
}

- (void)didSwipe:(UISwipeGestureRecognizer *)swipe
{
    [self showActions:swipe.direction == UISwipeGestureRecognizerDirectionRight animated:YES];
}

- (void)showActions:(BOOL)show animated:(BOOL)animated
{
    if (show)
    {
        [NSLayoutConstraint activateConstraints:self.actionsContentContainerConstraints];
        [NSLayoutConstraint deactivateConstraints:self.defaultContentContainerConstraints];
    }
    else
    {
        [NSLayoutConstraint deactivateConstraints:self.actionsContentContainerConstraints];
        [NSLayoutConstraint activateConstraints:self.defaultContentContainerConstraints];
    }
    
    [UIView animateWithDuration:animated ? .2f : .0f animations:^{
        [self.contentView layoutIfNeeded];
    }];
}

#pragma mark - Layout

- (void)createConstraints
{
    NSDictionary *views = NSDictionaryOfVariableBindings(_userNameLabel, _userImageView, _statusLabel, _contentContainerView, _actionsContainerView);
    
    NSMutableArray *regularConstraints = [[NSMutableArray alloc] init];
    NSMutableArray *compactConstraints = [[NSMutableArray alloc] init];
    
    NSArray *constraints;
    NSLayoutConstraint *constraint;
    NSMutableDictionary *actionViews = [[NSMutableDictionary alloc] init];
    
    for (int i = 0; i < self.actionButtons.count; i++)
    {
        NSString *bx = [NSString stringWithFormat:@"b%d", i];
        actionViews[bx] = self.actionButtons[i];
        
        constraints = [NSLayoutConstraint constraintsWithVisualFormat:[NSString stringWithFormat:@"V:|-33-[%@(==77)]", bx] options:NSLayoutFormatDirectionLeadingToTrailing metrics:nil views:actionViews];
        [regularConstraints addObjectsFromArray:constraints];
        [self.actionsContainerView addConstraints:constraints];
        
        constraints = [NSLayoutConstraint constraintsWithVisualFormat:[NSString stringWithFormat:@"V:|-15-[%@(==40)]", bx] options:NSLayoutFormatDirectionLeadingToTrailing metrics:nil views:actionViews];
        [compactConstraints addObjectsFromArray:constraints];
        [self.actionsContainerView addConstraints:constraints];
        
        if (i == 0)
        {
            constraints = [NSLayoutConstraint constraintsWithVisualFormat:[NSString stringWithFormat:@"H:|-55-[%@(==77)]", bx] options:NSLayoutFormatDirectionLeadingToTrailing metrics:nil views:actionViews];
            [regularConstraints addObjectsFromArray:constraints];
            [self.actionsContainerView addConstraints:constraints];
            
            constraints = [NSLayoutConstraint constraintsWithVisualFormat:[NSString stringWithFormat:@"H:|-21-[%@(==44)]", bx] options:NSLayoutFormatDirectionLeadingToTrailing metrics:nil views:actionViews];
            [compactConstraints addObjectsFromArray:constraints];
            [self.actionsContainerView addConstraints:constraints];
        }
        else
        {
            NSString *bw = [NSString stringWithFormat:@"b%d", i-1];
            
            constraints = [NSLayoutConstraint constraintsWithVisualFormat:[NSString stringWithFormat:@"H:[%@]-33-[%@(==77)]", bw, bx] options:NSLayoutFormatDirectionLeadingToTrailing metrics:nil views:actionViews];
            [regularConstraints addObjectsFromArray:constraints];
            [self.actionsContainerView addConstraints:constraints];
            
            constraints = [NSLayoutConstraint constraintsWithVisualFormat:[NSString stringWithFormat:@"H:[%@]-15-[%@(==44)]", bw, bx] options:NSLayoutFormatDirectionLeadingToTrailing metrics:nil views:actionViews];
            [compactConstraints addObjectsFromArray:constraints];
            [self.actionsContainerView addConstraints:constraints];
        }
    }
    
    constraints = [NSLayoutConstraint constraintsWithVisualFormat:@"|-55-[_userImageView(==77)]-33-[_statusLabel]-66-|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:nil views:views];
    [regularConstraints addObjectsFromArray:constraints];
    [self.contentContainerView addConstraints:constraints];
    
    constraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-33-[_userNameLabel(==25)]-6-[_statusLabel]-33-|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:nil views:views];
    [regularConstraints addObjectsFromArray:constraints];
    [self.contentContainerView addConstraints:constraints];
    
    constraints = [NSLayoutConstraint constraintsWithVisualFormat:@"|-21-[_userImageView(==40)]-15-[_statusLabel]-30-|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:nil views:views];
    [compactConstraints addObjectsFromArray:constraints];
    [self.contentContainerView addConstraints:constraints];
    
    constraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-15-[_userNameLabel(==18)]-6-[_statusLabel]-15-|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:nil views:views];
    [compactConstraints addObjectsFromArray:constraints];
    [self.contentContainerView addConstraints:constraints];
    
    [self.contentContainerView addConstraint:[NSLayoutConstraint constraintWithItem:_userNameLabel attribute:NSLayoutAttributeLeftMargin relatedBy:NSLayoutRelationEqual toItem:_statusLabel attribute:NSLayoutAttributeLeftMargin multiplier:1.f constant:.0f]];
    [self.contentContainerView addConstraint:[NSLayoutConstraint constraintWithItem:_userNameLabel attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:_statusLabel attribute:NSLayoutAttributeWidth multiplier:1.f constant:.0f]];
    [self.contentContainerView addConstraint:[NSLayoutConstraint constraintWithItem:_userImageView attribute:NSLayoutAttributeTopMargin relatedBy:NSLayoutRelationEqual toItem:_userNameLabel attribute:NSLayoutAttributeTopMargin multiplier:1.f constant:0.f]];
    [self.contentContainerView addConstraint:[NSLayoutConstraint constraintWithItem:_userImageView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:_userImageView attribute:NSLayoutAttributeWidth multiplier:1.f constant:0.f]];

    NSMutableArray *defaultContentContainerConstraints = [[NSMutableArray alloc] init];
    NSMutableArray *actionsContentContainerConstraints = [[NSMutableArray alloc] init];
    
    constraint = [NSLayoutConstraint constraintWithItem:self.contentContainerView attribute:NSLayoutAttributeLeftMargin relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeLeftMargin multiplier:1.f constant:.0f];
    [defaultContentContainerConstraints addObject:constraint];
    [self.contentView addConstraint:constraint];
    
    constraint = [NSLayoutConstraint constraintWithItem:self.contentContainerView attribute:NSLayoutAttributeRightMargin relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeRightMargin multiplier:1.f constant:.0f];
    [defaultContentContainerConstraints addObject:constraint];
    [self.contentView addConstraint:constraint];

    constraint = [NSLayoutConstraint constraintWithItem:self.contentContainerView attribute:NSLayoutAttributeLeftMargin relatedBy:NSLayoutRelationEqual toItem:self.actionsContainerView attribute:NSLayoutAttributeRight multiplier:1.f constant:.0f];
    [actionsContentContainerConstraints addObject:constraint];
    [self.contentView addConstraint:constraint];
    
    [NSLayoutConstraint deactivateConstraints:actionsContentContainerConstraints];
    
    self.defaultContentContainerConstraints = defaultContentContainerConstraints;
    self.actionsContentContainerConstraints = actionsContentContainerConstraints;
    
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.contentContainerView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeWidth multiplier:1.f constant:.0f]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_contentContainerView]|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:nil views:views]];

    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_actionsContainerView]|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:nil views:views]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_actionsContainerView]" options:NSLayoutFormatDirectionLeadingToTrailing metrics:nil views:views]];
    
    constraint = [NSLayoutConstraint constraintWithItem:self.actionsContainerView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.f constant:603.f];
    [regularConstraints addObject:constraint];
    [self.contentView addConstraint:constraint];
    
    constraint = [NSLayoutConstraint constraintWithItem:self.actionsContainerView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.f constant:272.f];
    [compactConstraints addObject:constraint];
    [self.contentView addConstraint:constraint];
    
    self.regularConstraints = regularConstraints;
    self.compactConstraints = compactConstraints;
    
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
    
    [self showActions:NO animated:NO];
    
    for (UIButton *button in self.actionButtons)
        button.selected = NO;
    
    [[TPKTwitterService sharedService] cancelDownloadTaskForURL:self.tweet.sender.profileImageURL];
}

@end
