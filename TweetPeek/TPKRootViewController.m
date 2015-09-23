//
//  TPKRootViewController.m
//  TweetPeek
//
//  Created by Felipe Lobo on 9/22/15.
//  Copyright © 2015 Felipe Lobo. All rights reserved.
//

#import "TPKRootViewController.h"
#import "TPKSearchViewController.h"
#import "UIColor+TPK.h"

@implementation TPKRootViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor tpk_backgroundColor];
    
    TPKSearchViewController *searchViewController = [[TPKSearchViewController alloc] init];
    searchViewController.view.frame = self.view.bounds;
    searchViewController.view.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    
    [self.view addSubview:searchViewController.view];
    
    [self addChildViewController:searchViewController];
}

@end
