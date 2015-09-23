//
//  TPKSearchBar.h
//  TweetPeek
//
//  Created by Felipe Lobo on 9/22/15.
//  Copyright © 2015 Felipe Lobo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TPKSearchBar : UIView

@property (nonatomic, strong) UIImageView *magnifierView;
@property (nonatomic, strong) UITextField *textField;
@property (nonatomic, copy) void(^didBeginEditingBlock)();

@end
