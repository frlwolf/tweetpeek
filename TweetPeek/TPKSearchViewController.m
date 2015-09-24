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

@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UIView *extraContainer;

@end

@implementation TPKSearchViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor tpk_backgroundColor];
    
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.backgroundColor = self.view.backgroundColor;
    imageView.image = [UIImage imageNamed:@"Twitter_logo_blue.png"];
    imageView.contentMode = UIViewContentModeCenter; 
    imageView.translatesAutoresizingMaskIntoConstraints = NO;
    
    self.imageView = imageView;
    
    [self.view addSubview:imageView];
    
    UIView *extraContainer = [[UIView alloc] init];
    extraContainer.backgroundColor = self.view.backgroundColor;
    extraContainer.translatesAutoresizingMaskIntoConstraints = NO;
    
    self.extraContainer = extraContainer;
    
    [self.view addSubview:extraContainer];
}

- (void)setSearchBar:(TPKSearchBar *)searchBar
{
    _searchBar = searchBar;
    
    [self.view addSubview:searchBar];
    
    NSDictionary *views = NSDictionaryOfVariableBindings(_imageView, _extraContainer, searchBar);
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-165-[_imageView(==135)]-118-[_extraContainer(==208)]-90-[searchBar(==110)]-198-|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:nil views:views]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-115-[_imageView]-115-|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:nil views:views]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-115-[_extraContainer]-115-|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:nil views:views]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[searchBar]-0-|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:nil views:views]];
}

@end
