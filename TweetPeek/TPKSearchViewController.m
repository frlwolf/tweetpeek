//
//  TPKSearchViewController.m
//  TweetPeek
//
//  Created by Felipe Lobo on 22/09/15.
//  Copyright (c) 2015 Felipe Lobo. All rights reserved.
//

#import "TPKSearchViewController.h"
#import "NSUserDefaults+TPK.h"
#import "TPKSearchBar.h"
#import "TPKTopicsViewController.h"
#import "TPKTwitterService.h"
#import "UIColor+TPK.h"

@interface TPKSearchViewController () <TPKTopicsViewControllerDelegate>

@property (nonatomic, strong) TPKTopicsViewController *lastQueriesController;
@property (nonatomic, strong) TPKTopicsViewController *trendingController;

@property (nonatomic, strong) UIView *centerContainer;
@property (nonatomic, strong) UIView *topContainer;
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UIView *extraContainer;

@property (nonatomic, strong) NSLayoutConstraint *topicsBottomConstraint;
@property (nonatomic, strong) NSLayoutConstraint *keyboardSearchBarBottomConstraint;

@property (nonatomic, strong) NSArray *topicsBorderDistanceConstraints;
@property (nonatomic, strong) NSArray *regularConstraints;
@property (nonatomic, strong) NSArray *compactConstraints;

@end

@implementation TPKSearchViewController

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor tpk_backgroundColor];
    
    UIView *centerContainer = [[UIView alloc] init];
    centerContainer.backgroundColor = [UIColor clearColor];
    centerContainer.translatesAutoresizingMaskIntoConstraints = NO;
    
    [self.view addSubview:centerContainer];
    
    self.centerContainer = centerContainer;
    
    UIView *topContainer = [[UIView alloc] init];
    topContainer.backgroundColor = [UIColor clearColor];
    topContainer.translatesAutoresizingMaskIntoConstraints = NO;
    
    [centerContainer addSubview:topContainer];
    
    self.topContainer = topContainer;
    
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.backgroundColor = [UIColor clearColor];
    imageView.image = [UIImage imageNamed:@"Twitter_logo_blue.png"];
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    imageView.translatesAutoresizingMaskIntoConstraints = NO;
    
    [topContainer addSubview:imageView];
    
    self.imageView = imageView;
    
    UIView *extraContainer = [[UIView alloc] init];
    extraContainer.backgroundColor = self.view.backgroundColor;
    extraContainer.translatesAutoresizingMaskIntoConstraints = NO;
    
    TPKTopicsViewController *lastQueriesController = [[TPKTopicsViewController alloc] init];
    lastQueriesController.view.translatesAutoresizingMaskIntoConstraints = NO;
    lastQueriesController.topics = [[NSUserDefaults standardUserDefaults] tpk_recentQueries];
    lastQueriesController.title = NSLocalizedString(@"Recent searches", nil);
    lastQueriesController.delegate = self;
    
    [extraContainer addSubview:lastQueriesController.view];
    [self addChildViewController:lastQueriesController];
    
    self.lastQueriesController = lastQueriesController;
    
    TPKTopicsViewController *trendingController = [[TPKTopicsViewController alloc] init];
    trendingController.view.translatesAutoresizingMaskIntoConstraints = NO;
    trendingController.title = NSLocalizedString(@"Trending now", nil);
    trendingController.delegate = self;
    
    [[TPKTwitterService sharedService] requestTrendingWithSuccess:^(NSArray *trends) {
        dispatch_async(dispatch_get_main_queue(), ^{
            trendingController.topics = trends;
        });
    } failure:^(NSString *description, NSError *error) {
        //
    }];
    
    [extraContainer addSubview:trendingController.view];
    [self addChildViewController:trendingController];
    
    self.trendingController = trendingController;
    
    [topContainer addSubview:extraContainer];
    [topContainer sendSubviewToBack:extraContainer];
    
    self.extraContainer = extraContainer;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShowNotification:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHideNotification:) name:UIKeyboardWillHideNotification object:nil];
    
    [self validateConstraints];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator
{
    if (self.view.superview)
        [self validateConstraintsForSize:size];
}

