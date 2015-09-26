//
//  TPKTwitterService.h
//  TweetPeek
//
//  Created by Felipe Lobo on 24/09/15.
//  Copyright (c) 2015 Felipe Lobo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface TPKTwitterService : NSObject

+ (instancetype)sharedService;

- (void)requestTweetsWithQuery:(NSString *)query success:(void(^)(NSArray *))success failure:(void(^)(NSString *, NSError *))failure;
- (void)loadImageWithURL:(NSURL *)URL completion:(void(^)(UIImage *))completion;
- (void)cancelDownloadTaskForURL:(NSURL *)URL;

@end
