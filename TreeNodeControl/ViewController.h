//
//  ViewController.h
//  TreeNodeControl
//
//  Created by Evan Lucas on 8/8/12.
//  Copyright (c) 2012 Evan Lucas. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TreeView.h"
#import "TreeNode.h"
#import "TreeNodeProtocol.h"
#import "TreeNodeItemView.h"
@interface ViewController : UIViewController <TreeProtocol, UIGestureRecognizerDelegate>
@property (nonatomic, retain) IBOutlet UIScrollView *scrollView;
@property (nonatomic, retain) TreeNode *rootNode;
@property (nonatomic, retain) TreeView *treeView;
@property (nonatomic, retain) TreeNodeItemView *draggingView;
@property (nonatomic, retain) NSMutableArray *droppableItems;
@property (nonatomic, retain) IBOutlet UIScrollView *libraryScrollView;
@property (retain, nonatomic) IBOutlet UIButton *buttonLeft;
@property (retain, nonatomic) IBOutlet UIButton *buttonRight;
@property (nonatomic) CGRect originalFrame;
@property (nonatomic, retain) NSMutableArray *itemsArray;
@property (nonatomic) NSInteger currentPage;

- (IBAction)goLeft:(id)sender;
- (IBAction)goRight:(id)sender;
- (IBAction)tappedResetButton:(id)sender;

@end