- (void)willTransitionToTraitCollection:(UITraitCollection *)newCollection withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator
{
    if (self.view.superview)
        [self validateConstraintsForTraitCollection:newCollection];
}

#pragma mark - Layout

- (void)createConstraints
{
    NSDictionary *views = NSDictionaryOfVariableBindings(_imageView, _extraContainer, _searchBar, _topContainer, _centerContainer);
    
    [self.topContainer addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-[_imageView]" options:NSLayoutFormatDirectionLeadingToTrailing metrics:nil views:views]];
    [self.topContainer addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_extraContainer]|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:nil views:views]];
    [self.topContainer addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_imageView]|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:nil views:views]];
    
    NSMutableArray *compactConstraints = [[NSMutableArray alloc] init];
    NSMutableArray *regularConstraints = [[NSMutableArray alloc] init];
    
    NSLayoutConstraint *constraint;
    
    constraint = [NSLayoutConstraint constraintWithItem:_extraContainer attribute:NSLayoutAttributeBottomMargin relatedBy:NSLayoutRelationEqual toItem:_topContainer attribute:NSLayoutAttributeBottomMargin multiplier:1.f constant:.0f];
    [self.topContainer addConstraint:constraint];
    
    self.topicsBottomConstraint = constraint;
    
    constraint = [NSLayoutConstraint constraintWithItem:_extraContainer attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.f constant:244.f];
    [regularConstraints addObject:constraint];
    [self.topContainer addConstraint:constraint];
    
    constraint = [NSLayoutConstraint constraintWithItem:_imageView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.f constant:135.f];
    [regularConstraints addObject:constraint];
    [self.topContainer addConstraint:constraint];
    
    constraint = [NSLayoutConstraint constraintWithItem:_searchBar attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.f constant:110.f];
    [regularConstraints addObject:constraint];
    [self.centerContainer addConstraint:constraint];
    
    constraint = [NSLayoutConstraint constraintWithItem:_extraContainer attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.f constant:178.f];
    [compactConstraints addObject:constraint];
    [self.topContainer addConstraint:constraint];
    
    constraint = [NSLayoutConstraint constraintWithItem:_imageView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.f constant:88.f];
    [compactConstraints addObject:constraint];
    [self.topContainer addConstraint:constraint];
    
    constraint = [NSLayoutConstraint constraintWithItem:_searchBar attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.f constant:60.f];
    [compactConstraints addObject:constraint];
    [self.centerContainer addConstraint:constraint];
    
    NSArray *constraints;
    
    constraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:[_imageView]-(>=64)-[_searchBar]" options:NSLayoutFormatDirectionLeadingToTrailing metrics:nil views:views];
    [regularConstraints addObjectsFromArray:constraints];
    [self.centerContainer addConstraints:constraints];
    
    constraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:[_imageView]-(>=30)-[_searchBar]" options:NSLayoutFormatDirectionLeadingToTrailing metrics:nil views:views];
    [compactConstraints addObjectsFromArray:constraints];
    [self.centerContainer addConstraints:constraints];
    
    [self.centerContainer addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_topContainer]" options:NSLayoutFormatDirectionLeadingToTrailing metrics:nil views:views]];
    [self.centerContainer addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[_searchBar]" options:NSLayoutFormatDirectionLeadingToTrailing metrics:nil views:views]];
    [self.centerContainer addConstraint:[NSLayoutConstraint constraintWithItem:_searchBar attribute:NSLayoutAttributeTopMargin relatedBy:NSLayoutRelationEqual toItem:_topContainer attribute:NSLayoutAttributeBottom multiplier:1.f constant:20.f]];
    
    constraint = [NSLayoutConstraint constraintWithItem:_searchBar attribute:NSLayoutAttributeBottomMargin relatedBy:NSLayoutRelationEqual toItem:self.centerContainer attribute:NSLayoutAttributeBottom multiplier:1.f constant:.0f];
    constraint.priority = 900;
    [self.centerContainer addConstraint:constraint];
    
    [self.centerContainer addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_topContainer]|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:nil views:views]];
    [self.centerContainer addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_searchBar]|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:nil views:views]];
    
    UIView *trendingView = self.trendingController.view, *lastQueriesView = self.lastQueriesController.view;
    NSDictionary *topicsViews = @{ @"lastQueries": lastQueriesView, @"trending": trendingView };
    
    [self.extraContainer addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[trending]|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:nil views:topicsViews]];
    [self.extraContainer addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[lastQueries]|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:nil views:topicsViews]];
    
    constraint = [NSLayoutConstraint constraintWithItem:trendingView attribute:NSLayoutAttributeRightMargin relatedBy:NSLayoutRelationEqual toItem:self.extraContainer attribute:NSLayoutAttributeRightMargin multiplier:1.f constant:-115.f];
    [regularConstraints addObject:constraint];
    [self.extraContainer addConstraint:constraint];
    
    constraint = [NSLayoutConstraint constraintWithItem:lastQueriesView attribute:NSLayoutAttributeLeftMargin relatedBy:NSLayoutRelationEqual toItem:self.extraContainer attribute:NSLayoutAttributeLeftMargin multiplier:1.f constant:115.f];
    [regularConstraints addObject:constraint];
    [self.extraContainer addConstraint:constraint];
    
    constraint = [NSLayoutConstraint constraintWithItem:trendingView attribute:NSLayoutAttributeRightMargin relatedBy:NSLayoutRelationEqual toItem:self.extraContainer attribute:NSLayoutAttributeRightMargin multiplier:1.f constant:-20.f];
    [compactConstraints addObject:constraint];
    [self.extraContainer addConstraint:constraint];
    
    constraint = [NSLayoutConstraint constraintWithItem:lastQueriesView attribute:NSLayoutAttributeLeftMargin relatedBy:NSLayoutRelationEqual toItem:self.extraContainer attribute:NSLayoutAttributeLeftMargin multiplier:1.f constant:20.f];
    [compactConstraints addObject:constraint];
    [self.extraContainer addConstraint:constraint];
    
    NSMutableArray *topicsBorderDistanceConstraints = [[NSMutableArray alloc] init];
    
    constraint = [NSLayoutConstraint constraintWithItem:trendingView attribute:NSLayoutAttributeLeftMargin relatedBy:NSLayoutRelationEqual toItem:self.extraContainer attribute:NSLayoutAttributeCenterX multiplier:1.f constant:.0f];
    [topicsBorderDistanceConstraints addObject:constraint];
    [self.extraContainer addConstraint:constraint];
    
    constraint = [NSLayoutConstraint constraintWithItem:lastQueriesView attribute:NSLayoutAttributeRightMargin relatedBy:NSLayoutRelationEqual toItem:self.extraContainer attribute:NSLayoutAttributeCenterX multiplier:1.f constant:.0f];
    [topicsBorderDistanceConstraints addObject:constraint];
    [self.extraContainer addConstraint:constraint];
    
    constraint = [NSLayoutConstraint constraintWithItem:_centerContainer attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeHeight multiplier:.65f constant:0.f];
    [regularConstraints addObject:constraint];
    [self.view addConstraint:constraint];

    constraint = [NSLayoutConstraint constraintWithItem:_centerContainer attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeHeight multiplier:.8f constant:0.f];
    [compactConstraints addObject:constraint];
    [self.view addConstraint:constraint];
    
    self.regularConstraints = [NSArray arrayWithArray:regularConstraints];
    self.compactConstraints = [NSArray arrayWithArray:compactConstraints];
    self.topicsBorderDistanceConstraints = [NSArray arrayWithArray:topicsBorderDistanceConstraints];
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_centerContainer]|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:nil views:views]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0@750-[_centerContainer]-0@750-|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:nil views:views]];
    
    constraint = [NSLayoutConstraint constraintWithItem:_centerContainer attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterY multiplier:1.f constant:0.f];
    constraint.priority = 900;
    [self.view addConstraint:constraint];
    
    constraint = [NSLayoutConstraint constraintWithItem:_searchBar attribute:NSLayoutAttributeBottomMargin relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeBottomMargin multiplier:1.f constant:0.f];
    [self.view addConstraint:constraint];
    
    self.keyboardSearchBarBottomConstraint = constraint;
    self.keyboardSearchBarBottomConstraint.active = NO;
    
    [self validateConstraints];
}

