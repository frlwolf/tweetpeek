//
//  TPKTweetCell.h
//  TweetPeek
//
//  Created by Felipe Lobo on 9/24/15.
//  Copyright © 2015 Felipe Lobo. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TPKTweet;

typedef NS_ENUM(short, TPKTweetCellAction) {
    TPKTweetCellActionFavorite,
    TPKTweetCellActionRetweet,
    TPKTweetCellActionReply,
    TPKTweetCellActionForward
};

@interface TPKTweetCell : UICollectionViewCell

@property (nonatomic, strong) UIImageView *userImageView;
@property (nonatomic, strong) UILabel *userNameLabel;
@property (nonatomic, strong) UILabel *statusLabel;
@property (nonatomic, strong) TPKTweet *tweet;

@property (nonatomic, copy) void(^tweetCellActionBlock)(TPKTweetCellAction);

@end
