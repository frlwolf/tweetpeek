//
//  TPKResultsViewController.m
//  TweetPeek
//
//  Created by Felipe Lobo on 9/22/15.
//  Copyright © 2015 Felipe Lobo. All rights reserved.
//

#import "TPKResultsViewController.h"
#import "TPKSearchBar.h"
#import "TPKTweet.h"
#import "TPKTweetCell.h"
#import "TPKTwitterUser.h"
#import "UIColor+TPK.h"
#import <Social/Social.h>

static NSString *TweetCellIdentifier = @"TweetCellIdentifier";

@interface TPKResultsViewController () <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) UIView *searchBarContainer;
@property (nonatomic, strong) UICollectionViewFlowLayout *collectionLayout;
@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, strong) NSLayoutConstraint *topMarginConstraint;

@property (nonatomic, strong) NSLayoutConstraint *searchBarHeightConstraintVerticalCompact;
@property (nonatomic, strong) NSLayoutConstraint *searchBarHeightConstraintHorizontalCompact;
@property (nonatomic, strong) NSLayoutConstraint *searchBarHeightConstraintRegular;

@end

@implementation TPKResultsViewController

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UICollectionViewFlowLayout *collectionLayout = [[UICollectionViewFlowLayout alloc] init];
    collectionLayout.minimumInteritemSpacing = 1.f;
    collectionLayout.minimumLineSpacing = 1.f;

    self.collectionLayout = collectionLayout;
    
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:collectionLayout];
    collectionView.backgroundColor = [UIColor colorWithWhite:.85f alpha:1.f];
    collectionView.dataSource = self;
    collectionView.delegate = self;
    collectionView.translatesAutoresizingMaskIntoConstraints = NO;
    [collectionView registerClass:[TPKTweetCell class] forCellWithReuseIdentifier:TweetCellIdentifier];
    
    [self.view addSubview:collectionView];
    
    self.collectionView = collectionView;
    
    UIView *searchBarContainer = [[UIView alloc] init];
    searchBarContainer.backgroundColor = [UIColor tpk_blueColor];
    searchBarContainer.translatesAutoresizingMaskIntoConstraints = NO;
    
    [self.view addSubview:searchBarContainer];
    
    self.searchBarContainer = searchBarContainer;
    
    [self createConstraints];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self validateConstraints];
}

- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator
{
    [coordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext>  _Nonnull context) {
        [self.collectionLayout invalidateLayout];
    } completion:nil];
}

- (void)willTransitionToTraitCollection:(UITraitCollection *)newCollection withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator
{
    [self validateConstraintsForTraitCollection:newCollection];
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

#pragma mark - Properties
#pragma mark Set

- (void)setSearchBar:(TPKSearchBar *)searchBar
{
    _searchBar = searchBar;
    
    [_searchBarContainer addSubview:_searchBar];
    
    [_searchBarContainer addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|[searchBar]|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:nil views:NSDictionaryOfVariableBindings(searchBar)]];
    [_searchBarContainer addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[searchBar]|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:nil views:NSDictionaryOfVariableBindings(searchBar)]];
    
    self.topMarginConstraint = [NSLayoutConstraint constraintWithItem:searchBar attribute:NSLayoutAttributeTopMargin relatedBy:NSLayoutRelationEqual toItem:_searchBarContainer attribute:NSLayoutAttributeTopMargin multiplier:1.f constant:.0f];
    
    [_searchBarContainer addConstraint:self.topMarginConstraint];
    
    [self validateConstraints];
}

- (void)setTweets:(NSArray *)tweets
{
    _tweets = tweets;
    
    [self.collectionView reloadData];
}

#pragma mark - Layout

