//
//  PSBaseTreeGraphView.h
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
#import "TreeNode.h"
@protocol TreeProtocol;
@class TreeNodeContainerView;
@interface TreeView : UIView

@property (nonatomic, retain) id delegate;

@property (nonatomic, retain) TreeNode *rootNode;

@property (nonatomic, retain) TreeNodeContainerView *rootContainerView;

@property (nonatomic, retain) NSMutableDictionary *modelNodeToSubtreeViewMapTable;

@property (nonatomic, assign) CGSize minimumFrameSize;

@property (nonatomic, retain) NSMutableArray *droppableNodes;

- (id)initWithFrame:(CGRect)frame;

- (TreeNodeContainerView *)newContainerForNode:(TreeNode *)node;

- (void)buildTree;

- (BOOL)needsGraphLayout;

- (void)updateFrameSizeForContentAndClipView;

- (void)updateRootContainerForSize:(CGSize)rootContainerSize;

- (TreeNode *)nodeAtPoint:(CGPoint)point;

- (void)scrollNodesToVisible:(NSSet *)nodes animated:(BOOL)animated;

- (CGRect)boundsOfNodes:(NSSet *)nodes;

- (void)setNeedsGraphLayout;

- (CGSize)layoutGraphIfNeeded;

- (void)setRootNode:(TreeNode *)rootNode relayout:(BOOL)relayout;

- (void)updateRootContainerForNode:(TreeNode *)node;

- (void)parentClipViewDidResize:(id)object;

@end

@interface TreeView (Internal)
- (TreeNodeContainerView *)subtreeViewForNode:(TreeNode *)node;
- (void)setSubtreeView:(TreeNodeContainerView *)subtreeView forNode:(TreeNode *)node;
@end
