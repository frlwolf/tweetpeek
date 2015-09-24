//
//  TPKResultsViewController.m
//  TweetPeek
//
//  Created by Felipe Lobo on 9/22/15.
//  Copyright © 2015 Felipe Lobo. All rights reserved.
//

#import "TPKResultsViewController.h"
#import "TPKSearchBar.h"

@interface TPKResultsViewController ()

@property (nonatomic, strong) UIView *collectionView;

@end

@implementation TPKResultsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIView *collection = [[UIView alloc] init];
    collection.backgroundColor = [UIColor lightGrayColor];
    collection.translatesAutoresizingMaskIntoConstraints = NO;
    
    [self.view addSubview:collection];
    
    self.collectionView = collection;
}

- (void)setSearchBar:(TPKSearchBar *)searchBar
{
    _searchBar = searchBar;
    
    [self.view addSubview:searchBar];
    
    NSDictionary *views = NSDictionaryOfVariableBindings(searchBar, _collectionView);
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[searchBar(==88)][_collectionView]|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:nil views:views]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|[searchBar]|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:nil views:views]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|[_collectionView]|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:nil views:views]];
}

@end
