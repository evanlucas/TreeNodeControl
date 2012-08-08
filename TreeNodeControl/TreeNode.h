//
//  PSTreeGraphNode.h
//  PSHTreeGraph
//
//  Created by Ed Preston on 8/8/12.
//  Copyright (c) 2012 Preston Software. All rights reserved.
//

//
// Modified By Evan Lucas
//
#import <Foundation/Foundation.h>
#import "TreeNodeProtocol.h"


@class TreeNodeContainerView;

typedef enum {
    TreeNodeTypeRoot = 0,
    TreeNodeTypeChildAcceptsSingle,
    TreeNodeTypeChildAcceptsMultiple
}TreeNodeType;

@interface TreeNode : NSObject <TreeNodeProtocol, NSCopying>
@property (nonatomic) TreeNodeType nodeType;
@property (nonatomic, retain) TreeNodeContainerView *containerView;
@property (nonatomic, retain) NSMutableArray *childrenNodes;
@property (nonatomic, getter = isRootNode) BOOL rootNode;
@property (nonatomic, retain) UIView *nodeView;
@property (nonatomic, readonly, getter = willAcceptChild) BOOL acceptsChild;
- (id)initWithNodeType:(TreeNodeType)nodeType;
@end
