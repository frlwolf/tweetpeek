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

static NSString *TweetCellIdentifier = @"TweetCellIdentifier";

@interface TPKResultsViewController () <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) UICollectionViewFlowLayout *collectionLayout;
@property (nonatomic, strong) UICollectionView *collectionView;

@end

@implementation TPKResultsViewController

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
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (void)setSearchBar:(TPKSearchBar *)searchBar
{
    _searchBar = searchBar;
    
    UIView *searchBarContainer = [[UIView alloc] init];
    searchBarContainer.backgroundColor = searchBar.backgroundColor;
    searchBarContainer.translatesAutoresizingMaskIntoConstraints = NO;
    
    [searchBarContainer addSubview:searchBar];
    [self.view addSubview:searchBarContainer];
    
    NSDictionary *views = NSDictionaryOfVariableBindings(searchBar, searchBarContainer, _collectionView);
    
    [searchBarContainer addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|[searchBar]|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:nil views:views]];
    [searchBarContainer addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-20-[searchBar]|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:nil views:views]];
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[searchBarContainer(==108)][_collectionView]|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:nil views:views]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|[searchBarContainer]|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:nil views:views]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|[_collectionView]|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:nil views:views]];
}

- (void)setTweets:(NSArray *)tweets
{
    _tweets = tweets;
    
    [self.collectionView reloadData];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.tweets.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    TPKTweet *tweet = self.tweets[indexPath.row];
    TPKTweetCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:TweetCellIdentifier forIndexPath:indexPath];
    cell.tweet = tweet;
    
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    CGFloat width = collectionView.frame.size.width > collectionView.frame.size.height ? floorf(collectionView.frame.size.width / 2.0f) - 1 : collectionView.frame.size.width;
    
    TPKTweet *tweet = self.tweets[indexPath.row];

    CGSize constraintSize = CGSizeMake(width - 77 - 66 - 55 - 33, CGFLOAT_MAX);

    UILabel *dumb = [[UILabel alloc] init];
    dumb.text = tweet.text;
    dumb.font = [UIFont fontWithName:@"HelveticaNeue" size:22.f];
    dumb.numberOfLines = 0;
    
    CGFloat height = floorf(66 + 25 + 6 + [dumb sizeThatFits:constraintSize].height);
    
    return CGSizeMake(width, height < 156.f ? 156.f : height);
}

@end
