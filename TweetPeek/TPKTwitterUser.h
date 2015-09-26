//
//  TPKTwitterUser.h
//  TweetPeek
//
//  Created by Felipe Lobo on 24/09/15.
//  Copyright (c) 2015 Felipe Lobo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIImage.h>

@interface TPKTwitterUser : NSObject

@property (nonatomic, strong) NSString *id;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *screenName;
@property (nonatomic, strong) UIImage *profileImage;
@property (nonatomic, strong) NSURL *profileImageURL;

+ (instancetype)userWithSerializedUser:(NSDictionary *)dictionary;

@end
