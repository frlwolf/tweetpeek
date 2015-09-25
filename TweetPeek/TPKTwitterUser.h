//
//  TPKTwitterUser.h
//  TweetPeek
//
//  Created by Felipe Lobo on 24/09/15.
//  Copyright (c) 2015 Felipe Lobo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TPKTwitterUser : NSObject

+ (instancetype)userWithSerializedUser:(NSDictionary *)dictionary;

@end
