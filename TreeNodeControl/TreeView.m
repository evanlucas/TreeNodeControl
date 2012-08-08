//
//  PSBaseTreeGraphView.m
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



#import "TreeView.h"
#import "TreeNodeProtocol.h"
#import "TreeNodeContainerView.h"
#import "TreeNodeItemView.h"
#import "TreeNodeRootItemView.h"
#define CONTENT_MARGIN 20.0f
#define PARENT_CHILD_SPACING 30.0f
#define SIBLING_SPACING 10.0f
#define LINE_WIDTH 1.0f
#define MIN_FRAME_SIZE CGSizeMake(2.0 * CONTENT_MARGIN, 2.0 * CONTENT_MARGIN)

@implementation TreeView
@synthesize rootNode = _rootNode;
@synthesize rootContainerView = _rootContainerView;
@synthesize modelNodeToSubtreeViewMapTable = _modelNodeToSubtreeViewMapTable;
@synthesize minimumFrameSize = _minimumFrameSize;
@synthesize droppableNodes = _droppableNodes;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.modelNodeToSubtreeViewMapTable = [[NSMutableDictionary alloc] initWithCapacity:10];
        self.minimumFrameSize = CGSizeMake(2.0*CONTENT_MARGIN, 2.0*CONTENT_MARGIN);
    }
    return self;
}

- (TreeNodeContainerView *)rootContainerView {
    return [self subtreeViewForNode:self.rootNode];
}

- (void)updateRootContainerForNode:(TreeNode *)node {
    TreeNodeContainerView *container = (TreeNodeContainerView *)node.containerView;
    if (container) {
        NSArray *childNodes = [node childrenNodes];
        
        if (childNodes != nil) {
            for (TreeNode *childNode in childNodes) {
                if (childNode.nodeView.superview == nil) {
                    TreeNodeContainerView *childContainer = [self newContainerForNode:childNode];
                    if (childContainer != nil) {
                        [container insertSubview:childContainer belowSubview:[[container rootNode] nodeView]];
                        [container recursiveSetNeedsGraphLayout];
                        [container recursiveSetConnectorsViewsNeedDisplay];
                        [self updateFrameSizeForContentAndClipView];
                    }
                }
                
            }
        }
        
    }
}

- (TreeNodeContainerView *)newContainerForNode:(TreeNode *)node {
    TreeNodeContainerView *container = [[TreeNodeContainerView alloc] initWithNode:node];
    if (container) {
        if ([self.delegate conformsToProtocol:@protocol(TreeProtocol)]) {
            [self.delegate configureNodeView:node.nodeView forNode:node];
            
        }
        
        [container addSubview:node.nodeView];
        [self setSubtreeView:container forNode:node];
        
        NSArray *childNodes = [node childrenNodes];
        
        if (childNodes != nil) {
            for (TreeNode *childNode in childNodes) {
                TreeNodeContainerView *childContainer = [self newContainerForNode:childNode];
                if (childContainer != nil) {
                    [container insertSubview:childContainer belowSubview:[[container rootNode] nodeView]];
                }
            }
        }
    }
    
    return container;
}

- (void)buildTree {
    @autoreleasepool {
        TreeNode *node = [self rootNode];
        if (node) {
            TreeNodeContainerView *container = [self newContainerForNode:node];
            if (container) {
                [self addSubview:container];
            }
        }
    }
}

- (void)updateFrameSizeForContentAndClipView {
    CGSize newFrameSize;
    CGSize newFrameMinSize = self.minimumFrameSize;
    
    UIScrollView *enclosingScrollView = (UIScrollView *)self.superview;
    if (enclosingScrollView) {
        CGRect contentViewBounds = [enclosingScrollView bounds];
        newFrameSize.width = MAX(newFrameMinSize.width, contentViewBounds.size.width);
        newFrameSize.height = MAX(newFrameMinSize.height, contentViewBounds.size.height);
        [enclosingScrollView setContentSize:newFrameSize];
    }
    
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, newFrameSize.width, newFrameSize.height);
}

- (void)updateRootContainerForSize:(CGSize)rootContainerSize {
    TreeNodeContainerView *container = [self rootContainerView];
    CGPoint newOrigin;
    CGRect bounds = [self bounds];
    
    newOrigin = CGPointMake(0.5 * (bounds.size.width - rootContainerSize.width), CONTENT_MARGIN);
    container.frame = CGRectMake(newOrigin.x, newOrigin.y, container.frame.size.width, container.frame.size.height);
}

