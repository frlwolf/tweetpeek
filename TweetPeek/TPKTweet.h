//
//  TPKTweet.h
//  TweetPeek
//
//  Created by Felipe Lobo on 24/09/15.
//  Copyright (c) 2015 Felipe Lobo. All rights reserved.
//

#import <Foundation/Foundation.h>

@class TPKTwitterUser;
@interface TPKTweet : NSObject

@property (nonatomic, strong) NSString *id;
@property (nonatomic, strong) NSString *text;
@property (nonatomic, strong) NSDate *date;
@property (nonatomic, strong) NSArray *URLs;
@property (nonatomic, strong) NSArray *hashtags;
@property (nonatomic, strong) NSArray *mentions;
@property (nonatomic, strong) NSURL *media;
@property (nonatomic, strong) TPKTwitterUser *sender;

+ (instancetype)tweetWithSerializedStatus:(NSDictionary *)dictionary;

@end
