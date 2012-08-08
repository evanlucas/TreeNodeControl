//
//  PSBaseBranchView.m
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


#import "TreeNodeArrowView.h"
#import "TreeView.h"
#import "TreeNodeContainerView.h"
@implementation TreeNodeArrowView
@synthesize treeView = _treeView;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor clearColor];
        self.opaque = NO;
    }
    return self;
}

- (TreeView *)treeView {
    UIView *ancestor = self.superview;
    while (ancestor) {
        if ([ancestor isKindOfClass:[TreeView class]]) {
            return (TreeView *)ancestor;
        }
        ancestor = [ancestor superview];
    }
    return nil;
}
- (UIBezierPath *)path {

    CGRect bounds = [self bounds];
    
    
	CGPoint rootPoint = CGPointZero;
	
    rootPoint = CGPointMake(CGRectGetMidX(bounds),
                            CGRectGetMinY(bounds));
    
	CGPoint rootIntersection = CGPointMake(CGRectGetMidX(bounds), CGRectGetMidY(bounds));
    
    UIBezierPath *p = [UIBezierPath bezierPath];
    
	CGFloat minX = rootPoint.x;
    CGFloat maxX = rootPoint.x;
    
    UIView *subtreeView = [self superview];
    NSInteger subtreeViewCount = 0;
    
    if ([subtreeView isKindOfClass:[TreeNodeContainerView class]]) {
        
        for (UIView *subview in [subtreeView subviews]) {
            if ([subview isKindOfClass:[TreeNodeContainerView class]]) {
                ++subtreeViewCount;
                CGRect subviewBounds = [subview bounds];
				CGPoint targetPoint = CGPointZero;
                targetPoint = [self convertPoint:CGPointMake(CGRectGetMidX(subviewBounds), CGRectGetMinY(subviewBounds)) fromView:subview];
                [p moveToPoint:CGPointMake(targetPoint.x, rootIntersection.y)];
                if (minX > targetPoint.x) {
                    minX = targetPoint.x;
                }
                if (maxX < targetPoint.x) {
                    maxX = targetPoint.x;
                }
				
                
                [p addLineToPoint:targetPoint];
                
            }
        }
    }
    
    if (subtreeViewCount) {
        [p moveToPoint:rootPoint];
        [p addLineToPoint:rootIntersection];
        
        [p moveToPoint:CGPointMake(minX, rootIntersection.y)];
        [p addLineToPoint:CGPointMake(maxX, rootIntersection.y)];
		
    }
    
    // Return the path.
    return p;
    
}
- (void)drawRect:(CGRect)rect {
    UIBezierPath *path = nil;
    path = [self path];
    [[UIColor darkGrayColor] set];
    [path setLineWidth:2.0f];
    [path stroke];
}

@end