- (void)createConstraints
{
    NSDictionary *views = NSDictionaryOfVariableBindings(_searchBarContainer, _collectionView);
    
    NSLayoutConstraint *constraint;
    
    constraint = [NSLayoutConstraint constraintWithItem:_searchBarContainer attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.f constant:108.f];
    [self.view addConstraint:constraint];
    
    self.searchBarHeightConstraintRegular = constraint;
    
    constraint = [NSLayoutConstraint constraintWithItem:_searchBarContainer attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.f constant:64.f];
    [self.view addConstraint:constraint];
    
    self.searchBarHeightConstraintHorizontalCompact = constraint;
    
    constraint = [NSLayoutConstraint constraintWithItem:_searchBarContainer attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.f constant:44.f];
    [self.view addConstraint:constraint];
    
    self.searchBarHeightConstraintVerticalCompact = constraint;
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_searchBarContainer][_collectionView]|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:nil views:views]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|[_searchBarContainer]|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:nil views:views]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|[_collectionView]|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:nil views:views]];
    
    [self validateConstraints];
}

- (void)validateConstraints
{
    [self validateConstraintsForTraitCollection:self.traitCollection];
}

- (void)validateConstraintsForTraitCollection:(UITraitCollection *)traitCollection
{
    self.topMarginConstraint.constant = 20.f;
    
    if (traitCollection.verticalSizeClass == UIUserInterfaceSizeClassCompact)
    {
        self.searchBarHeightConstraintRegular.active = NO;
        self.searchBarHeightConstraintHorizontalCompact.active = NO;
        self.searchBarHeightConstraintVerticalCompact.active = YES;
        
        self.topMarginConstraint.constant = .0f;
    }
    else if (traitCollection.horizontalSizeClass == UIUserInterfaceSizeClassCompact)
    {
        self.searchBarHeightConstraintRegular.active = NO;
        self.searchBarHeightConstraintHorizontalCompact.active = YES;
        self.searchBarHeightConstraintVerticalCompact.active = NO;
    }
    else
    {
        self.searchBarHeightConstraintRegular.active = YES;
        self.searchBarHeightConstraintHorizontalCompact.active = NO;
        self.searchBarHeightConstraintVerticalCompact.active = NO;
    }
    
    [self.view layoutIfNeeded];
}

#pragma mark - Collection view
#pragma mark Data source

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.tweets.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    TPKTweet *tweet = self.tweets[indexPath.row];
    
    TPKTweetCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:TweetCellIdentifier forIndexPath:indexPath];
    cell.tweet = tweet;
    cell.forwardTweetActionBlock = ^() {
        SLComposeViewController *composeViewController = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
        [composeViewController setInitialText:[NSString stringWithFormat:@"RT %@ %@", [@"@" stringByAppendingString:tweet.sender.screenName], tweet.text]];
        
        [self presentViewController:composeViewController animated:YES completion:nil];
    };
    
    return cell;
}

#pragma mark Flow layout delegate

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    TPKTweet *tweet = self.tweets[indexPath.row];
    CGFloat width = collectionView.frame.size.width, height;
    CGFloat minimumSize, textWidth, fontSize;
    UITraitCollection *traitCollection = self.traitCollection;

    if (traitCollection.horizontalSizeClass == UIUserInterfaceSizeClassCompact || traitCollection.verticalSizeClass == UIUserInterfaceSizeClassCompact)
    {
        textWidth = width - 40 - 30 - 21 - 15;
        height = 30 + 18 + 6;
        minimumSize = 77.f;
        fontSize = 15.f;
    }
    else
    {
        textWidth = width - 77 - 66 - 55 - 33;
        height = 66 + 25 + 6;
        minimumSize = 156.f;
        fontSize = 22.f;
    }
    
    CGSize constraintSize = CGSizeMake(textWidth, CGFLOAT_MAX);

    UILabel *dumb = [[UILabel alloc] init];
    dumb.text = tweet.text;
    dumb.font = [UIFont fontWithName:@"HelveticaNeue" size:fontSize];
    dumb.numberOfLines = 0;

    height = floorf(height + [dumb sizeThatFits:constraintSize].height);
    
    return CGSizeMake(width, height < minimumSize ? minimumSize : height);
}

@end
