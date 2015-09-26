//
//  TPKSearchBar.m
//  TweetPeek
//
//  Created by Felipe Lobo on 9/22/15.
//  Copyright © 2015 Felipe Lobo. All rights reserved.
//

#import "TPKSearchBar.h"
#import "UIColor+TPK.h"

@interface TPKSearchBar () <UITextFieldDelegate>

@property (nonatomic, strong) UIImageView *magnifierView;
@property (nonatomic, strong) UITextField *textField;
@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) NSLayoutConstraint *magnifierWidthConstraint;
@property (nonatomic, strong) NSLayoutConstraint *magnifierHorizontalPositionConstraint;

@property (nonatomic, strong) NSArray *regularConstraints;
@property (nonatomic, strong) NSArray *compactConstraints;

@end

@implementation TPKSearchBar

- (instancetype)init
{
    self = [super init];
    if (self)
        [self initialize];
    
    return self;
}

- (void)initialize
{
    [self addTarget:self action:@selector(tapInside:) forControlEvents:UIControlEventTouchUpInside];
    
    UIImageView *magnifierView = [[UIImageView alloc] init];
    magnifierView.backgroundColor = [UIColor clearColor];
    magnifierView.image = [[UIImage imageNamed:@"Icon_search_big.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    magnifierView.contentMode = UIViewContentModeScaleAspectFit;
    magnifierView.translatesAutoresizingMaskIntoConstraints = NO;
    magnifierView.tintColor = [UIColor tpk_blueColor];
    magnifierView.userInteractionEnabled = NO;

    [self addSubview:magnifierView];
    
    self.magnifierView = magnifierView;
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.textColor = [UIColor tpk_blueColor];
    titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Thin" size:64.f];
    titleLabel.text = NSLocalizedString(@"Search it", nil);
    titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    titleLabel.userInteractionEnabled = NO;
    
    [self addSubview:titleLabel];
    
    self.titleLabel = titleLabel;
    
    UITextField *textField = [[UITextField alloc] init];
    textField.backgroundColor = [UIColor clearColor];
    textField.font = [UIFont fontWithName:@"HelveticaNeue-Thin" size:48.f];
    textField.textColor = [UIColor grayColor];
    textField.translatesAutoresizingMaskIntoConstraints = NO;
    textField.userInteractionEnabled = NO;
    textField.returnKeyType = UIReturnKeySearch;
    textField.delegate = self;
    
    [self addSubview:textField];
    
    self.textField = textField;
    
    NSDictionary *views = NSDictionaryOfVariableBindings(magnifierView, textField, titleLabel);
    
    
    
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[textField]|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:nil views:views]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[magnifierView]|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:nil views:views]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[titleLabel]|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:nil views:views]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"[magnifierView]-36-[textField]-0@900-|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:nil views:views]];
    
    NSArray *magnifierPlusTitleConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"|-0@900-[magnifierView]-0@900-[titleLabel(==259)]-0@900-|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:nil views:views];
    [self addConstraints:magnifierPlusTitleConstraints];
    
    const CGFloat kTextFieldMargin = 30.f;
    NSLayoutConstraint *textFieldWidthConstraint = [NSLayoutConstraint constraintWithItem:textField attribute:NSLayoutAttributeWidth
                                                                                relatedBy:NSLayoutRelationEqual
                                                                                   toItem:self attribute:NSLayoutAttributeWidth
                                                                               multiplier:1.f constant:kTextFieldMargin];
    textFieldWidthConstraint.priority = 800;
    [self addConstraint:textFieldWidthConstraint];
    
    const CGFloat kFromCenter = 180.f;
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:titleLabel attribute:NSLayoutAttributeRightMargin
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self attribute:NSLayoutAttributeCenterX
                                                    multiplier:1.f constant:kFromCenter]];
    
    self.magnifierWidthConstraint = [NSLayoutConstraint constraintWithItem:magnifierView attribute:NSLayoutAttributeWidth
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:nil attribute:NSLayoutAttributeNotAnAttribute
                                                                multiplier:1.f constant:74.f];
    
	self.magnifierHorizontalPositionConstraint = [NSLayoutConstraint constraintWithItem:magnifierView attribute:NSLayoutAttributeLeftMargin
                                                                              relatedBy:NSLayoutRelationEqual
                                                                                 toItem:self attribute:NSLayoutAttributeCenterX
                                                                             multiplier:1.f constant:-kFromCenter];

    [self addConstraints:@[self.magnifierHorizontalPositionConstraint, self.magnifierWidthConstraint]];
}

- (void)tapInside:(id)sender
{
    [self removeConstraint:self.magnifierHorizontalPositionConstraint];
    
    self.magnifierHorizontalPositionConstraint = [NSLayoutConstraint constraintWithItem:self.magnifierView attribute:NSLayoutAttributeLeftMargin
                                                                              relatedBy:NSLayoutRelationEqual
                                                                                 toItem:self attribute:NSLayoutAttributeLeftMargin
                                                                             multiplier:1.f constant:55.f];
    
    [self addConstraint:self.magnifierHorizontalPositionConstraint];
    
    [UIView animateWithDuration:.3f animations:^{
        
        [self layoutIfNeeded];
        
        self.titleLabel.alpha = .0f;
        
    } completion:^(BOOL finished) {
        
        self.textField.userInteractionEnabled = YES;
        
        [self.textField becomeFirstResponder];
        
    }];
    
    [self removeTarget:self action:@selector(tapInside:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)transitToBlueStyle:(BOOL)animated
{
    [self removeConstraints:@[self.magnifierWidthConstraint, self.magnifierHorizontalPositionConstraint]];
    
    self.magnifierWidthConstraint = [NSLayoutConstraint constraintWithItem:self.magnifierView attribute:NSLayoutAttributeWidth
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:nil attribute:NSLayoutAttributeNotAnAttribute
                                                                multiplier:1.f constant:36.f];
    
    self.magnifierHorizontalPositionConstraint = [NSLayoutConstraint constraintWithItem:self.magnifierView attribute:NSLayoutAttributeLeftMargin
                                                                              relatedBy:NSLayoutRelationEqual
                                                                                 toItem:self attribute:NSLayoutAttributeLeftMargin
                                                                             multiplier:1.f constant:32.f];
    
    [self addConstraints:@[self.magnifierHorizontalPositionConstraint, self.magnifierWidthConstraint]];
    
	[UIView animateWithDuration:animated ? .4f : .0f delay:.0f options:UIViewAnimationOptionCurveEaseOut animations:^{

		[self layoutIfNeeded];

		self.backgroundColor = [UIColor tpk_blueColor];

		self.textField.textColor = [UIColor whiteColor];
		self.textField.font = [UIFont fontWithName:@"HelveticaNeue-Medium" size:27];

		self.magnifierView.tintColor = [UIColor whiteColor];

	} completion:nil];
}

#pragma mark - Text field
#pragma mark Delegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField.text.length > 0)
    {
        if (_requestToSearchBlock)
            _requestToSearchBlock(textField.text);
        
        [textField resignFirstResponder];
        
        return YES;
    }
    
    return NO;
}

#pragma mark - Layout definitions

- (void)createLayoutConstraints
{
    
}

@end
