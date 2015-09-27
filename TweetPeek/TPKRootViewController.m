//
//  TPKRootViewController.m
//  TweetPeek
//
//  Created by Felipe Lobo on 9/22/15.
//  Copyright © 2015 Felipe Lobo. All rights reserved.
//

#import "TPKRootViewController.h"
#import "TPKSearchViewController.h"
#import "TPKResultsViewController.h"
#import "TPKTwitterService.h"
#import "TPKSearchBar.h"
#import "UIColor+TPK.h"

@interface TPKRootViewController ()

@property (nonatomic, strong) TPKSearchViewController *searchViewController;
@property (nonatomic, strong) TPKResultsViewController *resultsViewController;

@property (nonatomic, weak) UIViewController *topViewController;

@end

@implementation TPKRootViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    TPKSearchBar *searchBar = [[TPKSearchBar alloc] init];
    searchBar.backgroundColor = [UIColor whiteColor];
    searchBar.translatesAutoresizingMaskIntoConstraints = NO;
    searchBar.requestToSearchBlock = ^(NSString *text){
        void(^searchBlock)() = ^{
            [[TPKTwitterService sharedService] requestTweetsWithQuery:text success:^(NSArray *tweets) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    self.resultsViewController.tweets = tweets;
                });
            } failure:^(NSString *description, NSError *error) {
                //
            }];
        };
        
        self.searchBar.title = text;
        
        if (self.resultsViewController == nil)
            [self showResultsController:searchBlock];
        else
            searchBlock();
    };

    self.searchBar = searchBar;
    
    self.view.backgroundColor = [UIColor tpk_backgroundColor];
    
    TPKSearchViewController *searchViewController = [[TPKSearchViewController alloc] init];
    searchViewController.searchBar = searchBar;
    searchViewController.view.frame = self.view.bounds;
    searchViewController.view.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    
    [self addChildViewController:searchViewController];
    
    self.searchViewController = searchViewController;
    
    [self.view addSubview:searchViewController.view];
    
    self.topViewController = searchViewController;
}

- (void)showResultsController:(void(^)())completion
{
    TPKResultsViewController *resultsViewController = [[TPKResultsViewController alloc] init];
    resultsViewController.view.frame = self.view.bounds;
    resultsViewController.view.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    resultsViewController.view.alpha = .0f;
    resultsViewController.searchBar = self.searchBar;
    
    [self addChildViewController:resultsViewController];
    
    self.resultsViewController = resultsViewController;
    
    self.topViewController = resultsViewController;
    
    [self transitionFromViewController:self.searchViewController toViewController:resultsViewController duration:.4f options:UIViewAnimationOptionAllowAnimatedContent | UIViewAnimationOptionCurveEaseOut animations:^{
        
        [self.searchBar transitToBlueStyle];
        
        resultsViewController.view.alpha = 1.f;
        
        self.searchViewController.view.alpha = .0f;
        
    } completion:^(BOOL finished) {
        completion();
    }];
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return self.topViewController.preferredStatusBarStyle;
}

@end
