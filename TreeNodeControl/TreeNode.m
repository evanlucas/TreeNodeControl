//
//  PSTreeGraphNode.m
//  PSHTreeGraph
//
//  Created by Ed Preston on 8/8/12.
//  Copyright (c) 2012 Preston Software. All rights reserved.
//

//
// Modified By Evan Lucas
//

#import "TreeNode.h"
#import "TreeNodeRootItemView.h"
#import "TreeNodeItemView.h"
#import "TreeNodeContainerView.h"
@implementation TreeNode
@synthesize nodeType = _nodeType;
@synthesize acceptsChild = _acceptsChild;
@synthesize rootNode = _rootNode;
@synthesize childrenNodes = _childrenNodes;
@synthesize containerView = _containerView;
@synthesize nodeView = _nodeView;

- (id)initWithNodeType:(TreeNodeType)nodeType {
    if (self = [super init]) {
        self.nodeType = nodeType;
        self.childrenNodes = [[NSMutableArray alloc] init];
        [self createNodeView];
    }
    return self;
}

- (void)createNodeView {
    if (self.nodeType == TreeNodeTypeRoot) {
        TreeNodeRootItemView *nv = [[TreeNodeRootItemView alloc] initWithFrame:CGRectMake(0, 0, 300, 80)];
        nv.node = self;
        nv.titleLabel.text = @"Root Node";
        nv.imageViewIcon.image = [UIImage imageNamed:@"1"];
        self.nodeView = (TreeNodeRootItemView *)[nv retain];
    } else {
        TreeNodeItemView *nv = [[TreeNodeItemView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
        nv.node = self;
        nv.titleLabel.text = @"Item Title";
        NSMutableArray *images = [[NSMutableArray alloc] init];
        [images addObject:@"1"];
        [images addObject:@"2"];
        [images addObject:@"3"];
        [images addObject:@"4"];
        NSInteger index = (arc4random() % images.count);
        nv.imageViewIcon.image = [UIImage imageNamed:[images objectAtIndex:index]];
        self.nodeView = (TreeNodeItemView *)[nv retain];
    }
}
- (BOOL)willAcceptChild {
    switch (self.nodeType) {
        case TreeNodeTypeRoot:
        {
            if (self.childrenNodes.count == 1) {
                return NO;
            }
            return YES;
        }
            break;
        case TreeNodeTypeChildAcceptsMultiple:
        {
            return YES;
        }
            break;
        case TreeNodeTypeChildAcceptsSingle:
        {
            if (self.childrenNodes.count == 1) {
                return NO;
            }
            return YES;
        }
        default:
        {
            return NO;
        }
            break;
    }
    return NO;
}

- (BOOL)isRootNode {
    if (self.nodeType = TreeNodeTypeRoot) {
        return YES;
    }
    return NO;
}

- (id)copyWithZone:(NSZone *)zone {
    return [self retain];
}
- (TreeNode *)parentNode {
    return self.parentNode;
}
- (NSArray *)childNodes {
    return self.childrenNodes;
}
- (void)dealloc {
    [_containerView release];
    [_childrenNodes release];
    [_nodeView release];
    [super dealloc];
}
@end
