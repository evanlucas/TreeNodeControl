//
//  PSBaseSubtreeView.h
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



#import <UIKit/UIKit.h>
#import "TreeView.h"
#import "TreeNodeArrowView.h"
@class TreeNode;
@interface TreeNodeContainerView : UIView
@property (nonatomic, retain) TreeNode *rootNode;
@property (nonatomic, readonly) TreeView *treeView;
@property (nonatomic, assign) BOOL needsGraphLayout;
@property (nonatomic, retain) TreeNodeArrowView *connectorsView;

- (id)initWithNode:(TreeNode *)node;
- (CGSize)layoutGraphIfNeeded;
- (BOOL)needsGraphLayout;
- (void)recursiveSetNeedsGraphLayout;
- (void)recursiveSetConnectorsViewsNeedDisplay;
- (TreeNode *)nodeAtPoint:(CGPoint)point;
- (TreeNode *)nodeClosestToY:(CGFloat)y;
- (TreeNode *)nodeClosestToX:(CGFloat)x;
- (void)removeAllSubviews;
@end
