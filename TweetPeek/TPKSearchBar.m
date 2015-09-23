//
//  TPKSearchBar.m
//  TweetPeek
//
//  Created by Felipe Lobo on 9/22/15.
//  Copyright © 2015 Felipe Lobo. All rights reserved.
//

#import "TPKSearchBar.h"
#import "UIColor+TPK.h"

@interface TPKSearchBar ()

@property (nonatomic, strong) NSLayoutConstraint *textFieldWidthConstraint;
@property (nonatomic, strong) NSLayoutConstraint *magnifierWidthConstraint;
@property (nonatomic, strong) NSLayoutConstraint *textFieldHorizontalPositionConstraint;
@property (nonatomic, strong) NSLayoutConstraint *magnifierHorizontalPositionConstraint;

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
    UIImageView *magnifierView = [[UIImageView alloc] init];
    magnifierView.backgroundColor = [UIColor clearColor];
    magnifierView.image = [UIImage imageNamed:@"Icon_search_big.png"];
    magnifierView.contentMode = UIViewContentModeScaleAspectFit;
    magnifierView.translatesAutoresizingMaskIntoConstraints = NO;
    
    [self addSubview:magnifierView];
    
    self.magnifierView = magnifierView;
    
    UITextField *textField = [[UITextField alloc] init];
    textField.backgroundColor = [UIColor clearColor];
    textField.font = [UIFont fontWithName:@"HelveticaNeue-Thin" size:64];
    textField.textColor = UIColorWithRGB(94, 159, 202);
    textField.text = NSLocalizedString(@"Search it", nil);
    textField.translatesAutoresizingMaskIntoConstraints = NO;
    [textField addTarget:self action:@selector(didBeginEditing:) forControlEvents:UIControlEventEditingDidBegin];
    
    [self addSubview:textField];
    
    self.textField = textField;
    
    NSDictionary *views = NSDictionaryOfVariableBindings(magnifierView, textField);
    
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[textField]|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:nil views:views]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[magnifierView]|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:nil views:views]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|-0@900-[magnifierView(==74)]-0@900-[textField(==259)]-0@900-|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:nil views:views]];

	self.textFieldWidthConstraint = [NSLayoutConstraint constraintWithItem:textField attribute:NSLayoutAttributeLeftMargin relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1.f constant:-180.f];
	self.magnifierWidthConstraint = [NSLayoutConstraint constraintWithItem:magnifierView attribute:NSLayoutAttributeRightMargin relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1.f constant:180.f];

    [self addConstraint:self.textFieldWidthConstraint];
    [self addConstraint:self.magnifierWidthConstraint];
}

- (void)didBeginEditing:(UITextField *)textField
{
    textField.text = nil;

	dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
		[self transitToFullSearch];
		if (self.didBeginEditingBlock)
			self.didBeginEditingBlock();
	});
}

- (void)transitToFullSearch
{
	self.textFieldWidthConstraint.constant = ;
	self.magnifierWidthConstraint.constant = 40.f - floorf(self.view.frame.size.width / 2.f)
}

@end
