//
//  FXDcontrollerSubTable.h
//  FXDDoubleTable
//
//  Created by petershine on 11/13/12.
//  Copyright (c) 2012 fXceed. All rights reserved.
//

#import <UIKit/UIKit.h>


// While dragging down, to show behindSubTable, frontSubTable must have transparent background
// Also, when you drag down frontSubTable, unless tableView's backgroundColor is clearColor,
// revealed area is still opaque, not showing behindSubTable.
// So tableView needs transparent background too.

// However, a tableView with clearColor background makes its default cells to have clearColor background too
// This will put 2 tableViewCells to be overlapped back and forth causing visual annoyance.

// Currently found my best solution is to use additional backgroundView behind tableView,
// and configure its frame dynamically while tableView is scrolling.

// The key is keep the y of origin of backgroundView frame to be same as y of contentOffset of tableView


#define heightDefaultCell	44.0	// Customizable if your tableViewCell height is different
#define heightSectionHeader	22.0	// Customizable if you use your own section header view

#define minimumHeightSubTable	(heightSectionHeader+(heightDefaultCell*2.0))	// Customizable to have fixed value

//MARK: If you want frontSubTable to cover whole view of mainController, assign 1 to shouldCoverWholeView
#define shouldCoverWholeView	0


typedef enum {
	doubleTableStateMaxFront,
	doubleTableStateMinFront,

} DOUBLE_TABLE_STATE;


@class FXDcontrollerMain;


@interface FXDcontrollerSubTable : UIViewController <UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate>

@property (assign, nonatomic) BOOL isBehindSubTable;
@property (assign, nonatomic) CGFloat lastContentOffsetY;

@property (strong, nonatomic) IBOutlet UIView *backgroundView;
@property (strong, nonatomic) IBOutlet UITableView *tableView;


@end