- (void)validateConstraints
{
    [self validateConstraintsForTraitCollection:self.traitCollection];
    [self validateConstraintsForSize:self.view.frame.size];
}

- (void)validateConstraintsForTraitCollection:(UITraitCollection *)traitCollection
{
    BOOL isCompact = traitCollection.horizontalSizeClass == UIUserInterfaceSizeClassCompact || traitCollection.verticalSizeClass == UIUserInterfaceSizeClassCompact;
    
    if (isCompact)
    {
        CGFloat constant = traitCollection.verticalSizeClass == UIUserInterfaceSizeClassCompact ? -10.f : -22.f;
        self.topicsBottomConstraint.constant = constant;
        
        [NSLayoutConstraint activateConstraints:self.compactConstraints];
        [NSLayoutConstraint deactivateConstraints:self.regularConstraints];
    }
    else
    {
        self.topicsBottomConstraint.constant = -55.f;
        
        [NSLayoutConstraint activateConstraints:self.regularConstraints];
        [NSLayoutConstraint deactivateConstraints:self.compactConstraints];
    }
    
    [self.view layoutIfNeeded];
}

- (void)validateConstraintsForSize:(CGSize)size
{
    BOOL isCompact = self.traitCollection.horizontalSizeClass == UIUserInterfaceSizeClassCompact || self.traitCollection.verticalSizeClass == UIUserInterfaceSizeClassCompact;
    
    if (size.width > size.height)
    {
        CGFloat aThird = floorf(size.width / 3.f);
        [self.topicsBorderDistanceConstraints[0] setConstant:floorf(aThird / 2.f)];
        [self.topicsBorderDistanceConstraints[1] setConstant:floorf(aThird / -2.f)];
    }
    else
    {
        if (isCompact)
        {
            [self.topicsBorderDistanceConstraints[0] setConstant:16.f];
            [self.topicsBorderDistanceConstraints[1] setConstant:-16.f];
        }
        else
        {
            [self.topicsBorderDistanceConstraints[0] setConstant:37.f];
            [self.topicsBorderDistanceConstraints[1] setConstant:-37.f];
        }
    }
    
    [self.view layoutIfNeeded];
}

