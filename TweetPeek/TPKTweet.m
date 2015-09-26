//
//  TPKTweet.m
//  TweetPeek
//
//  Created by Felipe Lobo on 24/09/15.
//  Copyright (c) 2015 Felipe Lobo. All rights reserved.
//

#import "TPKTweet.h"
#import "TPKTwitterUser.h"

@implementation TPKTweet

+ (instancetype)tweetWithSerializedStatus:(NSDictionary *)dictionary;
{
	TPKTweet *tweet = [[self alloc] init];
    tweet.id = dictionary[@"id_str"];
    tweet.text = dictionary[@"text"];
    tweet.sender = [TPKTwitterUser userWithSerializedUser:dictionary[@"user"]];

	return tweet;
}

@end
