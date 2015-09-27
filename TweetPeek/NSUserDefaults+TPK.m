//
//  NSUserDefaults+TPK.m
//  TweetPeek
//
//  Created by Felipe Lobo on 9/27/15.
//  Copyright © 2015 Felipe Lobo. All rights reserved.
//

#import "NSUserDefaults+TPK.h"

static NSString *RecentQueriesKey = @"com.frlwolf.RecentQueriesKey";

@implementation NSUserDefaults (TPK)

- (void)tpk_addRecentQuery:(NSString *)query
{
    NSArray *saved = [self tpk_recentQueries];
    NSMutableArray *mutableQueries = saved ? [NSMutableArray arrayWithArray:saved] : [NSMutableArray array];
    
    [mutableQueries insertObject:query atIndex:0];
    
    [[NSUserDefaults standardUserDefaults] setObject:[mutableQueries subarrayWithRange:(NSRange){0, mutableQueries.count <= 5 ? mutableQueries.count : 5}] forKey:RecentQueriesKey];
}

- (NSArray *)tpk_recentQueries
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:RecentQueriesKey];
}

@end
