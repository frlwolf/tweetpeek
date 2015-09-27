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

@property (nonatomic, weak) NSLayoutConstraint *magnifierWidthConstraintCompact;
@property (nonatomic, weak) NSLayoutConstraint *magnifierWidthConstraintRegular;
@property (nonatomic, weak) NSLayoutConstraint *magnifierHorizontalPositionConstraintCompact;
@property (nonatomic, weak) NSLayoutConstraint *magnifierHorizontalPositionConstraintRegular;

@property (nonatomic, strong) UIFont *titleFontRegular;
@property (nonatomic, strong) UIFont *titleFontCompact;
@property (nonatomic, strong) UIFont *fieldFontRegular;
@property (nonatomic, strong) UIFont *fieldFontCompact;

@property (nonatomic, strong) NSMutableArray *titleLabelConstraints;
@property (nonatomic, strong) NSMutableArray *regularConstraints;
@property (nonatomic, strong) NSMutableArray *compactConstraints;

@end

@implementation TPKSearchBar

#pragma mark - Initalization

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
    titleLabel.text = NSLocalizedString(@"Search it", nil);
    titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.userInteractionEnabled = NO;
    
    [self addSubview:titleLabel];
    
    self.titleLabel = titleLabel;
    
    UITextField *textField = [[UITextField alloc] init];
    textField.backgroundColor = [UIColor clearColor];
    textField.textColor = [UIColor grayColor];
    textField.translatesAutoresizingMaskIntoConstraints = NO;
    textField.userInteractionEnabled = NO;
    textField.returnKeyType = UIReturnKeySearch;
    textField.delegate = self;
    
    [self addSubview:textField];
    
    self.textField = textField;
    
    self.titleFontCompact = [UIFont fontWithName:@"HelveticaNeue-Thin" size:36.f];
    self.fieldFontCompact = [UIFont fontWithName:@"HelveticaNeue-Thin" size:28.f];
    self.titleFontRegular = [UIFont fontWithName:@"HelveticaNeue-Thin" size:64.f];
    self.fieldFontRegular = [UIFont fontWithName:@"HelveticaNeue-Thin" size:48.f];
    
    [self createConstraints];
}

#pragma mark - Actions

- (void)tapInside:(id)sender
{
    [self.regularConstraints removeObject:self.magnifierHorizontalPositionConstraintRegular];
    [self removeConstraint:self.magnifierHorizontalPositionConstraintRegular];
    
    self.magnifierHorizontalPositionConstraintRegular = [NSLayoutConstraint constraintWithItem:_magnifierView attribute:NSLayoutAttributeLeftMargin
                                                                                     relatedBy:NSLayoutRelationEqual
                                                                                        toItem:self attribute:NSLayoutAttributeLeftMargin
                                                                                    multiplier:1.f constant:55.f];
    
    [self.regularConstraints addObject:self.magnifierHorizontalPositionConstraintRegular];
    [self addConstraint:self.magnifierHorizontalPositionConstraintRegular];
    
    [self.compactConstraints removeObject:self.magnifierHorizontalPositionConstraintCompact];
    [self removeConstraint:self.magnifierHorizontalPositionConstraintCompact];
    
    self.magnifierHorizontalPositionConstraintCompact = [NSLayoutConstraint constraintWithItem:_magnifierView attribute:NSLayoutAttributeLeftMargin
                                                                                     relatedBy:NSLayoutRelationEqual
                                                                                        toItem:self attribute:NSLayoutAttributeLeftMargin
                                                                                    multiplier:1.f constant:36.f];
    
    [self.compactConstraints addObject:self.magnifierHorizontalPositionConstraintCompact];
    [self addConstraint:self.magnifierHorizontalPositionConstraintCompact];
    
    [UIView animateWithDuration:.3f animations:^{
        [self layoutIfNeeded];
        self.titleLabel.alpha = .0f;
    } completion:^(BOOL finished) {
        self.titleLabel.hidden = YES;
        self.titleLabel.alpha = 1.f;
        self.textField.userInteractionEnabled = YES;
        [self.textField becomeFirstResponder];
    }];
    
    [self removeTarget:self action:@selector(tapInside:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)transitToBlueStyle:(BOOL)animated
{
    self.magnifierWidthConstraintRegular.constant = 36.f;
    self.magnifierHorizontalPositionConstraintRegular.constant = 32.f;
    
    self.magnifierWidthConstraintCompact.constant = 26.f;
    self.magnifierHorizontalPositionConstraintCompact.constant = 23.f;
    
    [self.regularConstraints removeObjectsInArray:self.titleLabelConstraints];
    [self.compactConstraints removeObjectsInArray:self.titleLabelConstraints];

    [self removeConstraints:self.titleLabelConstraints];
    
    self.titleLabel.hidden = NO;
    self.titleLabel.textColor = [UIColor whiteColor];
    
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[_titleLabel]-|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:nil views:NSDictionaryOfVariableBindings(_titleLabel)]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-[_titleLabel]-|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:nil views:NSDictionaryOfVariableBindings(_titleLabel)]];
    
    [self layoutIfNeeded];
    
    self.backgroundColor = [UIColor tpk_blueColor];
    
    self.textField.textColor = [UIColor whiteColor];
    self.titleFontRegular = self.fieldFontRegular = [UIFont fontWithName:@"HelveticaNeue-Medium" size:27];
    self.titleFontCompact = self.fieldFontCompact = [UIFont fontWithName:@"HelveticaNeue-Medium" size:17];
    
    self.magnifierView.tintColor = [UIColor whiteColor];
    
    [self validateConstraints];
}

