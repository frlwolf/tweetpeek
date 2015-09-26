//
//  TPKSearchBar.h
//  TweetPeek
//
//  Created by Felipe Lobo on 9/22/15.
//  Copyright © 2015 Felipe Lobo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TPKSearchBar : UIControl

@property (nonatomic, strong) void(^requestToSearchBlock)(NSString *);

- (void)transitToBlueStyle:(BOOL)animated;

@end
