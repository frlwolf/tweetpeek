//
//  TPKTwitterService.m
//  TweetPeek
//
//  Created by Felipe Lobo on 24/09/15.
//  Copyright (c) 2015 Felipe Lobo. All rights reserved.
//

#import "TPKTwitterService.h"
#import "TPKTweet.h"

#define kGetTokenIdentifier				@"kGetTokenIdentifier"

@interface TPKTwitterService () <NSURLSessionDelegate>

@property (nonatomic, strong) NSURLSession *twitterSession;

@property (nonatomic, strong) NSURL *twitterAPIEndPoint;
@property (nonatomic, strong) NSString *encodedAppToken;
@property (nonatomic, strong) NSString *bearerToken;

@end

@implementation TPKTwitterService

+ (instancetype)sharedService
{
	static TPKTwitterService *sharedInstance;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		sharedInstance = [[TPKTwitterService alloc] init];
	});

	return sharedInstance;
}

- (instancetype)init
{
	self = [super init];
	if (self)
	{
		NSURLSessionConfiguration *sessionConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
		sessionConfiguration.timeoutIntervalForRequest = 60.f;

		self.twitterSession = [NSURLSession sessionWithConfiguration:sessionConfiguration delegate:nil delegateQueue:nil];
		self.twitterAPIEndPoint = [NSURL URLWithString:@"https://api.twitter.com"];
		self.encodedAppToken = @"ZW5LT2FLdDE3VXh0TDV5VXlVZWFsSW91eTpHdzdoak1oWHc3ZmJ3YnpVSTZzMXplUXlYTmRxTU5GNTUyTHVYVU83cmhQdWg2WTIycA==";
	}

	return self;
}

- (void)requestBearerTokenSuccess:(void(^)(NSString *))success failure:(void(^)(NSString *, NSError *))failure
{
	NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:@"/oauth2/token?grant_type=client_credentials" relativeToURL:self.twitterAPIEndPoint]];
	[request addValue:[NSString stringWithFormat:@"Basic %@", self.encodedAppToken] forHTTPHeaderField:@"Authorization"];
	[request setHTTPMethod:@"POST"];

	[[self.twitterSession dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
		if (!error)
		{
			NSError *error;
			NSDictionary *JSONObject = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];

			if (!error)
				success(JSONObject[@"access_token"]);
			else
				failure([error localizedDescription], error);
		}
		else
			failure([error localizedDescription], error);
	}] resume];
}

- (void)requestTweetsWithQuery:(NSString *)query success:(void(^)(NSArray *))success failure:(void(^)(NSString *, NSError *))failure
{
	void (^requestBlock)() = ^{
		NSURL *requestURL = [NSURL URLWithString:[NSString stringWithFormat:@"/1.1/search/tweets.json?q=%@", [query stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]] relativeToURL:self.twitterAPIEndPoint];
		NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:requestURL];
		[request addValue:[NSString stringWithFormat:@"Bearer %@", self.bearerToken] forHTTPHeaderField:@"Authorization€"];
		[request setHTTPMethod:@"GET"];

		[[self.twitterSession dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
			if (!error)
			{
				NSError *error;
				NSDictionary *JSONObject = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];

				if (!error)
				{
					NSArray *statuses = JSONObject[@"statuses"];
					NSMutableArray *tweets = [[NSMutableArray alloc] initWithCapacity:statuses.count];
					for (NSDictionary *status in statuses)
					{
						TPKTweet *tweet = [TPKTweet tweetWithSerializedStatus:status];
						[tweets addObject:tweet];
					}
					success([NSArray arrayWithArray:tweets]);
				}
				else
					failure([error localizedDescription], error);
			}
			else
				failure([error localizedDescription], error);
		}] resume];
	};

	if (self.bearerToken)
		requestBlock();
	else
		[self requestBearerTokenSuccess:^(NSString *token) {
			self.bearerToken = token;
			requestBlock();
		} failure:failure];
}

@end
