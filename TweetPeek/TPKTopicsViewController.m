//
//  TPKTopicsViewController.m
//  TweetPeek
//
//  Created by Felipe Lobo on 9/27/15.
//  Copyright © 2015 Felipe Lobo. All rights reserved.
//

#import "TPKTopicsViewController.h"
#import "UIColor+TPK.h"

@interface TPKTopicsViewController ()

@property (nonatomic, strong) UIView *topView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) NSArray *buttonList;

@property (nonatomic, strong) NSMutableArray *regularConstraints;
@property (nonatomic, strong) NSMutableArray *compactConstraints;

@end

@implementation TPKTopicsViewController

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIView *topView = [[UIView alloc] init];
    topView.backgroundColor = [UIColor tpk_blueColor];
    topView.translatesAutoresizingMaskIntoConstraints = NO;
    
    [self.view addSubview:topView];
    
    self.topView = topView;
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.textColor = [UIColor tpk_blueColor];
    titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    
    [self.view addSubview:titleLabel];
    
    self.titleLabel = titleLabel;
    
    NSMutableArray *mutableButtons = [[NSMutableArray alloc] initWithCapacity:5];
    
    for (int i = 0; i < 5; i++)
    {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.translatesAutoresizingMaskIntoConstraints = NO;
        button.userInteractionEnabled = NO;
        button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [button setTitleColor:[UIColor colorWithWhite:.42f alpha:1.f] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(didTapTopicButton:) forControlEvents:UIControlEventTouchUpInside];
        
        [mutableButtons addObject:button];
        
        [self.view addSubview:button];
    }
    
    self.buttonList = [NSArray arrayWithArray:mutableButtons];
    
    [self createConstraints];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self validateConstraints];
}

- (void)willTransitionToTraitCollection:(UITraitCollection *)newCollection withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator
{
    [self validateConstraintsForTraitCollection:newCollection];
}

#pragma mark - Properties
#pragma mark Set

- (void)setTitle:(NSString *)title
{
    [super setTitle:title];
    
    self.titleLabel.text = title;
}

- (void)setTopics:(NSArray *)topics
{
    _topics = topics;
    
    for (int i = 0; i < topics.count && i < 5; i++)
    {
        NSString *topic = topics[i];
        UIButton *button = self.buttonList[i];
        
        button.userInteractionEnabled = YES;
        [button setTitle:topic forState:UIControlStateNormal];
    }
}

#pragma mark - Actions

- (void)didTapTopicButton:(UIButton *)sender
{
    [_delegate topicsViewController:self didSelectTopic:[sender titleForState:UIControlStateNormal]];
}

#pragma mark - Layout

- (void)createConstraints
{
    NSMutableDictionary *views = [[NSMutableDictionary alloc] init];
    views[@"titleLabel"] = self.titleLabel;
    views[@"topView"] = self.topView;

    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[titleLabel]|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:nil views:views]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[topView]|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:nil views:views]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[topView]-10-[titleLabel]" options:NSLayoutFormatDirectionLeadingToTrailing metrics:nil views:views]];
    
    NSMutableArray *regularConstraints = [[NSMutableArray alloc] init];
    NSMutableArray *compactConstraints = [[NSMutableArray alloc] init];
    
    NSLayoutConstraint *constraint;
    
    constraint = [NSLayoutConstraint constraintWithItem:self.topView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.f constant:4.f];
    [regularConstraints addObject:constraint];
    [self.view addConstraint:constraint];

    constraint = [NSLayoutConstraint constraintWithItem:self.titleLabel attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.f constant:34.f];
    [regularConstraints addObject:constraint];
    [self.view addConstraint:constraint];
    
    constraint = [NSLayoutConstraint constraintWithItem:self.topView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.f constant:2.f];
    [compactConstraints addObject:constraint];
    [self.view addConstraint:constraint];
    
    constraint = [NSLayoutConstraint constraintWithItem:self.titleLabel attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.f constant:26.f];
    [compactConstraints addObject:constraint];
    [self.view addConstraint:constraint];
    
    for (int i = 0; i < 5; i++)
    {
        NSString *bx = [NSString stringWithFormat:@"b%d", i];
        UIButton *button = views[bx] = self.buttonList[i];
        
        [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:[NSString stringWithFormat:@"H:|[%@]|", bx] options:NSLayoutFormatDirectionLeadingToTrailing metrics:nil views:views]];
        
        if (i == 0)
            [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:[NSString stringWithFormat:@"V:[titleLabel]-10-[%@]", bx] options:NSLayoutFormatDirectionLeadingToTrailing metrics:nil views:views]];
        else
        {
            NSString *bw = [NSString stringWithFormat:@"b%d", i-1];
            [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:[NSString stringWithFormat:@"V:[%@]-4-[%@]", bw, bx] options:NSLayoutFormatDirectionLeadingToTrailing metrics:nil views:views]];
        }
        
        constraint = [NSLayoutConstraint constraintWithItem:button attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.f constant:32.f];
        [regularConstraints addObject:constraint];
        [self.view addConstraint:constraint];
        
        constraint = [NSLayoutConstraint constraintWithItem:button attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.f constant:22.f];
        [compactConstraints addObject:constraint];
        [self.view addConstraint:constraint];
    }
    
    self.regularConstraints = regularConstraints;
    self.compactConstraints = compactConstraints;
    
    [self validateConstraints];
}

- (void)validateConstraints
{
    [self validateConstraintsForTraitCollection:self.traitCollection];
}

- (void)validateConstraintsForTraitCollection:(UITraitCollection *)traitCollection
{
    if (traitCollection.horizontalSizeClass == UIUserInterfaceSizeClassCompact || traitCollection.verticalSizeClass == UIUserInterfaceSizeClassCompact)
    {
        [NSLayoutConstraint activateConstraints:self.compactConstraints];
        [NSLayoutConstraint deactivateConstraints:self.regularConstraints];
        
        self.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Medium" size:18];
        for (UIButton *button in self.buttonList)
            button.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:13];
    }
    else
    {
        [NSLayoutConstraint activateConstraints:self.regularConstraints];
        [NSLayoutConstraint deactivateConstraints:self.compactConstraints];
        
        self.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Medium" size:24];
        for (UIButton *button in self.buttonList)
            button.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:17];
    }
    
    [self.view layoutIfNeeded];
}

@end
