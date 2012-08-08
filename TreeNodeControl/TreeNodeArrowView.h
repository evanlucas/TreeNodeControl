//
//  PSBaseBranchView.h
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
@class TreeView;
@interface TreeNodeArrowView : UIView
@property (nonatomic, readonly) TreeView *treeView;
- (UIBezierPath *)path;
@end
