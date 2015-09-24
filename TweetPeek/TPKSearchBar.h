//
//  TPKSearchBar.h
//  TweetPeek
//
//  Created by Felipe Lobo on 9/22/15.
//  Copyright © 2015 Felipe Lobo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TPKSearchBar : UIControl

@property (nonatomic, copy) void(^didBeginEditingBlock)();
@property (nonatomic, copy) void(^editingDidChangedBlock)(NSString *);

@end