- (void)parentClipViewDidResize:(id)object {
    UIScrollView *enclosingScrollView = (UIScrollView *)self.superview;
    if (enclosingScrollView && [enclosingScrollView isKindOfClass:[UIScrollView class]]) {
        [self updateFrameSizeForContentAndClipView];
        [self updateRootContainerForSize:[self rootContainerView].frame.size];
        
        //
        
    }
}

- (void)layoutSubviews {
    [self layoutGraphIfNeeded];
}
- (void)setRootNode:(TreeNode *)rootNode relayout:(BOOL)relayout{
    if (_rootNode != rootNode || relayout == YES) {
        
        TreeNodeContainerView *rootContainer = [self rootContainerView];
        [rootContainer removeFromSuperview];
        [self.modelNodeToSubtreeViewMapTable removeAllObjects];
        _rootNode = rootNode;
        [self buildTree];
        [self setNeedsDisplay];
        [self layoutGraphIfNeeded];
    }
    
}

- (CGSize)layoutGraphIfNeeded {
    TreeNodeContainerView *container = [self rootContainerView];
    if ([self needsGraphLayout] && [self rootNode]) {
        CGSize rootSize = [container layoutGraphIfNeeded];
        CGFloat margin = CONTENT_MARGIN;
        CGSize minBoundsSize = CGSizeMake(rootSize.width + 2.0 * margin, rootSize.height + 2.0 * margin);
        [self setMinimumFrameSize:minBoundsSize];
        
        [self updateFrameSizeForContentAndClipView];
        
        [self updateRootContainerForSize:rootSize];
        return rootSize;
    } else {
        return container ? [container frame].size : CGSizeZero;
    }
}

- (BOOL)needsGraphLayout {
    return [[self rootContainerView] needsGraphLayout];
}

- (void)setNeedsGraphLayout {
    [[self rootContainerView] recursiveSetNeedsGraphLayout];
}
- (CGRect)boundsOfNodes:(NSSet *)nodes {
    CGRect boundingBox = CGRectZero;
    BOOL firstNodeFound = NO;
    for (TreeNode *node in nodes) {
        TreeNodeContainerView *container = [self subtreeViewForNode:node];
        if (container) {
            UIView *nodeView = [container rootNode].nodeView;
            if (nodeView) {
                CGRect rect = [self convertRect:[nodeView bounds] fromView:nodeView];
                if (!firstNodeFound) {
                    boundingBox = rect;
                    firstNodeFound = YES;
                } else {
                    boundingBox = CGRectUnion(boundingBox, rect);
                }
            }
        }
    }
    return boundingBox;
}

- (void)scrollNodesToVisible:(NSSet *)nodes animated:(BOOL)animated {
    CGRect targetRect = [self boundsOfNodes:nodes];
    if (!CGRectIsEmpty(targetRect)) {
        CGFloat padding = CONTENT_MARGIN;
        
        UIScrollView *parent = (UIScrollView *)self.superview;
        if (parent && [parent isKindOfClass:[UIScrollView class]]) {
            targetRect = CGRectInset(targetRect, -padding, -padding);
            [parent scrollRectToVisible:targetRect animated:animated];
        }
    }
}

- (TreeNode *)nodeAtPoint:(CGPoint)point {
    TreeNodeContainerView *container = [self rootContainerView];
    CGPoint subviewPoint = [self convertPoint:point toView:container];
    TreeNode *node = [[self rootContainerView] nodeAtPoint:subviewPoint];
    return node;
}
@end
@implementation TreeView (Internal)
- (TreeNodeContainerView *)subtreeViewForNode:(TreeNode *)node {
    return [self.modelNodeToSubtreeViewMapTable objectForKey:node];
}

- (void)setSubtreeView:(TreeNodeContainerView *)subtreeView forNode:(TreeNode *)node {
    [self.modelNodeToSubtreeViewMapTable setObject:subtreeView forKey:node];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (void)dealloc {
    [_delegate release];
    [_rootNode release];
    [_rootContainerView release];
    [_modelNodeToSubtreeViewMapTable release];
    [_droppableNodes release];
    [super dealloc];
}
@end
