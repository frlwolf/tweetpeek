//
//  TPKSearchViewController.m
//  TweetPeek
//
//  Created by Felipe Lobo on 22/09/15.
//  Copyright (c) 2015 Felipe Lobo. All rights reserved.
//

#import "TPKSearchViewController.h"
#import "TPKSearchBar.h"
#import "UIColor+TPK.h"

@interface TPKSearchViewController ()

@property (nonatomic, strong) UIView *topContainer;
@property (nonatomic, strong) UIView *centerContainer;

@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UIView *extraContainer;

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
    imageView.backgroundColor = self.view.backgroundColor;
    imageView.image = [UIImage imageNamed:@"Twitter_logo_blue.png"];
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    imageView.translatesAutoresizingMaskIntoConstraints = NO;
    
    self.imageView = imageView;
    
    [topContainer addSubview:imageView];
    
    UIView *extraContainer = [[UIView alloc] init];
    extraContainer.backgroundColor = self.view.backgroundColor;
    extraContainer.translatesAutoresizingMaskIntoConstraints = NO;
    
    self.extraContainer = extraContainer;
    
    [topContainer addSubview:extraContainer];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self validateConstraints];
}

- (void)willTransitionToTraitCollection:(UITraitCollection *)newCollection withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator
{
    [self validateConstraintsForTraitCollection:newCollection];
}

#pragma mark - Layout

- (void)createConstraints
{
    NSDictionary *views = NSDictionaryOfVariableBindings(_imageView, _extraContainer, _searchBar, _topContainer, _centerContainer);
    
    [self.topContainer addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-[_imageView]-[_extraContainer]-|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:nil views:views]];
    [self.topContainer addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[_extraContainer]-|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:nil views:views]];
    [self.topContainer addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[_imageView]-|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:nil views:views]];
    
    NSMutableArray *compactConstraints = [[NSMutableArray alloc] init];
    NSMutableArray *regularConstraints = [[NSMutableArray alloc] init];
    
    NSLayoutConstraint *constraint;
    
    constraint = [NSLayoutConstraint constraintWithItem:_imageView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.f constant:88.f];
    [compactConstraints addObject:constraint];
    [self.topContainer addConstraint:constraint];
    
    constraint = [NSLayoutConstraint constraintWithItem:_searchBar attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.f constant:60.f];
    [compactConstraints addObject:constraint];
    [self.centerContainer addConstraint:constraint];
    
    constraint = [NSLayoutConstraint constraintWithItem:_imageView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.f constant:135.f];
    [regularConstraints addObject:constraint];
    [self.topContainer addConstraint:constraint];
    
    constraint = [NSLayoutConstraint constraintWithItem:_searchBar attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.f constant:110.f];
    [regularConstraints addObject:constraint];
    [self.centerContainer addConstraint:constraint];
    
    self.regularConstraints = [NSArray arrayWithArray:regularConstraints];
    self.compactConstraints = [NSArray arrayWithArray:compactConstraints];
    
    [self.centerContainer addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-[_topContainer]" options:NSLayoutFormatDirectionLeadingToTrailing metrics:nil views:views]];
    [self.centerContainer addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[_searchBar]-|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:nil views:views]];
    [self.centerContainer addConstraint:[NSLayoutConstraint constraintWithItem:_searchBar attribute:NSLayoutAttributeTopMargin relatedBy:NSLayoutRelationEqual toItem:_topContainer attribute:NSLayoutAttributeBottom multiplier:1.f constant:20.f]];
    [self.centerContainer addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[_topContainer]-|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:nil views:views]];
    [self.centerContainer addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_searchBar]|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:nil views:views]];
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_centerContainer]|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:nil views:views]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_centerContainer attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeHeight multiplier:.6f constant:0.f]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0@900-[_centerContainer]-0@900-|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:nil views:views]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_centerContainer attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterY multiplier:1.f constant:0.f]];
    
    [self validateConstraints];
}

- (void)validateConstraints
{
    [self validateConstraintsForTraitCollection:self.traitCollection];
}

- (void)validateConstraintsForTraitCollection:(UITraitCollection *)traitCollection
{
    if (traitCollection.horizontalSizeClass == UIUserInterfaceSizeClassCompact || traitCollection.verticalSizeClass == UIUserInterfaceSizeClassCompact)
    {
        [NSLayoutConstraint activateConstraints:self.compactConstraints];
        [NSLayoutConstraint deactivateConstraints:self.regularConstraints];
    }
    else
    {
        [NSLayoutConstraint activateConstraints:self.regularConstraints];
        [NSLayoutConstraint deactivateConstraints:self.compactConstraints];
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

@end
