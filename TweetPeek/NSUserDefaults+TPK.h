//
//  NSUserDefaults+TPK.h
//  TweetPeek
//
//  Created by Felipe Lobo on 9/27/15.
//  Copyright © 2015 Felipe Lobo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSUserDefaults (TPK)

- (void)tpk_addRecentQuery:(NSString *)query;
- (NSArray *)tpk_recentQueries;

@end
