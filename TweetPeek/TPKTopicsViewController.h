//
//  TPKTopicsViewController.h
//  TweetPeek
//
//  Created by Felipe Lobo on 9/27/15.
//  Copyright © 2015 Felipe Lobo. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TPKTopicsViewController;
@protocol TPKTopicsViewControllerDelegate <NSObject>

- (void)topicsViewController:(TPKTopicsViewController *)topicsViewController didSelectTopic:(NSString *)topic;

@end

@interface TPKTopicsViewController : UIViewController

@property (nonatomic, weak) id<TPKTopicsViewControllerDelegate> delegate;
@property (nonatomic, strong) NSArray *topics;

@end
