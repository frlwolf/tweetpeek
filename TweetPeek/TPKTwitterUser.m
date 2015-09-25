//
//  TPKTwitterUser.m
//  TweetPeek
//
//  Created by Felipe Lobo on 24/09/15.
//  Copyright (c) 2015 Felipe Lobo. All rights reserved.
//

#import "TPKTwitterUser.h"

@implementation TPKTwitterUser

+ (instancetype)userWithSerializedUser:(NSDictionary *)dictionary
{
	TPKTwitterUser *user = [[self alloc] init];
	
	return user;
}

@end