#pragma mark - Properties
#pragma mark Set

- (void)setSearchBar:(TPKSearchBar *)searchBar
{
    _searchBar = searchBar;
    
    if (self.view)
    {
        [self.centerContainer addSubview:searchBar];
        [self createConstraints];
    }
}

#pragma mark - Keyboar presentation handling

- (void)keyboardWillShowNotification:(NSNotification *)notification
{
    NSDictionary *userInfo = [notification userInfo];
    CGSize keyboardSize = [userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    
    CGFloat difference = floorf(self.view.frame.size.height / 10.f);
    
    self.keyboardSearchBarBottomConstraint.constant = -(keyboardSize.height + difference);
    self.keyboardSearchBarBottomConstraint.active = YES;
    
    [UIView animateWithDuration:[userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue] animations:^{
        self.extraContainer.alpha = .0f;
        [self.view layoutIfNeeded];
    }];
}

- (void)keyboardWillHideNotification:(NSNotification *)notification
{
    self.keyboardSearchBarBottomConstraint.active = NO;
    
    [UIView animateWithDuration:[[notification userInfo][UIKeyboardAnimationDurationUserInfoKey] doubleValue] animations:^{
        self.extraContainer.alpha = 1.f;
        [self.view layoutIfNeeded];
    }];
}

#pragma mark - Topics controller delegate

- (void)topicsViewController:(TPKTopicsViewController *)topicsViewController didSelectTopic:(NSString *)topic
{
    self.searchBar.requestToSearchBlock(topic);
}

@end
