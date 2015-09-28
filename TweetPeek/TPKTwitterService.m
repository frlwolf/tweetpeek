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

@property (nonatomic, strong) NSMutableDictionary *downloadTasks;

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
        
        self.downloadTasks = [[NSMutableDictionary alloc] init];
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

- (void)requestTrendingWithSuccess:(void(^)(NSArray *))success failure:(void(^)(NSString *, NSError *))failure
{
    void (^requestBlock)() = ^{
        NSURL *requestURL = [NSURL URLWithString:@"/1.1/trends/place.json?id=1" relativeToURL:self.twitterAPIEndPoint];
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:requestURL];
        [request addValue:[NSString stringWithFormat:@"Bearer %@", self.bearerToken] forHTTPHeaderField:@"Authorization€"];
        [request setHTTPMethod:@"GET"];
        
        [[self.twitterSession dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
            if (!error)
            {
                NSError *error;
                NSArray *JSONObject = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
                
                if (!error)
                {
                    NSArray *trends = JSONObject[0][@"trends"];
                    NSMutableArray *topics = [[NSMutableArray alloc] initWithCapacity:trends.count];
                    for (NSDictionary *trend in trends)
                    {
                        NSString *topic = trend[@"name"];

                        [topics addObject:topic];
                    }
                    
                    success([NSArray arrayWithArray:topics]);
                }
                else if (failure)
                    failure([error localizedDescription], error);
            }
            else if (failure)
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

- (void)requestTweetsWithQuery:(NSString *)query success:(void(^)(NSArray *))success failure:(void(^)(NSString *, NSError *))failure
{
	void (^requestBlock)() = ^{
		NSURL *requestURL = [NSURL URLWithString:[NSString stringWithFormat:@"/1.1/search/tweets.json?q=%@;&count=50", [query stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]] relativeToURL:self.twitterAPIEndPoint];
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

- (void)loadImageWithURL:(NSURL *)URL completion:(void (^)(UIImage *))completion
{
    NSURLSessionDownloadTask *task = [self.twitterSession downloadTaskWithURL:URL completionHandler:^(NSURL * _Nullable location, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        NSData *data = [[NSData alloc] initWithContentsOfFile:[location path]];
        UIImage *image = [UIImage imageWithData:data];
        
        CGFloat dimension = image.size.width > image.size.height ? image.size.width : image.size.height;
        CGRect bounds = CGRectMake(.5, .5, dimension, dimension);
        
        UIGraphicsBeginImageContextWithOptions(bounds.size, NO, [UIScreen mainScreen].scale);
        
        UIBezierPath *bezierPath = [UIBezierPath bezierPathWithRoundedRect:bounds cornerRadius:floorf(bounds.size.height / 2.f)];
        [bezierPath addClip];
        
        [image drawInRect:bounds];
        
        UIImage *finalImage = UIGraphicsGetImageFromCurrentImageContext();
        
        UIGraphicsEndImageContext();
        
        dispatch_async(dispatch_get_main_queue(), ^{
            completion(finalImage);
        });
        
    }];
    
    [task resume];
    
    self.downloadTasks[URL] = task;
}

- (void)cancelDownloadTaskForURL:(NSURL *)URL
{
    NSURLSessionDownloadTask *task = self.downloadTasks[URL];
    
    [self.downloadTasks removeObjectForKey:URL];
    
    [task cancel];
}

@end
