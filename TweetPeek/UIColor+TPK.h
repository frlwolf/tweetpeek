//
//  UIColor+TPK.h
//  TweetPeek
//
//  Created by Felipe Lobo on 9/22/15.
//  Copyright © 2015 Felipe Lobo. All rights reserved.
//

#import <UIKit/UIKit.h>

#define UIColorWithRGB(R,G,B)      [UIColor colorWithRed:R/255.f green:G/255.f blue:B/255.f alpha:1.f]

@interface UIColor (TPK)

+ (UIColor *)tpk_backgroundColor;

@end
