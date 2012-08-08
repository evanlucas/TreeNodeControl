//
//  PSTreeGraphModelNode.h
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
//
//  TreeNodeProtocol.h
//  TreeNodeControl
//
//  Created by Evan Lucas on 8/8/12.
//  Copyright (c) 2012 Evan Lucas. All rights reserved.
//

#import <Foundation/Foundation.h>
@class TreeNode;
@protocol TreeProtocol <NSObject>
@required
- (void)configureNodeView:(UIView *)nodeView forNode:(TreeNode *)node;
@end

@protocol TreeNodeProtocol <NSObject>

@required
- (TreeNode *)parentNode;
- (NSArray *)childNodes;

@end
