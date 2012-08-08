//
//  ViewController.m
//  TreeNodeControl
//
//  Created by Evan Lucas on 8/8/12.
//  Copyright (c) 2012 Evan Lucas. All rights reserved.
//

#import "ViewController.h"
#import "TreeNodeRootItemView.h"
#import <QuartzCore/QuartzCore.h>
#define NUMBER_OF_PAGES_IN_LIBRARY 2

@implementation ViewController
@synthesize treeView = _treeView;
@synthesize scrollView = _scrollView;
@synthesize draggingView = _draggingView;
@synthesize droppableItems = _droppableItems;
@synthesize rootNode = _rootNode;
@synthesize libraryScrollView = _libraryScrollView;
@synthesize buttonLeft = _buttonLeft;
@synthesize buttonRight = _buttonRight;
@synthesize originalFrame = _originalFrame;
@synthesize itemsArray = _itemsArray;
@synthesize currentPage = _currentPage;
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.currentPage = 0;
    [self createLibraryItems];
    [self createBlankTree];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)viewDidUnload
{
    [self setButtonLeft:nil];
    [self setButtonRight:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}
- (void)createBlankTree {
    if (self.treeView) {
        [self.treeView removeFromSuperview];
    }
    if (self.rootNode) {
        [_rootNode release];
    }
    CGRect svRect = self.scrollView.bounds;
    CGRect beforeRect = CGRectMake(0, -svRect.size.height, svRect.size.width, svRect.size.height);
    self.treeView = [[TreeView alloc] initWithFrame:beforeRect];
    [self.treeView setDelegate:self];
    [self.scrollView addSubview:self.treeView];
    
    self.rootNode = [[TreeNode alloc] initWithNodeType:TreeNodeTypeRoot];
    
    [self.treeView setRootNode:self.rootNode relayout:NO];
    [UIView animateWithDuration:1.0 animations:^{
        [self.treeView setFrame:self.scrollView.bounds];
    }];
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}
- (CGRect)rectForItemAtIndex:(NSInteger)index {
    // Columns - 6
    // Rows - 1
    CGFloat x;
    CGFloat y = 0;
    CGFloat pageWidth = 670;
    CGFloat margin = 10;
    NSInteger page = index / 6;
    
    x = ((((index % 6) * margin) + (100*(index%6)) + margin) + (pageWidth*page));
    CGRect rect = CGRectMake(x, y, 100, 100);
    return rect;
}
- (void)createLibraryItems {
    self.itemsArray = [[NSMutableArray alloc] init];
    TreeNode *node1 = [[TreeNode alloc] initWithNodeType:TreeNodeTypeChildAcceptsSingle];
    [self.itemsArray addObject:node1];
    [node1 release];
    TreeNode *node2 = [[TreeNode alloc] initWithNodeType:TreeNodeTypeChildAcceptsMultiple];
    [self.itemsArray addObject:node2];
    [node2 release];
    TreeNode *node3 = [[TreeNode alloc] initWithNodeType:TreeNodeTypeChildAcceptsSingle];
    [self.itemsArray addObject:node3];
    [node3 release];
    TreeNode *node4 = [[TreeNode alloc] initWithNodeType:TreeNodeTypeChildAcceptsMultiple];
    [self.itemsArray addObject:node4];
    [node4 release];
    TreeNode *node5 = [[TreeNode alloc] initWithNodeType:TreeNodeTypeChildAcceptsSingle];
    [self.itemsArray addObject:node5];
    [node5 release];
    TreeNode *node6 = [[TreeNode alloc] initWithNodeType:TreeNodeTypeChildAcceptsMultiple];
    [self.itemsArray addObject:node6];
    [node6 release];
    TreeNode *node7 = [[TreeNode alloc] initWithNodeType:TreeNodeTypeChildAcceptsSingle];
    [self.itemsArray addObject:node7];
    [node7 release];
    TreeNode *node8 = [[TreeNode alloc] initWithNodeType:TreeNodeTypeChildAcceptsMultiple];
    [self.itemsArray addObject:node8];
    [node8 release];
    TreeNode *node9 = [[TreeNode alloc] initWithNodeType:TreeNodeTypeChildAcceptsSingle];
    [self.itemsArray addObject:node9];
    [node9 release];
    TreeNode *node10 = [[TreeNode alloc] initWithNodeType:TreeNodeTypeChildAcceptsMultiple];
    [self.itemsArray addObject:node10];
    [node10 release];
    TreeNode *node11 = [[TreeNode alloc] initWithNodeType:TreeNodeTypeChildAcceptsSingle];
    [self.itemsArray addObject:node11];
    [node11 release];
    TreeNode *node12 = [[TreeNode alloc] initWithNodeType:TreeNodeTypeChildAcceptsMultiple];
    [self.itemsArray addObject:node12];
    [node12 release];
    
    NSInteger index = 0;
    for (TreeNode *node in self.itemsArray) {
        UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(dragItem:)];
        [pan setDelegate:self];
        [node.nodeView setFrame:[self rectForItemAtIndex:index]];
        
        [node.nodeView addGestureRecognizer:pan];
        [self.libraryScrollView addSubview:node.nodeView];
        index++;
    }
    
    CGFloat totalWidth = NUMBER_OF_PAGES_IN_LIBRARY * 670;
    [self.libraryScrollView setContentSize:CGSizeMake(totalWidth, 100)];
    
}
- (void)getDroppables {
    if (self.droppableItems.count > 0) {
        [self.droppableItems removeAllObjects];
        [_droppableItems release];
    }
    self.droppableItems = [[NSMutableArray alloc] init];
    TreeNode *rootNode = self.treeView.rootNode;
    [self scanNode:rootNode];
}

