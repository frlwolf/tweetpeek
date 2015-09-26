//
//  TPKResultsViewController.h
//  TweetPeek
//
//  Created by Felipe Lobo on 9/22/15.
//  Copyright © 2015 Felipe Lobo. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TPKSearchBar;
@interface TPKResultsViewController : UIViewController

@property (nonatomic, strong) NSArray *tweets;
@property (nonatomic, weak) TPKSearchBar *searchBar;

@end
