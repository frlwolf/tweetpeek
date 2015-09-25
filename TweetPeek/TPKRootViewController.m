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

@end

@implementation TPKRootViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];

	TPKTwitterService *twitterService = [[TPKTwitterService alloc] init];
	[twitterService requestTweetsWithQuery:@"brasil" success:^(NSArray *tweets) {
		//
	} failure:^(NSString *description, NSError *error) {
		//
	}];
    
    TPKSearchBar *searchBar = [[TPKSearchBar alloc] init];
    searchBar.backgroundColor = [UIColor whiteColor];
    searchBar.translatesAutoresizingMaskIntoConstraints = NO;
    searchBar.didBeginEditingBlock = ^(){
		// TO-DO
    };
	searchBar.editingDidChangedBlock = ^(NSString *text){
		// TO-DO
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
}

- (void)showResultsController
{
    TPKResultsViewController *resultsViewController = [[TPKResultsViewController alloc] init];
    resultsViewController.view.frame = self.view.bounds;
    resultsViewController.view.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    resultsViewController.view.alpha = .0f;
    
    [self addChildViewController:resultsViewController];
    
    self.resultsViewController = resultsViewController;
    
    [self transitionFromViewController:self.searchViewController toViewController:resultsViewController duration:.4f options:UIViewAnimationOptionAllowAnimatedContent | UIViewAnimationOptionCurveEaseOut animations:^{
        
        resultsViewController.view.alpha = 1.f;
        resultsViewController.searchBar = self.searchBar;
        
        self.searchViewController.view.alpha = .0f;
        
    } completion:^(BOOL finished) {
        
        resultsViewController.searchBar = self.searchBar;
        
    }];
}

@end
