//
//  TPKTweetCell.h
//  TweetPeek
//
//  Created by Felipe Lobo on 9/24/15.
//  Copyright © 2015 Felipe Lobo. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TPKTweet;
@interface TPKTweetCell : UICollectionViewCell

@property (nonatomic, strong) UIImageView *userImageView;
@property (nonatomic, strong) UILabel *userNameLabel;
@property (nonatomic, strong) UILabel *statusLabel;
@property (nonatomic, strong) TPKTweet *tweet;

@end
