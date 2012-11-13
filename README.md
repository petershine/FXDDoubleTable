# FXDDoubleTable

Double layered tables, responsive to user scrolling

While front table is showing main items, behind table can show glimpse of sub items.
As the user touches and start dragging front or behind tables, heights of them are maximized or minimized to give comfortable scrolling space.

#### Customizable Definitions (Declared in [FXDcontrollerSubTable.h](https://github.com/petershine/FXDDoubleTable/blob/master/FXDDoubleTable/FXDcontrollerSubTable.h))
``` objective-c
#define heightDefaultCell  44.0	// Customizable if your tableViewCell height is different
#define heightSectionHeader	22.0	// Customizable if you use your own section header view

#define minimumHeightSubTable	(heightSectionHeader+(heightDefaultCell*2.0))	// Customizable to have fixed value

//MARK: If you want frontSubTable to cover whole view of mainController, assign 1 to shouldCoverWholeView
#define shouldCoverWholeView	0
```
While dragging down, to show behindSubTable, frontSubTable must have transparent background.
Also, when you drag down frontSubTable, unless tableView's backgroundColor is clearColor, revealed area is still opaque, not showing behindSubTable.
So tableView needs transparent background too.

However, a tableView with clearColor background makes its default cells to have clearColor background too.
This will put 2 tableViewCells to be overlapped back and forth causing visual annoyance.

Currently found my best solution is to use additional backgroundView behind tableView, and configure its frame dynamically while tableView is scrolling.

The key is keep the y of origin of backgroundView frame to be same as y of contentOffset of tableView.

#### Configuring *backgroundView* (Snippet within [FXDcontrollerSubTable.m](https://github.com/petershine/FXDDoubleTable/blob/master/FXDDoubleTable/FXDcontrollerSubTable.m))
```objective-c
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
```
