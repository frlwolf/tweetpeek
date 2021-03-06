//
//  TPKRootViewController.m
//  TweetPeek
//
//  Created by Felipe Lobo on 9/22/15.
//  Copyright © 2015 Felipe Lobo. All rights reserved.
//

#import "TPKRootViewController.h"
#import "NSUserDefaults+TPK.h"
#import "TPKResultsViewController.h"
#import "TPKSearchBar.h"
#import "TPKSearchViewController.h"
#import "TPKTwitterService.h"
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
        
        [[NSUserDefaults standardUserDefaults] tpk_addRecentQuery:text];
        
        void(^searchBlock)() = ^{
            [[TPKTwitterService sharedService] requestTweetsWithQuery:text success:^(NSArray *tweets) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    self.resultsViewController.tweets = tweets;
                });
            } failure:^(NSString *description, NSError *error) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"Something went wrong", nil) message:description preferredStyle:UIAlertControllerStyleAlert];
                    [alertController addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"Ok", nil) style:UIAlertActionStyleDefault handler:nil]];
                    
                    [self presentViewController:alertController animated:YES completion:nil];
                });
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
        
        [self setNeedsStatusBarAppearanceUpdate];
        
    } completion:^(BOOL finished) {
        completion();
    }];
}

- (UIViewController *)childViewControllerForStatusBarStyle
{
    return self.topViewController;
}

@end
