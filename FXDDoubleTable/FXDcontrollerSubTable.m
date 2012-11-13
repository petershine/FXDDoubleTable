//
//  FXDcontrollerSubTable.m
//  FXDDoubleTable
//
//  Created by petershine on 11/13/12.
//  Copyright (c) 2012 fXceed. All rights reserved.
//

#import "FXDcontrollerSubTable.h"

#import "FXDcontrollerMain.h"


@implementation FXDcontrollerSubTable

- (void)viewDidLoad {
    [super viewDidLoad];

	self.view.backgroundColor = [UIColor clearColor];

	//MARK: If this implementation is for behindSubTable,
	//Make sure isBehindSubTable is already assigned with YES by parentController,

	// In case of backgroundView is not loaded from NIB
	if (self.backgroundView == nil) {
		self.backgroundView = [[UIView alloc] initWithFrame:self.view.frame];

		self.backgroundView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;

		[self.view addSubview:self.backgroundView];
		[self.view sendSubviewToBack:self.backgroundView];
	}

	// In case of tableView is not loaded from NIB
	if (self.tableView == nil) {
		self.tableView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStylePlain];

		self.tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;

		[self.view addSubview:self.tableView];
		[self.view bringSubviewToFront:self.tableView];
	}

	if (self.tableView.dataSource == nil  || self.tableView.delegate == nil) {
		[self.tableView setDataSource:self];
		[self.tableView setDelegate:self];
	}


	if (self.isBehindSubTable) {
		self.backgroundView.backgroundColor = [UIColor darkGrayColor];
	}
	else {
		self.backgroundView.backgroundColor = [UIColor lightGrayColor];
	}

	self.tableView.backgroundColor = [UIColor clearColor];

	
	// Responsibility for statusBar tapping will be interchanged appropriately with other subTable
	self.tableView.scrollsToTop = NO;
}


#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 100;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];

    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];

		if (self.isBehindSubTable) {
			cell.textLabel.textColor = [UIColor whiteColor];
		}
		else {
			cell.textLabel.textColor = [UIColor blackColor];
		}
    }

	
    cell.textLabel.text = [NSString stringWithFormat:@"%d", indexPath.row];

    
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
	NSString *headerTitle = nil;

	if (self.isBehindSubTable) {
		headerTitle = @"Behind";
	}
	else {
		headerTitle = @"Front";
	}

	return headerTitle;
}


#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {

	//MARK: Ignore if scrolling is done with behindSubTable
	if (self.isBehindSubTable) {
		return;
	}


	FXDcontrollerMain *mainController = (FXDcontrollerMain*)self.parentViewController;

	// Ignore if user responsible tableView is not yet changed
	if (mainController.lastDoubleTableState != doubleTableStateMaxFront) {
		self.lastContentOffsetY = scrollView.contentOffset.y;
		return;
	}


	CGFloat frontSubTableOriginY = [mainController frontSubTableOriginYforDoubleTableState:mainController.lastDoubleTableState];

	CGRect modifiedFrame = self.view.frame;

	BOOL shouldModify = NO;

	//MARK: To skip bouncing state
	if (scrollView.contentOffset.y < 0.0) {
		if (modifiedFrame.origin.y < frontSubTableOriginY) {
			shouldModify = YES;
		}
	}
	else if (scrollView.contentOffset.y >= (scrollView.contentSize.height -scrollView.frame.size.height)) {
		// SKIP
	}
	else {
		shouldModify = YES;
	}


	if (shouldModify == NO) {
		self.lastContentOffsetY = scrollView.contentOffset.y;


		CGRect modifiedBackgroundFrame = self.backgroundView.frame;

		if (self.lastContentOffsetY < 0.0) {
			// While dragging down, to show behindSubTable,
			// keep the y of origin of backgroundView frame to be same as y of contentOffset of tableView
			
			modifiedBackgroundFrame.origin.y = 0.0 - self.lastContentOffsetY;

			[self.backgroundView setFrame:modifiedBackgroundFrame];
		}
		else {
			// No need to change backgroundView frame if tableView is dragging up

			if (modifiedBackgroundFrame.origin.y != 0.0) {
				modifiedBackgroundFrame.origin.y = 0.0;

				[self.backgroundView setFrame:modifiedBackgroundFrame];
			}
		}

		return;
	}


	CGFloat changedDistanceY = (scrollView.contentOffset.y -self.lastContentOffsetY);

	//MARK: If you want frontSubTable to cover whole view of mainController, assign 1 to shouldCoverWholeView
	CGFloat minimumOriginY = (shouldCoverWholeView) ? 0.0 : minimumHeightSubTable;

	if (changedDistanceY > minimumOriginY) {
		modifiedFrame.origin.y -= changedDistanceY;
	}
	else if (scrollView.contentOffset.y < frontSubTableOriginY || modifiedFrame.origin.y > minimumOriginY) {
		modifiedFrame.origin.y -= changedDistanceY;
	}


	// To keep y of origin to be reasonable value
	// Maybe needed if the user is scrolling too fast
	if (modifiedFrame.origin.y < minimumOriginY) {
		modifiedFrame.origin.y = minimumOriginY;
	}
	else if (modifiedFrame.origin.y > frontSubTableOriginY) {
		modifiedFrame.origin.y = frontSubTableOriginY;
	}

	[self.view setFrame:modifiedFrame];


	// Bottom area of tableView content will be clipped and need modified inset to show the area
	UIEdgeInsets modifiedInset = scrollView.contentInset;
	modifiedInset.bottom = modifiedFrame.origin.y;
	[scrollView setContentInset:modifiedInset];

	self.lastContentOffsetY = scrollView.contentOffset.y;
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
	FXDcontrollerMain *mainController = (FXDcontrollerMain*)self.parentViewController;

	DOUBLE_TABLE_STATE nextDoubleTableState = mainController.lastDoubleTableState;

	BOOL shouldConfigure = NO;

	// Configure frontSubTable only if doubleTableState is changed from last state
	if (self.isBehindSubTable) {
		if (nextDoubleTableState != doubleTableStateMinFront) {
			nextDoubleTableState = doubleTableStateMinFront;

			shouldConfigure = YES;
		}
	}
	else {
		if (nextDoubleTableState != doubleTableStateMaxFront) {
			nextDoubleTableState = doubleTableStateMaxFront;

			shouldConfigure = YES;
		}
	}

	if (shouldConfigure) {
		[mainController configureSubTablesForDoubleTableState:nextDoubleTableState];
	}
}


@end