#pragma mark - Text field
#pragma mark Delegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    _titleLabel.text = @"";
    
    return YES;
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    _titleLabel.text = [NSString stringWithFormat:@"\"%@\"", textField.text];
    
    textField.text = @"";
    
    return YES;
}

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

#pragma mark - Layout

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [self validateConstraints];
}

- (void)createConstraints
{
    NSDictionary *views = NSDictionaryOfVariableBindings(_magnifierView, _textField, _titleLabel);
    
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_textField]|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:nil views:views]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_magnifierView]|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:nil views:views]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_titleLabel]|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:nil views:views]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_titleLabel attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterY multiplier:1.f constant:.0f]];
    
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[_textField]-0@800-|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:nil views:views]];
    
    NSMutableArray *regularConstraints = [[NSMutableArray alloc] init];
    NSMutableArray *compactConstraints = [[NSMutableArray alloc] init];
    
    NSLayoutConstraint *constraint;
    
//    @property (nonatomic, weak) NSLayoutConstraint *leftMarginZeroConstraint;
//    @property (nonatomic, weak) NSLayoutConstraint *leftMarginMagnifierConstraint;
    
    constraint = [NSLayoutConstraint constraintWithItem:_textField attribute:NSLayoutAttributeLeftMargin relatedBy:NSLayoutRelationEqual toItem:_magnifierView attribute:NSLayoutAttributeRight multiplier:1.f constant:36.f];
    [regularConstraints addObject:constraint];
    [self addConstraint:constraint];
    
    constraint = [NSLayoutConstraint constraintWithItem:_titleLabel attribute:NSLayoutAttributeLeftMargin relatedBy:NSLayoutRelationEqual toItem:_magnifierView attribute:NSLayoutAttributeRight multiplier:1.f constant:36.f];
    [regularConstraints addObject:constraint];
    [self addConstraint:constraint];
    
    [self.titleLabelConstraints addObject:constraint];
    
    constraint = [NSLayoutConstraint constraintWithItem:_titleLabel attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.f constant:256.f];
    [regularConstraints addObject:constraint];
    [self addConstraint:constraint];
    
    [self.titleLabelConstraints addObject:constraint];
    
    constraint = [NSLayoutConstraint constraintWithItem:_magnifierView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.f constant:74.f];
    [regularConstraints addObject:constraint];
    [self addConstraint:constraint];
    
    self.magnifierWidthConstraintRegular = constraint;
    
    constraint = [NSLayoutConstraint constraintWithItem:_magnifierView attribute:NSLayoutAttributeLeftMargin relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1.f constant:-183.f];
    [regularConstraints addObject:constraint];
    [self addConstraint:constraint];
    
    self.magnifierHorizontalPositionConstraintRegular = constraint;
    
    constraint = [NSLayoutConstraint constraintWithItem:_textField attribute:NSLayoutAttributeLeftMargin relatedBy:NSLayoutRelationEqual toItem:_magnifierView attribute:NSLayoutAttributeRight multiplier:1.f constant:20.f];
    [compactConstraints addObject:constraint];
    [self addConstraint:constraint];
    
    constraint = [NSLayoutConstraint constraintWithItem:_titleLabel attribute:NSLayoutAttributeLeftMargin relatedBy:NSLayoutRelationEqual toItem:_magnifierView attribute:NSLayoutAttributeRight multiplier:1.f constant:20.f];
    [compactConstraints addObject:constraint];
    [self addConstraint:constraint];
    
    [self.titleLabelConstraints addObject:constraint];
    
    constraint = [NSLayoutConstraint constraintWithItem:_titleLabel attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.f constant:134.f];
    [compactConstraints addObject:constraint];
    [self addConstraint:constraint];
    
    [self.titleLabelConstraints addObject:constraint];
    
    constraint = [NSLayoutConstraint constraintWithItem:_magnifierView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.f constant:34.f];
    [compactConstraints addObject:constraint];
    [self addConstraint:constraint];
    
    self.magnifierWidthConstraintCompact = constraint;
    
    constraint = [NSLayoutConstraint constraintWithItem:_magnifierView attribute:NSLayoutAttributeLeftMargin relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1.f constant:-89.f];
    [compactConstraints addObject:constraint];
    [self addConstraint:constraint];
    
    self.magnifierHorizontalPositionConstraintCompact = constraint;
    
    self.regularConstraints = regularConstraints;
    self.compactConstraints = compactConstraints;
    
    [self validateConstraints];
//    NSLayoutConstraint *constraint = [NSLayoutConstraint constraintWithItem:_titleLabel attribute:NSLayoutAttributeRightMargin relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1.f constant:fromCenter];
}

- (void)validateConstraints
{
    UITraitCollection *traitCollection = self.traitCollection;
    
    if (traitCollection.horizontalSizeClass == UIUserInterfaceSizeClassCompact || traitCollection.verticalSizeClass == UIUserInterfaceSizeClassCompact)
    {
        [NSLayoutConstraint activateConstraints:self.compactConstraints];
        [NSLayoutConstraint deactivateConstraints:self.regularConstraints];
    
        self.titleLabel.font = self.titleFontCompact;
        self.textField.font = self.fieldFontCompact;
    }
    else
    {
        [NSLayoutConstraint activateConstraints:self.regularConstraints];
        [NSLayoutConstraint deactivateConstraints:self.compactConstraints];

        self.titleLabel.font = self.titleFontRegular;
        self.textField.font = self.fieldFontRegular;
    }
    
    [self layoutIfNeeded];
}

@end