- (void)scanNode:(TreeNode *)node {
    if ([node willAcceptChild]) {
        [self.droppableItems addObject:node];
    }
    if (node.childrenNodes.count > 0) {
        for (TreeNode *child in node.childrenNodes) {
            [self scanNode:child];
        }
    }
}

- (void)dragItem:(UIPanGestureRecognizer *)recognizer {
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        [self getDroppables];
        for (TreeNode *node in self.droppableItems) {
            UIView *view = node.nodeView;
            view.layer.borderColor = [UIColor grayColor].CGColor;
            view.layer.borderWidth = 4.0f;
            view.layer.cornerRadius = 10.0f;
        }
        self.draggingView = (TreeNodeItemView *)recognizer.view;
        self.originalFrame = self.draggingView.frame;
    } else if (recognizer.state == UIGestureRecognizerStateChanged) {
        CGRect rect = [self.libraryScrollView convertRect:self.draggingView.frame toView:self.view];
        [self.draggingView setFrame:rect];
        [self.view addSubview:self.draggingView];
        CGPoint loc = [recognizer locationInView:self.view];
        [self.draggingView setCenter:loc];
    } else if (recognizer.state == UIGestureRecognizerStateEnded) {
        for (int i=0; i<self.droppableItems.count; i++) {
            TreeNode *node = [self.droppableItems objectAtIndex:i];
            node.nodeView.layer.borderWidth = 0.0f;
        }
        
        CGPoint centerPoint = [self.scrollView convertPoint:self.draggingView.center fromView:self.view];
        TreeNode *droppableNode = [self.treeView nodeAtPoint:centerPoint];
        if (droppableNode && [self.droppableItems containsObject:droppableNode]) {
            TreeNode *draggableNode = [[TreeNode alloc] initWithNodeType:self.draggingView.node.nodeType];
            [droppableNode.childrenNodes addObject:draggableNode];
            [self.treeView setRootNode:self.rootNode relayout:YES];
            [draggableNode release];
        }
        
        [UIView animateWithDuration:0.3 animations:^{
            [self.draggingView setFrame:self.originalFrame];
            [self.libraryScrollView addSubview:self.draggingView];
        }];
    }
}
- (void)dealloc {
    [_rootNode release];
    [_treeView release];
    [_draggingView release];
    [_droppableItems release];
    [_libraryScrollView release];
    [_scrollView release];
    [_itemsArray release];
    [_buttonLeft release];
    [_buttonRight release];
    [super dealloc];
}
- (IBAction)goLeft:(id)sender {
    CGFloat width = 670;
    if (self.currentPage != 0) {
        [self.libraryScrollView setContentOffset:CGPointMake(width*self.currentPage - width, self.libraryScrollView.contentOffset.y) animated:YES];
        self.currentPage--;
    }
}

- (IBAction)goRight:(id)sender {
    CGFloat width = 670;
    
    if (self.currentPage != NUMBER_OF_PAGES_IN_LIBRARY) {
        [self.libraryScrollView setContentOffset:CGPointMake(width*self.currentPage + width, self.libraryScrollView.contentOffset.y) animated:YES];
        self.currentPage++;
    }
}

- (IBAction)tappedResetButton:(id)sender {
    [self createBlankTree];
}

- (void)configureNodeView:(UIView *)nodeView forNode:(TreeNode *)node {
    if (node.nodeType == TreeNodeTypeRoot) {
        TreeNodeRootItemView *v = (TreeNodeRootItemView *)node.nodeView;
        [v.titleLabel setText:@"Root"];
    }
}
@end
