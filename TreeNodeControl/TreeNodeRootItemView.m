//
//  PSBaseLeafView.m
//  PSTreeGraphView
//
//  Created by Ed Preston on 7/25/10.
//  Copyright 2010 Preston Software. All rights reserved.
//
//
//  This is a port of the sample code from Max OS X to iOS (iPad).
//
//  WWDC 2010 Session 141, “Crafting Custom Cocoa Views”
//

//
//  Modified By Evan Lucas
//


#import "TreeNodeRootItemView.h"
#define DEFAULT_FRAME CGRectMake(0, 0, 300, 80)
@implementation TreeNodeRootItemView

@synthesize backgroundView = _backgroundView;
@synthesize currentlySelected = _currentlySelected;
@synthesize imageViewIcon = _imageViewIcon;
@synthesize node = _node;
@synthesize titleLabel = _titleLabel;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:DEFAULT_FRAME];
    if (self) {
        self.opaque = NO;
        self.backgroundColor = [UIColor clearColor];
        self.backgroundView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 300, 80)];
        [self.backgroundView setImage:[UIImage imageNamed:@"root_bg"]];
        [self addSubview:self.backgroundView];
        self.imageViewIcon = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 60, 60)];
        [self.imageViewIcon setContentMode:UIViewContentModeScaleAspectFit];
        [self addSubview:self.imageViewIcon];
        
        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(80, 20, 200, 40)];
        [self.titleLabel setNumberOfLines:0];
        [self.titleLabel setBackgroundColor:[UIColor clearColor]];
        [self.titleLabel setFont:[UIFont boldSystemFontOfSize:16]];
        [self.titleLabel setTextColor:[UIColor whiteColor]];
        [self.titleLabel setTextAlignment:UITextAlignmentCenter];
        [self addSubview:self.titleLabel];
    }
    return self;
}
- (void)dealloc {
    [_imageViewIcon release];
    [_titleLabel release];
    [_backgroundView release];
    [super dealloc];
}

@end
