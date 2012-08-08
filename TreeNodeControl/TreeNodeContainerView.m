//
//  PSBaseSubtreeView.m
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




#import "TreeNodeContainerView.h"
#import "TreeNode.h"
#import "TreeNodeArrowView.h"
#import "TreeNodeItemView.h"
#import "TreeNodeRootItemView.h"
#import <QuartzCore/QuartzCore.h>

#define SUBTREE_BORDER_WIDTH 1.0f
#define CONTENT_MARGIN 10.0f
#define PARENT_CHILD_SPACING 20.0f
#define SIBLING_SPACING 10.0f


@implementation TreeNodeContainerView
@synthesize rootNode = _rootNode;
@synthesize treeView = _treeView;
@synthesize needsGraphLayout = _needsGraphLayout;
@synthesize connectorsView = _connectorsView;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}
- (id)initWithNode:(TreeNode *)node {
    if (self = [super initWithFrame:CGRectZero]) {
        self.rootNode = node;
        [self setAutoresizesSubviews:NO];
        self.rootNode.containerView = self;
        if (node.nodeType == TreeNodeTypeRoot) {
            CGFloat frameHeight = 80.0;
            
            [self setFrame:CGRectMake(10.0, 10.0, 300.0, frameHeight)];
        } else {
            [self setFrame:CGRectMake(10.0, 10.0, 100.0, 100.0)];
        }
        self.needsGraphLayout = YES;
        
        self.connectorsView = [[TreeNodeArrowView alloc] initWithFrame:CGRectZero];
        if (self.connectorsView) {
            [self.connectorsView setAutoresizesSubviews:YES];
            [self.connectorsView setContentMode:UIViewContentModeRedraw];
            [self.connectorsView setOpaque:YES];
            [self addSubview:self.connectorsView];
        }
        //self.layer.borderColor = [UIColor greenColor].CGColor;
        //self.layer.borderWidth = 1.0f;
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

- (CGSize)layoutGraphIfNeeded {
    if (!self.needsGraphLayout) {
        return self.frame.size;
    }
    CGSize targetSize = [self layoutGraph];
    
    self.needsGraphLayout = NO;
    
    return targetSize;
}

- (CGSize)layoutGraph {
    CGSize targetSize;
    
    // CallflowView *callflowView = [self callflowView];
    CGFloat parentChildSpacing = PARENT_CHILD_SPACING;
    CGFloat siblingSpacing = SIBLING_SPACING;
    
    
    CGSize rootNodeViewSize = self.rootNode.nodeType == TreeNodeTypeRoot ? CGSizeMake(300.0, 80.0) : CGSizeMake(100.0, 100.0);
    NSArray *subviews = [self subviews];
    NSInteger count = subviews.count;
    NSInteger index;
    NSUInteger subtreeViewCount = 0;
    CGFloat maxHeight = 0.0f;
    CGPoint nextSubtreeViewOrigin = CGPointZero;
    
    nextSubtreeViewOrigin = CGPointMake(0.0f, rootNodeViewSize.height + parentChildSpacing);
    for (index = count - 1; index >= 0; index--) {
        UIView *subview = [subviews objectAtIndex:index];
        
        if ([subview isKindOfClass:[TreeNodeContainerView class]]) {
            ++subtreeViewCount;
            
            CGSize subtreeViewSize = [(TreeNodeContainerView *)subview layoutGraphIfNeeded];
            
            subview.frame = CGRectMake(nextSubtreeViewOrigin.x, nextSubtreeViewOrigin.y, subtreeViewSize.width, subtreeViewSize.height);
            
            nextSubtreeViewOrigin.x += subtreeViewSize.width + siblingSpacing;
            if (maxHeight < subtreeViewSize.height) {
                maxHeight = subtreeViewSize.height;
            }
        }
    }
    
    
    CGFloat totalWidth = 0.0f;
    
    totalWidth = nextSubtreeViewOrigin.x;
    if (subtreeViewCount > 0) {
        totalWidth -= siblingSpacing;
    }
    
    if (subtreeViewCount > 0) {
        targetSize = CGSizeMake(MAX(totalWidth, rootNodeViewSize.width), rootNodeViewSize.height + parentChildSpacing + maxHeight);
        self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, targetSize.width, targetSize.height);
        CGPoint nodeViewOrigin = CGPointZero;
        
        nodeViewOrigin = CGPointMake(0.5f * (targetSize.width - rootNodeViewSize.width), 0.0f);
        
        self.rootNode.nodeView.frame = CGRectMake(nodeViewOrigin.x, nodeViewOrigin.y, self.rootNode.nodeView.frame.size.width, self.rootNode.nodeView.frame.size.height);
        
        self.connectorsView.frame = CGRectMake(0.0f, rootNodeViewSize.height, targetSize.width, parentChildSpacing);
        
    } else {
        targetSize = rootNodeViewSize;
        self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, targetSize.width, targetSize.height);
        self.rootNode.nodeView.frame = CGRectMake(0.0f, 0.0f, self.rootNode.nodeView.frame.size.width, self.rootNode.nodeView.frame.size.height);
    }
    return targetSize;
}

