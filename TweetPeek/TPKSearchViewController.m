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
    
    [self.view addSubview:imageView];
    
    UIView *extraContainer = [[UIView alloc] init];
    extraContainer.backgroundColor = [UIColor redColor];//self.view.backgroundColor;
    extraContainer.translatesAutoresizingMaskIntoConstraints = NO;
    
    [self.view addSubview:extraContainer];
    
    TPKSearchBar *searchBar = [[TPKSearchBar alloc] init];
    searchBar.backgroundColor = [UIColor whiteColor];
    searchBar.translatesAutoresizingMaskIntoConstraints = NO;
    
    [self.view addSubview:searchBar];
    
    NSDictionary *views = NSDictionaryOfVariableBindings(imageView, extraContainer, searchBar);
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-165-[imageView(==135)]-118-[extraContainer(==208)]-90-[searchBar(==110)]-198-|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:nil views:views]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-115-[imageView]-115-|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:nil views:views]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-115-[extraContainer]-115-|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:nil views:views]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[searchBar]-0-|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:nil views:views]];
}

@end
