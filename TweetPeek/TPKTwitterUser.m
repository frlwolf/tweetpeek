//
//  TPKTwitterUser.m
//  TweetPeek
//
//  Created by Felipe Lobo on 24/09/15.
//  Copyright (c) 2015 Felipe Lobo. All rights reserved.
//

#import "TPKTwitterUser.h"
#import <UIKit/UIKit.h>

@interface TPKTwitterUser ()

@end

@implementation TPKTwitterUser

+ (instancetype)userWithSerializedUser:(NSDictionary *)dictionary
{
	TPKTwitterUser *user = [[self alloc] init];
    user.id = dictionary[@"id_str"];
    user.name = dictionary[@"name"];
    user.screenName = dictionary[@"screen_name"];
    user.profileImageURL = [NSURL URLWithString:[dictionary[@"profile_image_url"] stringByReplacingOccurrencesOfString:@"_normal" withString:@""]];
	
	return user;
}

@end