- (void)recursiveSetNeedsGraphLayout {
    [self setNeedsGraphLayout:YES];
    for (UIView *subview in self.subviews) {
        if ([subview isKindOfClass:[TreeNodeContainerView class]]) {
            [(TreeNodeContainerView *)subview recursiveSetNeedsGraphLayout];
        }
    }
}
- (void)recursiveSetConnectorsViewsNeedDisplay {
    [self.connectorsView setNeedsDisplay];
    
    NSArray *subviews = self.subviews;
    for (UIView *subview in subviews) {
        if ([subview isKindOfClass:[TreeNodeContainerView class]]) {
            [(TreeNodeContainerView *)subview recursiveSetConnectorsViewsNeedDisplay];
        }
    }
}
- (TreeNode *)nodeAtPoint:(CGPoint)point {
    NSArray *subviews = self.subviews;
    NSInteger count = subviews.count;
    NSInteger index;
    
    for (index = count - 1; index >= 0; index--) {
        UIView *subview = [subviews objectAtIndex:index];
        CGPoint subviewPoint = [subview convertPoint:point fromView:self];
        
        if ([subview pointInside:subviewPoint withEvent:nil]) {
            if (subview == [self.rootNode nodeView]) {
                return [self rootNode];
            } else if ([subview isKindOfClass:[TreeNodeContainerView class]]) {
                return [(TreeNodeContainerView *)subview nodeAtPoint:subviewPoint];
            } else {
                // ignore
            }
        }
    }
    
    return nil;
}

- (TreeNode *)nodeClosestToY:(CGFloat)y {
    NSArray *subviews = self.subviews;
    TreeNodeContainerView *containerWithClosestNode = nil;
    CGFloat closestNodeDistance = MAXFLOAT;
    
    for (UIView *subview in subviews) {
        if ([subview isKindOfClass:[TreeNodeContainerView class]]) {
            UIView *childNodeView = [(TreeNodeContainerView *)subview rootNode].nodeView;
            if (childNodeView) {
                CGRect rect = [self convertRect:childNodeView.bounds fromView:childNodeView];
                CGFloat nodeViewDistance = fabs(y - CGRectGetMidY(rect));
                if (nodeViewDistance < closestNodeDistance) {
                    closestNodeDistance = nodeViewDistance;
                    containerWithClosestNode = (TreeNodeContainerView *)subview;
                }
            }
        }
    }
    
    return [containerWithClosestNode rootNode];
}
- (TreeNode *)nodeClosestToX:(CGFloat)x {
    NSArray *subviews = self.subviews;
    TreeNodeContainerView *containerWithClosestNode = nil;
    CGFloat closestNodeDistance = MAXFLOAT;
    
    for (UIView *subview in subviews) {
        if ([subview isKindOfClass:[TreeNodeContainerView class]]) {
            UIView *childNodeView = [(TreeNodeContainerView *)subview rootNode].nodeView;
            if (childNodeView) {
                CGRect rect = [self convertRect:childNodeView.bounds fromView:childNodeView];
                CGFloat nodeViewDistance = fabs(x - CGRectGetMidX(rect));
                if (nodeViewDistance < closestNodeDistance) {
                    closestNodeDistance = nodeViewDistance;
                    containerWithClosestNode = (TreeNodeContainerView *)subview;
                }
            }
        }
    }
    
    return [containerWithClosestNode rootNode];
}

- (void)removeAllSubviews {
    for (UIView *subview in self.subviews) {
        [subview removeFromSuperview];
    }
}

- (void)dealloc {
    [_rootNode release];
    [_connectorsView release];
    [super dealloc];
}
@end
