//
//  FXDcontrollerMain.m
//  FXDDoubleTable
//
//  Created by petershine on 11/13/12.
//  Copyright (c) 2012 fXceed. All rights reserved.
//

#import "FXDcontrollerMain.h"


@implementation FXDcontrollerMain
- (void)viewDidLoad {
    [super viewDidLoad];	

	// In case of subTable instances not being loaded by NIB
	if (self.behindSubTable == nil) {
		self.behindSubTable = [[FXDcontrollerSubTable alloc] initWithNibName:nil bundle:nil];

		[self addChildViewController:self.behindSubTable];
	}

	if (self.frontSubTable == nil) {
		self.frontSubTable = [[FXDcontrollerSubTable alloc] initWithNibName:nil bundle:nil];

		[self addChildViewController:self.frontSubTable];
	}

	//MARK: Must distinguish between behind and front
	self.behindSubTable.isBehindSubTable = YES;


	if ([self.behindSubTable.view.superview isEqual:self.view] == NO) {
		[self.view addSubview:self.behindSubTable.view];

	}

	if ([self.frontSubTable.view.superview isEqual:self.view] == NO) {
		[self.view addSubview:self.frontSubTable.view];
	}

	
	// Initial configuration
	[self configureSubTablesForDoubleTableState:doubleTableStateMaxFront];
}


- (void)configureSubTablesForDoubleTableState:(DOUBLE_TABLE_STATE)doubleTableState {

	CGRect animatedFrontSubTableFrame = self.frontSubTable.view.frame;
	animatedFrontSubTableFrame.origin.y = [self frontSubTableOriginYforDoubleTableState:doubleTableState];

	// To show area of behindSubTable, covered by frontSubTable, modify content inset
	UIEdgeInsets modifiedBehindSubTableInset = self.behindSubTable.tableView.contentInset;
	modifiedBehindSubTableInset.bottom = (self.view.frame.size.height -animatedFrontSubTableFrame.origin.y);
	[self.behindSubTable.tableView setContentInset:modifiedBehindSubTableInset];

	// If frontSubTable is changed its frame, its tableView's bottom content area will be clipped,
	// and need modified inset to show the area if scrolled down
	UIEdgeInsets modifiedFrontSubTableInset = self.frontSubTable.tableView.contentInset;
	modifiedFrontSubTableInset.bottom = animatedFrontSubTableFrame.origin.y;
	[self.frontSubTable.tableView setContentInset:modifiedFrontSubTableInset];


	self.lastDoubleTableState = doubleTableState;

	[UIView animateWithDuration:0.3
						  delay:0
						options:UIViewAnimationCurveEaseOut
					 animations:^{
						 [self.frontSubTable.view setFrame:animatedFrontSubTableFrame];
					 }
					 completion:^(BOOL finished) {

						 // Because of using 2 scrollViews,
						 // responsibility for statusBar tapping should be interchanged appropriately
						 if (self.lastDoubleTableState == doubleTableStateMaxFront) {
							 self.behindSubTable.tableView.scrollsToTop = NO;
							 self.frontSubTable.tableView.scrollsToTop = YES;
						 }
						 else {
							 self.behindSubTable.tableView.scrollsToTop = YES;
							 self.frontSubTable.tableView.scrollsToTop = NO;
						 }
					 }];
}

- (CGFloat)frontSubTableOriginYforDoubleTableState:(DOUBLE_TABLE_STATE)doubleTableState {

	CGFloat frontSubTableOriginY = minimumHeightSubTable;

	//MARK: If you want different minimumHeight depending on item count of behindSubTable, utilize following snippet
	/*
	 if ([self.tableViewDataSource count] < maximumItemCount) {
	 frontSubTableOriginY = (heightSectionHeader +heightDefaultCell);

	 return frontSubTableOriginY;
	 }
	 */

	if (doubleTableState == doubleTableStateMaxFront) {
		return frontSubTableOriginY;
	}


	// If frontSubTable is minimized, use actual content height from behindSubTable instead,
	// only if it's smaller than maximumVisibleHeight

	CGFloat maximumVisibleHeight = self.view.frame.size.height -minimumHeightSubTable;

	CGFloat actualContentHeight = self.behindSubTable.tableView.contentSize.height;

	if (actualContentHeight > maximumVisibleHeight) {
		frontSubTableOriginY = maximumVisibleHeight;
	}
	else {
		frontSubTableOriginY = actualContentHeight;
	}

	return frontSubTableOriginY;
}


@end
